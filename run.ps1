# ==============================================================================
# NetSwift Pro - Yönetici Yetkisi Kontrolü ve Güvenli İndirme Motoru
# ==============================================================================

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "                 NetSwift Pro - Ag Komutani Baslatiliyor              " -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

# Yönetici yetkisi kontrolü
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[!] NetSwift, ag bagdastiricilarina hukmedebilmek icin Yonetici iznine ihtiyac duyar." -ForegroundColor Yellow
    Write-Host "[*] Lutfen UAC penceresinde 'Evet' secenegini tiklayin." -ForegroundColor White
    Write-Host ""

    try {
        Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"irm https://raw.githubusercontent.com/cyberQbit/NetSwift/main/run.ps1 | iex`"" -Verb RunAs
    } catch {
        Write-Host "[X] Yonetici yetkileri alinamadi!" -ForegroundColor Red
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
    exit
}

Write-Host "[OK] Yonetici yetkileri dogrulandi! Ag modulleri aktif." -ForegroundColor Green
Write-Host "[*] NetSwift motoru indiriliyor..." -ForegroundColor Cyan

# Aracı indir ve LF->CRLF format dönüşümünü zorla (Çökmeleri engeller)
$batPath = "$env:TEMP\NetSwift.bat"
try {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/cyberQbit/NetSwift/main/NetSwift.bat" -OutFile $batPath -UseBasicParsing
    
    # === LINUX (LF) FORMATINI WINDOWS (CRLF) FORMATINA ZORLA VE BOM'U YOK ET ===
    $content = Get-Content $batPath -Raw
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($batPath, $content, $utf8NoBom)
    
    Write-Host "[OK] Motor basariyla hazirlandi!" -ForegroundColor Green
    Write-Host "[*] Arayuz aciliyor..." -ForegroundColor Cyan
    Start-Sleep -Milliseconds 500
    Start-Process -FilePath $batPath -Wait
} catch {
    Write-Host "[X] NetSwift indirilemedi! Baglantinizi kontrol edin." -ForegroundColor Red
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
