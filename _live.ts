import {env} from 'cloudflare:workers';
import {protect,reveal} from '../admin/mp-test/_config';

type LiveConfig={tokenCipher:string;webhookCipher:string;enabled:number;priceCents:number};
export async function liveConfig(){if(!env.DB)throw Error('Banco indisponível');return env.DB.prepare("SELECT token_cipher AS tokenCipher,webhook_cipher AS webhookCipher,enabled,price_cents AS priceCents FROM mp_live_config WHERE id='primary'").first<LiveConfig>()}
export async function monthlyPriceCents(){return (await liveConfig())?.priceCents??4999}
export {protect,reveal};
export async function liveMp(path:string,options:RequestInit={}){
 const config=await liveConfig();if(!config?.enabled)throw Error('Cobrança real indisponível.');
 const response=await fetch('https://api.mercadopago.com'+path,{...options,headers:{Authorization:'Bearer '+await reveal(config.tokenCipher),'Content-Type':'application/json',...options.headers},signal:AbortSignal.timeout(15000)});
 const data:any=await response.json().catch(()=>({}));if(!response.ok)throw Error('Mercado Pago recusou a solicitação ('+response.status+').');return data;
}
export async function reconcile(subscription:{id:string;storeId:string;providerId:string}){
 const db=env.DB;if(!db)throw Error('Banco indisponível');const info=await liveMp('/preapproval/'+encodeURIComponent(subscription.providerId));
 if(String(info.id)!==subscription.providerId||info.external_reference!=='agra-live:'+subscription.id)throw Error('Assinatura não corresponde ao cadastro.');
 const stored=await db.prepare('SELECT price_cents AS priceCents FROM mp_live_subscriptions WHERE id=?').bind(subscription.id).first<{priceCents:number}>();
 const expected=stored?.priceCents??4999;
 const status=String(info.status||'unknown');
 await db.prepare('UPDATE mp_live_subscriptions SET status=?,updated_at=? WHERE id=?').bind(status,new Date().toISOString(),subscription.id).run();
 if(!['authorized','canceled'].includes(status))return status;
 const bills=await liveMp('/authorized_payments/search?preapproval_id='+encodeURIComponent(subscription.providerId)+'&limit=50');
 for(const bill of Array.isArray(bills.results)?bills.results:[]){
  const paymentId=String(bill.payment?.id||''),amount=Math.round(Number(bill.transaction_amount)*100),date=String(bill.debit_date||bill.date_created||'');
  if(bill.preapproval_id!==subscription.providerId||bill.payment?.status!=='approved'||bill.currency_id!=='BRL'||amount!==expected||!/^[0-9]+$/.test(paymentId)||!Number.isFinite(Date.parse(date)))continue;
  const paidAt=new Date(date).toISOString(),until=new Date(paidAt);until.setUTCMonth(until.getUTCMonth()+1);
  const inserted=await db.prepare('INSERT OR IGNORE INTO mp_live_payments(payment_id,subscription_id,store_id,paid_at,amount_cents) VALUES(?,?,?,?,?)').bind(paymentId,subscription.id,subscription.storeId,paidAt,expected).run();
  if(inserted.meta.changes)await db.prepare("UPDATE stores SET paid_until=CASE WHEN paid_until IS NULL OR paid_until<? THEN ? ELSE paid_until END,plan='mensal' WHERE id=?").bind(until.toISOString().slice(0,10),until.toISOString().slice(0,10),subscription.storeId).run();
 }
 return status;
}
