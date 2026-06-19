# 물가의 토끼 로컬 서버 — 이 스크립트가 있는 폴더를 http://localhost:<포트> 로 서빙
# 실행:  powershell -ExecutionPolicy Bypass -File serve.ps1            (기본 8080)
#        powershell -ExecutionPolicy Bypass -File serve.ps1 -Port 8090 (포트 지정)
param([int]$Port = 8080)
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Start()
Write-Host "서빙 중: $root  →  http://localhost:$Port/fishing.html  (Ctrl+C 로 종료)"
while ($listener.IsListening) {
  $ctx = $listener.GetContext()
  $path = $ctx.Request.Url.LocalPath.TrimStart('/')
  if ([string]::IsNullOrEmpty($path)) { $path = "fishing.html" }
  $file = Join-Path $root ([Uri]::UnescapeDataString($path))
  if (Test-Path $file -PathType Leaf) {
    $bytes = [System.IO.File]::ReadAllBytes($file)
    $ext = [System.IO.Path]::GetExtension($file).ToLower()
    $ct = switch ($ext) { ".html"{"text/html; charset=utf-8"} ".js"{"application/javascript"} ".css"{"text/css"} ".png"{"image/png"} ".jpg"{"image/jpeg"} ".webp"{"image/webp"} ".mp3"{"audio/mpeg"} default{"application/octet-stream"} }
    $ctx.Response.ContentType = $ct
    # 캐시 끄기: 리소스 교체 시 브라우저가 옛 이미지를 쓰지 않도록(개발용)
    $ctx.Response.AddHeader("Cache-Control","no-store, no-cache, must-revalidate")
    $ctx.Response.AddHeader("Pragma","no-cache")
    $ctx.Response.AddHeader("Expires","0")
    $ctx.Response.OutputStream.Write($bytes,0,$bytes.Length)
  } else { $ctx.Response.StatusCode = 404 }
  $ctx.Response.Close()
}
