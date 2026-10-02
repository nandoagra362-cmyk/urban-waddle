import {findExisting,duplicateResponse} from '../_duplicate';
import {context,json,failure,coverage} from '../../_db';
export async function POST(request:Request){try{
 const c=await context(request);if('error'in c)return c.error;if(!c.store)return json({error:'Cadastre sua farmácia primeiro.'},400);const payment=coverage(c.store);if(payment)return payment;
 const body=await request.json() as {key?:string};const key=String(body.key||'').replace(/\s/g,'');if(!/^\d{44}$/.test(key)||key.slice(20,22)!=='55')return json({error:'Informe uma chave de NF-e modelo 55 com 44 dígitos.'},400);
 const existing=await findExisting(c.db,c.store.id,key);if(existing)return duplicateResponse(existing);
 let response:Response;try{response=await fetch('https://consultadanfe.com/api/v1/consulta',{method:'POST',headers:{'Content-Type':'application/json','Accept':'application/json'},body:JSON.stringify({chave:key,format:'json'}),signal:AbortSignal.timeout(20000)})}catch{return json({error:'A consulta demorou demais ou está indisponível. Você ainda pode importar o XML.'},504)}
 const raw=await response.text();if(raw.length>12_000_000)return json({error:'A resposta da consulta é grande demais. Importe o XML diretamente.'},502);
 let result:{status?:string;chave?:string;xml_base64?:string;error?:string;message?:string;codigo?:string};try{result=JSON.parse(raw)}catch{return json({error:'A consulta não retornou dados válidos. Importe o XML diretamente.'},502)}
 if(!response.ok||result.status!=='ok'){const unavailable=result.codigo==='data_fora_da_janela'||raw.includes('data_fora_da_janela');return json({error:unavailable?'A API consulta apenas notas do mês corrente (ou do mês anterior até o dia 15). Para esta nota, importe o XML.':'Não foi possível obter o XML por essa chave. Confira a chave ou importe o arquivo XML.'},response.status===429?429:502)}
 if(result.chave&&result.chave!==key)return json({error:'A consulta retornou outra chave. A nota não foi importada.'},502);
 if(!result.xml_base64||result.xml_base64.length>7_000_000)return json({error:'A consulta não retornou o XML completo. Importe o arquivo XML.'},502);
 let xml:string;try{const binary=atob(result.xml_base64);xml=new TextDecoder('utf-8',{fatal:true}).decode(Uint8Array.from(binary,ch=>ch.charCodeAt(0)))}catch{return json({error:'O XML retornado não pôde ser lido. Importe o arquivo XML.'},502)}
 if(!xml.includes('<infNFe')||xml.length>5_000_000||!xml.includes(key))return json({error:'O XML retornado não corresponde à chave consultada. A nota não foi importada.'},502);
 return json({xml});
}catch(e){return failure(e)}}
