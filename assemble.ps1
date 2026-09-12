# questions/*.json + app-template.html -> cpp-dojo.html 조립 스크립트
# 사용법: 이 폴더에서  powershell -ExecutionPolicy Bypass -File .\assemble.ps1
$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$qdir = Join-Path $here "questions"
$template = Join-Path $here "app-template.html"
$outFile = Join-Path $here "cpp-dojo.html"

$utf8 = New-Object System.Text.UTF8Encoding($false)
$parts = New-Object System.Collections.Generic.List[string]
$fail = $false

# g01, g02, ... p01 ... 이름순 정렬 = num순 정렬이 되도록 파일명을 유지할 것
$files = Get-ChildItem $qdir -Filter *.json | Sort-Object Name
foreach ($f in $files) {
    $raw = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8).TrimStart([char]0xFEFF).Trim()
    try {
        $obj = $raw | ConvertFrom-Json
        $qn = @($obj.questions).Count
        $cn = @($obj.coding).Count
        Write-Output ("OK      {0}  q={1} c={2}" -f $f.BaseName, $qn, $cn)
        $parts.Add($raw)
    } catch {
        Write-Output ("BADJSON {0} : {1}" -f $f.BaseName, $_.Exception.Message)
        $fail = $true
    }
}
if ($fail) { Write-Output "ASSEMBLY ABORTED"; exit 1 }

$json = '{"generated":"' + (Get-Date -Format "yyyy-MM-dd") + '","chapters":[' + ($parts -join ",`n") + ']}'
$json = $json.Replace("</", "<\/")
$json = $json.Replace([string][char]0x2028, " ").Replace([string][char]0x2029, " ")

$tpl = [System.IO.File]::ReadAllText($template, [System.Text.Encoding]::UTF8)
if (-not $tpl.Contains("__QUIZ_DATA_JSON__")) { Write-Output "MARKER NOT FOUND"; exit 1 }
$content = $tpl.Replace("__QUIZ_DATA_JSON__", $json)
[System.IO.File]::WriteAllText($outFile, $content, $utf8)
Write-Output ("WROTE " + $outFile + "  bytes=" + (Get-Item $outFile).Length)

# GitHub Pages용 index.html: viewport 포함 완전한 HTML 문서로 래핑
$indexFile = Join-Path $here "index.html"
$wrapped = "<!doctype html>`n<html lang=`"ko`">`n<head>`n<meta charset=`"utf-8`">`n<meta name=`"viewport`" content=`"width=device-width, initial-scale=1, viewport-fit=cover`">`n<meta name=`"theme-color`" content=`"#15171C`">`n</head>`n<body>`n" + $content + "`n</body>`n</html>"
[System.IO.File]::WriteAllText($indexFile, $wrapped, $utf8)
Write-Output ("WROTE " + $indexFile + "  bytes=" + (Get-Item $indexFile).Length)
