const C='capital18-v4';
const FILES=['./','./index.html','./manifest.webmanifest','./icon-192.png','./icon-512.png','./icon-maskable-512.png','./apple-touch-icon.png'];
self.addEventListener('install',e=>{e.waitUntil(caches.open(C).then(c=>c.addAll(FILES)).then(()=>self.skipWaiting()))});
self.addEventListener('activate',e=>{e.waitUntil(caches.keys().then(k=>Promise.all(k.filter(x=>x!==C).map(x=>caches.delete(x)))).then(()=>self.clients.claim()))});
// Doar fișierele aplicației se pun în cache; cererile către Supabase merg mereu direct pe internet.
self.addEventListener('fetch',e=>{if(e.request.method!=='GET'||new URL(e.request.url).origin!==self.location.origin)return;e.respondWith(fetch(e.request).then(r=>{const cp=r.clone();caches.open(C).then(c=>c.put(e.request,cp)).catch(()=>{});return r}).catch(()=>caches.match(e.request).then(r=>r||caches.match('./index.html'))))});
// Notificări push (vin de la Supabase, chiar și cu aplicația închisă)
self.addEventListener('push',e=>{let d={};try{d=e.data?e.data.json():{}}catch(x){d={body:e.data&&e.data.text()}}
 e.waitUntil(self.registration.showNotification(d.title||'Capital18',{body:d.body||'',icon:'icon-192.png',badge:'icon-192.png',tag:d.tag||undefined,renotify:!!d.tag,data:{url:d.url||'./index.html'}}))});
self.addEventListener('notificationclick',e=>{e.notification.close();
 const url=new URL((e.notification.data&&e.notification.data.url)||'./index.html',self.registration.scope);
 e.waitUntil(self.clients.matchAll({type:'window',includeUncontrolled:true}).then(cs=>{
  const c=cs.find(x=>x.url.startsWith(self.registration.scope));
  if(c){c.postMessage({go:url.hash||'#/learn'});return c.focus()}
  return self.clients.openWindow(url.href)}))});
