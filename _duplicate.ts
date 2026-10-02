import {env} from 'cloudflare:workers';
import {json} from '../_db';
type ExistingInvoice={id:string;number:string;supplier:string;checkerName:string;completedAt:string|null;purchasingEntry:number|null;hasDivergence:number|null};
export async function findExisting(db:NonNullable<typeof env.DB>,storeId:string,accessKey:string){return db.prepare('SELECT i.id,i.number,i.supplier,i.checker_name AS checkerName,i.completed_at AS completedAt,i.purchasing_entry AS purchasingEntry,i.has_divergence AS hasDivergence FROM invoice_import_keys k JOIN invoices i ON i.id=k.invoice_id AND i.store_id=k.store_id WHERE k.store_id=? AND k.access_key=?').bind(storeId,accessKey).first<ExistingInvoice>()}
export function duplicateResponse(existing:ExistingInvoice){return json({error:`A NF-e ${existing.number} já está cadastrada nesta loja.`,existingId:existing.id,existingInvoice:existing},409)}
