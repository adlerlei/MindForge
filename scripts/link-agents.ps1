# MindForge · link-agents.ps1
# Create junctions so every detected Agent CLI points at the global install.
$ErrorActionPreference = "Stop"

$GlobalRoot = if ($env:MINDFORGE_HOME) { $env:MINDFORGE_HOME } else { Join-Path $env:USERPROFILE ".agents\skills\MindForge" }
$DistilledRoot = if ($env:MINDFORGE_DISTILLED) { $env:MINDFORGE_DISTILLED } else { Join-Path $env:USERPROFILE ".agents\skills\distilled" }

if (-not (Test-Path $GlobalRoot)) {
    Write-Host "❌ MindForge not found at: $GlobalRoot"
    Write-Host "   Run install first: .\scripts\install.ps1"
    exit 1
}

New-Item -ItemType Directory -Force -Path $DistilledRoot | Out-Null

# Do NOT include the global agents skills dir as a link target — that path IS GlobalRoot
$candidates = @(
    @{ Name = "Claude Code"; Dir = (Join-Path $env:USERPROFILE ".claude\skills"); LinkDistilled = $true },
    @{ Name = "Grok Build";  Dir = (Join-Path $env:USERPROFILE ".grok\skills");   LinkDistilled = $true },
    @{ Name = "Codex";       Dir = (Join-Path $env:USERPROFILE ".codex\skills");  LinkDistilled = $true },
    @{ Name = "Gemini CLI";  Dir = (Join-Path $env:USERPROFILE ".gemini\skills"); LinkDistilled = $true },
    @{ Name = "OpenCode";    Dir = (Join-Path $env:USERPROFILE ".opencode\skills"); LinkDistilled = $true },
    @{ Name = "Cursor";      Dir = (Join-Path $env:USERPROFILE ".cursor\skills"); LinkDistilled = $true }
)

function Set-Junction {
    param([string]$LinkPath, [string]$TargetPath, [string]$Label)
    # Never self-link
    if ($LinkPath -eq $TargetPath) {
        Write-Host "  ✓ $Label  global root — skip self-link"
        return
    }
    $parent = Split-Path $LinkPath -Parent
    if (-not (Test-Path $parent)) {
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
    }
    if (Test-Path $LinkPath) {
        $item = Get-Item $LinkPath -Force
        if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            cmd /c rmdir "$LinkPath" 2>$null
        } else {
            Write-Host "  ⚠ $Label  $LinkPath exists and is not a junction — skip"
            return
        }
    }
    New-Item -ItemType Junction -Path $LinkPath -Target $TargetPath | Out-Null
    Write-Host "  + $Label  → $LinkPath"
}

Write-Host "🔗 MindForge · linking agents"
Write-Host "   Global:    $GlobalRoot"
Write-Host "   Distilled: $DistilledRoot"
Write-Host ""

foreach ($c in $candidates) {
    $parentOfSkills = Split-Path $c.Dir -Parent
    if (-not (Test-Path $parentOfSkills) -and $c.Name -ne "Agents") {
        Write-Host "  · $($c.Name)  not detected — skip"
        continue
    }
    $target = Join-Path $c.Dir "MindForge"
    Set-Junction -LinkPath $target -TargetPath $GlobalRoot -Label $c.Name
    if ($c.LinkDistilled) {
        $dtarget = Join-Path $c.Dir "distilled"
        if (-not (Test-Path $dtarget)) {
            Set-Junction -LinkPath $dtarget -TargetPath $DistilledRoot -Label "$($c.Name)/distilled"
        }
    }
}

Write-Host ""
Write-Host "Done."
