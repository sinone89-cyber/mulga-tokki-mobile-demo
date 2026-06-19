# 📱 물가의 토끼 — 모바일 (PWA)

데스크톱판([mulga-tokki](https://github.com/sinone89-cyber/mulga-tokki))을 포크한 **모바일 전용** 버전.
**가로(랜드스케이프) 고정 · 터치 조작 · PWA(설치형 웹).**

## 실행 / 테스트
- 로컬: `powershell -ExecutionPolicy Bypass -File serve.ps1 -Port 8060` → http://localhost:8060/
- 모바일 실기기: HTTPS 호스팅(GitHub Pages 등)에 올려 폰 브라우저로 접속(홈화면 추가 → PWA 설치).

## 데스크톱판과의 차이 (전환 작업)
- 가방 드래그: HTML5 네이티브 DnD → **Pointer Events**(터치 지원)
- **가로 고정**(orientation lock) + 세로 시 회전 안내
- 터치 뷰포트(핀치줌 잠금·safe-area·100dvh), 탭타깃 확대
- 데스크톱 전용 제거: 컴패니언/미니/트레이/작업표시줄 펫/Tauri
- PWA: manifest + service worker(오프라인 캐시)
- (예정) 배경 리소스 경량화

자세한 계획: 데스크톱 레포 `mobile/PLAN.md` 참고.
