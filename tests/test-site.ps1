param(
    [string]$Root = ""
)

$ErrorActionPreference = "Stop"

if (-not $Root) {
    $Root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
}

Add-Type -AssemblyName System.IO.Compression.FileSystem

$releaseNotesPath = Join-Path $Root "RELEASE_NOTES.md"
$releaseNotes = Get-Content -Raw -Encoding UTF8 $releaseNotesPath
if ($releaseNotes -notmatch '(?m)^# PuTTY-Assistant v(?<version>\d+\.\d+\.\d+)\s*$') {
    throw "Could not determine the current release version from RELEASE_NOTES.md"
}
$version = $Matches.version
$archiveName = "PuTTY-AI-v$version-windows-x64.zip"

$packageArchive = Join-Path $Root "package\\$archiveName"
$packageSums = Join-Path $Root "package\\SHA256SUMS.txt"
$site = Join-Path $Root "site"
$siteArchive = Join-Path $site "downloads\\$archiveName"
$siteSums = Join-Path $site "downloads\\SHA256SUMS.txt"

foreach ($path in @($packageArchive, $packageSums, $siteArchive, $siteSums)) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "Required release file is missing: $path"
    }
}

$packageHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $packageArchive).Hash
$siteHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $siteArchive).Hash
if ($packageHash -ne $siteHash) {
    throw "Site archive hash differs from the packaged release"
}

$siteSumLine = Get-Content -Encoding ASCII $siteSums |
    Where-Object { $_ -match [regex]::Escape($archiveName) } |
    Select-Object -First 1
if (-not $siteSumLine -or ($siteSumLine -split '\s+')[0] -ne $siteHash) {
    throw "Site SHA256SUMS.txt does not match the site archive"
}

$html = Get-Content -Raw -Encoding UTF8 (Join-Path $site "index.html")
$archiveReferences = [regex]::Matches(
    $html, 'downloads/(PuTTY-AI-v\d+\.\d+\.\d+-windows-x64\.zip)') |
    ForEach-Object { $_.Groups[1].Value } |
    Select-Object -Unique
if ($archiveReferences.Count -eq 0 -or
    @($archiveReferences | Where-Object { $_ -ne $archiveName }).Count -gt 0) {
    throw "index.html contains a stale or missing release download reference"
}
if ($html -notmatch [regex]::Escape("v$version")) {
    throw "index.html does not display the current release version"
}

$siteReadme = Get-Content -Raw -Encoding UTF8 (Join-Path $site "README.md")
if ($siteReadme -notmatch [regex]::Escape($archiveName)) {
    throw "site README does not document the current release archive"
}

$zip = [IO.Compression.ZipFile]::OpenRead($siteArchive)
try {
    if (-not ($zip.Entries.FullName | Where-Object {
        $_ -match '(^|[\\/])putty\.exe$'
    })) {
        throw "Site archive does not contain putty.exe"
    }
}
finally {
    $zip.Dispose()
}

[pscustomobject]@{
    Version = $version
    Archive = $archiveName
    SHA256 = $siteHash
    Status = "passed"
} | Format-List
