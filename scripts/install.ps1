# MindForge · install.ps1
# Install MindForge to %USERPROFILE%\.agents\skills\MindForge and link agents.
param(
    [switch]$Force,
    [string]$Source = ""
)

$ErrorActionPreference = "Stop"

$GlobalRoot = if ($env:MINDFORGE_HOME) { $env:MINDFORGE_HOME } else { Join-Path $env:USERPROFILE ".agents\skills\MindForge" }
$DistilledRoot = if ($env:MINDFORGE_DISTILLED) { $env:MINDFORGE_DISTILLED } else { Join-Path $env:USERPROFILE ".agents\skills\distilled" }
$AgentsSkills = Join-Path $env:USERPROFILE ".agents\skills"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir

if ($Source -ne "") {
    $Src = (Resolve-Path $Source).Path
} elseif (Test-Path (Join-Path $RepoRoot "SKILL.md")) {
    $Src = $RepoRoot
} else {
    $Src = $null
}

Write-Host "⚒️  MindForge installer (Windows)"
Write-Host "   Target: $GlobalRoot"
Write-Host ""

New-Item -ItemType Directory -Force -Path $AgentsSkills | Out-Null
New-Item -ItemType Directory -Force -Path $DistilledRoot | Out-Null

if ((Test-Path $GlobalRoot) -and -not $Force) {
    Write-Host "↻ Already installed at $GlobalRoot"
    Write-Host "   Use -Force to reinstall, or run link-agents only."
} else {
    if ((Test-Path $GlobalRoot) -and $Force) {
        Write-Host "🗑  Removing previous install (-Force)"
        Remove-Item -Recurse -Force $GlobalRoot
    }
    if ($null -eq $Src -or -not (Test-Path (Join-Path $Src "SKILL.md"))) {
        Write-Host "❌ No local SKILL.md found. Clone the repo and re-run from repo root."
        exit 1
    }
    # Default: copy clean tree. Dev junction: $env:MINDFORGE_LINK = "1"
    if ($env:MINDFORGE_LINK -eq "1") {
        Write-Host "🔗 Creating junction → $Src (dev mode)"
        New-Item -ItemType Junction -Path $GlobalRoot -Target $Src | Out-Null
    } else {
        Write-Host "📦 Copying engine from $Src"
        New-Item -ItemType Directory -Force -Path $GlobalRoot | Out-Null
        $include = @('SKILL.md', 'README.md', 'README.zh-TW.md', 'LICENSE', 'package.json', 'references', 'scripts', 'examples')
        foreach ($name in $include) {
            $p = Join-Path $Src $name
            if (Test-Path $p) {
                Copy-Item $p -Destination $GlobalRoot -Recurse -Force
            }
        }
    }
}

$LinkScript = Join-Path $GlobalRoot "scripts\link-agents.ps1"
if (Test-Path $LinkScript) {
    & $LinkScript
} else {
    Write-Host "⚠ link-agents.ps1 missing — skip"
}

Write-Host ""
Write-Host "✅ MindForge installed"
Write-Host "   Engine:    $GlobalRoot"
Write-Host "   Distilled: $DistilledRoot"
Write-Host ""
Write-Host "Next: In your Agent app say  Forge <name>  /  Distill <name>"
Write-Host "Docs: README.md (EN) · README.zh-TW.md (繁中)"
Write-Host "Manage: mindforge list | mindforge doctor | mindforge help"
