export type InvoiceFiltersValue={query:string;from:string;to:string;type:'all'|'missing'|'surplus'|'extra'};
export const emptyInvoiceFilters:InvoiceFiltersValue={query:'',from:'',to:'',type:'all'};
type FilterableInvoice={number:string;supplier:string;createdAt:string;hasMissing?:number;hasSurplus?:number;hasExtra?:number};
const localDate=new Intl.DateTimeFormat('sv-SE',{timeZone:'America/Fortaleza',year:'numeric',month:'2-digit',day:'2-digit'});
export function normalizeSearch(value:string){return value.normalize('NFD').replace(/\p{Diacritic}/gu,'').toLowerCase()}
export function matchesInvoice(row:FilterableInvoice,filters:InvoiceFiltersValue){
 const query=normalizeSearch(filters.query.trim());if(query&&!normalizeSearch(row.number+' '+row.supplier).includes(query))return false;
 if(filters.from||filters.to){const date=new Date(row.createdAt);if(!Number.isFinite(date.getTime()))return false;const day=localDate.format(date);if(filters.from&&day<filters.from||filters.to&&day>filters.to)return false}
 if(filters.type==='missing'&&!row.hasMissing)return false;
 if(filters.type==='surplus'&&!row.hasSurplus)return false;
 if(filters.type==='extra'&&!row.hasExtra)return false;
 return true;
}
