// 물가의 토끼 모바일 — 서비스워커 (network-first + 오프라인 캐시 폴백)
const CACHE = 'mulga-mobile-v3';

self.addEventListener('install', e => { self.skipWaiting(); });
self.addEventListener('activate', e => {
  e.waitUntil((async () => {
    const keys = await caches.keys();
    await Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)));
    await self.clients.claim();
  })());
});

// 같은 출처 GET: 네트워크 우선(최신 반영) → 실패 시 캐시(오프라인). 성공분은 캐시에 갱신.
self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;
  let sameOrigin = false;
  try { sameOrigin = new URL(req.url).origin === self.location.origin; } catch (_) {}
  if (!sameOrigin) return;
  e.respondWith((async () => {
    const cache = await caches.open(CACHE);
    try {
      const res = await fetch(req);
      if (res && res.status === 200) cache.put(req, res.clone());
      return res;
    } catch (_) {
      const hit = await cache.match(req);
      return hit || Response.error();
    }
  })());
});
