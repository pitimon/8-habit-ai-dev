<#
.SYNOPSIS
Checks whether a Windows host is ready to validate the 8-Habit Codex plugin.

.DESCRIPTION
This is a lightweight preflight for PowerShell users. It does not replace the
Bash validators; it checks that Git Bash is available and prints the canonical
Git Bash commands to run the existing validator scripts.
#>

[CmdletBinding()]
param(
  [string]$MarketplaceRoot = "$env:USERPROFILE\.codex\.tmp\marketplaces\pitimon-8-habit-ai-dev"
)

$ErrorActionPreference = "Stop"

$failures = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

function Write-Check {
  param(
    [string]$Status,
    [string]$Message
  )

  Write-Output ("[{0}] {1}" -f $Status, $Message)
}

function Find-CommandSource {
  param([string]$Name)

  $cmd = Get-Command $Name -ErrorAction SilentlyContinue | Select-Object -First 1
  if ($null -eq $cmd) {
    return $null
  }
  return $cmd.Source
}

function Add-Failure {
  param([string]$Message)

  $failures.Add($Message) | Out-Null
  Write-Check "FAIL" $Message
}

function Add-Warning {
  param([string]$Message)

  $warnings.Add($Message) | Out-Null
  Write-Check "WARN" $Message
}

function Convert-ToGitBashPath {
  param([string]$WindowsPath)

  $resolved = [System.IO.Path]::GetFullPath($WindowsPath)
  if ($resolved -match '^([A-Za-z]):\\(.*)$') {
    $drive = $Matches[1].ToLowerInvariant()
    $rest = $Matches[2] -replace '\\', '/'
    return "/$drive/$rest"
  }

  return ($resolved -replace '\\', '/')
}

Write-Output "8-Habit AI Dev Windows preflight"
Write-Output "================================="

$codex = Find-CommandSource "codex"
if ($codex) {
  $version = (& codex --version) 2>$null
  Write-Check "PASS" "codex found: $codex ($version)"
} else {
  Add-Failure "codex is missing from PATH. Install with: npm install -g @openai/codex"
}

$git = Find-CommandSource "git"
if ($git) {
  $version = (& git --version) 2>$null
  Write-Check "PASS" "git found: $git ($version)"
} else {
  Add-Failure "git is missing from PATH. Install Git for Windows."
}

$node = Find-CommandSource "node"
if ($node) {
  $version = (& node --version) 2>$null
  Write-Check "PASS" "node found: $node ($version)"
} else {
  Add-Failure "node is missing from PATH. Codex install and repository catalog checks require Node."
}

$gitBashCandidates = @(
  "$env:ProgramFiles\Git\bin\bash.exe",
  "${env:ProgramFiles(x86)}\Git\bin\bash.exe"
) | Where-Object { $_ -and (Test-Path $_) }

$gitBash = $gitBashCandidates | Select-Object -First 1
if ($gitBash) {
  Write-Check "PASS" "Git Bash found: $gitBash"
} else {
  Add-Failure "Git Bash was not found. Install Git for Windows and ensure Git Bash is included."
}

$pathBash = Find-CommandSource "bash"
if ($pathBash) {
  Write-Check "INFO" "PATH bash resolves to: $pathBash"
  $systemBash = Join-Path $env:WINDIR "System32\bash.exe"
  if ([System.IO.Path]::GetFullPath($pathBash).Equals([System.IO.Path]::GetFullPath($systemBash), [System.StringComparison]::OrdinalIgnoreCase)) {
    Add-Warning "Plain 'bash' resolves to the WSL launcher. If no WSL distro is installed, call Git Bash by absolute path."
  }
} else {
  Add-Warning "No plain 'bash' command was found on PATH. Use the Git Bash absolute path printed above."
}

if ($codex) {
  $pluginList = (& codex plugin list) 2>&1
  if ($LASTEXITCODE -eq 0 -and ($pluginList -match '8-habit-ai-dev@pitimon-8-habit-ai-dev')) {
    Write-Check "PASS" "Codex plugin is installed and listed: 8-habit-ai-dev@pitimon-8-habit-ai-dev"
  } else {
    Add-Warning "Codex plugin is not installed yet. Run: codex plugin marketplace add pitimon/8-habit-ai-dev; codex plugin add 8-habit-ai-dev@pitimon-8-habit-ai-dev"
  }
}

if (Test-Path $MarketplaceRoot) {
  Write-Check "PASS" "Marketplace checkout found: $MarketplaceRoot"
  if ($gitBash) {
    $bashRoot = Convert-ToGitBashPath $MarketplaceRoot
    Write-Output ""
    Write-Output "Run validators from PowerShell with Git Bash:"
    Write-Output ('& "{0}" -lc "cd {1} && bash tests/validate-structure.sh"' -f $gitBash, $bashRoot)
    Write-Output ('& "{0}" -lc "cd {1} && bash tests/validate-content.sh"' -f $gitBash, $bashRoot)
    Write-Output ('& "{0}" -lc "cd {1} && bash tests/test-skill-graph.sh"' -f $gitBash, $bashRoot)
    Write-Output ('& "{0}" -lc "cd {1} && bash tests/test-verbosity-hook.sh"' -f $gitBash, $bashRoot)
  }
} else {
  Add-Warning "Marketplace checkout not found at $MarketplaceRoot. Add it with: codex plugin marketplace add pitimon/8-habit-ai-dev"
}

Write-Output ""
Write-Output ("Summary: {0} failure(s), {1} warning(s)" -f $failures.Count, $warnings.Count)

if ($failures.Count -gt 0) {
  exit 1
}

exit 0
