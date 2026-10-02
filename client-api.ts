let conferenceId:string|undefined;
export function getConferenceId(){return conferenceId??=(crypto.randomUUID())}
export class ApiError extends Error {constructor(message:string,public status:number,public data:Record<string,any>){super(message);this.name='ApiError'}}
// Share only requests currently in flight; completed responses are never cached.
const pending = new Map<string, Promise<any>>();
export function api(url: string, options?: RequestInit, storeId?: string): Promise<any> {
  const key = JSON.stringify([storeId||'',url]);
  const read = !options?.method || options.method.toUpperCase() === 'GET';
  const share = read && !options?.signal && !options?.headers;
  if (share && pending.has(key)) return pending.get(key)!;
  const request = (async () => {
    const response = await fetch(url, {...options, headers: {'Content-Type': 'application/json','X-Agra-Conference-ID':getConferenceId(), ...(storeId?{'X-Agra-Store-ID':storeId}:{}), ...options?.headers}, cache: 'no-store'});
    const data: any = await response.json();
    if (!response.ok) {
      if (response.status === 401) window.dispatchEvent(new Event('agra-session-expired'));
      throw new ApiError(data.error || 'Não foi possível concluir.',response.status,data);
    }
    return data;
  })();
  if (share) {
    pending.set(key, request);
    const cleanup = () => { if (pending.get(key) === request) pending.delete(key); };
    request.then(cleanup, cleanup);
  }
  return request;
}
