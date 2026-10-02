import {env} from 'cloudflare:workers';
import {json} from '../_db';
export function conferenceToken(request:Request){const value=request.headers.get('X-Agra-Conference-ID')||'';return /^[a-f0-9-]{36}$/.test(value)?value:null}
export const leaseCondition='EXISTS(SELECT 1 FROM conference_locks l WHERE l.invoice_id=? AND l.store_id=? AND l.holder_token=? AND l.expires_at>?)';
export async function requireConference(request:Request,db:NonNullable<typeof env.DB>,storeId:string,id:string){
 const token=conferenceToken(request);if(!token)return {error:json({error:'Atualize a página para iniciar uma conferência protegida.'},423)};
 const now=new Date().toISOString(),expiresAt=new Date(Date.now()+120000).toISOString();
 const lock=await db.prepare('UPDATE conference_locks SET expires_at=?,updated_at=? WHERE invoice_id=? AND store_id=? AND holder_token=? AND expires_at>? RETURNING invoice_id').bind(expiresAt,now,id,storeId,token,now).first();
 if(!lock)return {error:json({error:'Esta nota está em consulta ou a reserva expirou. Assuma a conferência antes de alterar as contagens.'},423)};
 return {token,now,args:[id,storeId,token,now] as [string,string,string,string]};
}
