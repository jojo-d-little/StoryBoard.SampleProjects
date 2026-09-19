[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateSet('SampleProjects', 'SourceAssets')]
    [string]$Package,
    [Parameter(Position = 1)]
    [ValidatePattern('^[0-9]+\.[0-9]+\.[0-9]+(?:-[0-9A-Za-z.-]+)?$')]
    [string]$Version
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
Set-Location $root
$project = if ($Package -eq 'SampleProjects') { 'StoryBoard.SampleProjects.csproj' } else { 'StoryBoard.SourceAssets.csproj' }

function Invoke-Step([string]$Name, [scriptblock]$Action) {
    Write-Host "`n==> $Name" -ForegroundColor Cyan
    & $Action
    if (-not $?) { throw "Step failed: $Name" }
}

if ((git branch --show-current) -ne 'main') { throw 'Release must start from main.' }
if ((git status --porcelain)) { throw 'Working tree must be clean before releasing.' }
$projectFile = Join-Path $root $project
$text = [IO.File]::ReadAllText($projectFile)
$currentVersion = ([regex]::Match($text, '<Version>([^<]+)</Version>')).Groups[1].Value
if (-not $Version) {
    if ($currentVersion -notmatch '^(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)$') {
        throw "Cannot suggest a patch bump for current version '$currentVersion'."
    }
    $Version = "$($matches.major).$($matches.minor).$([int]$matches.patch + 1)"
    $confirmation = Read-Host "Current version is $currentVersion. Use suggested version ${Version}? [Y/n]"
    if ($confirmation -and $confirmation -notmatch '^(?i:y|yes)$') { throw 'Release cancelled.' }
}
$tag = if ($Package -eq 'SampleProjects') { "sampleprojects-v$Version" } else { "sourceassets-v$Version" }
if (git tag --list $tag) { throw "Tag '$tag' already exists locally." }
git ls-remote --exit-code --tags origin "refs/tags/$tag" *> $null
if ($LASTEXITCODE -eq 0) { throw "Tag '$tag' already exists on origin." }
if ($LASTEXITCODE -ne 2) { throw "Could not check whether tag '$tag' exists on origin." }

$updated = [regex]::Replace($text, '<Version>[^<]+</Version>', "<Version>$Version</Version>", 1)
if ($updated -eq $text) { throw "Could not update the version in $project." }
[IO.File]::WriteAllText($projectFile, $updated)

Invoke-Step 'restore package project' { dotnet restore $project --nologo }
Invoke-Step "pack $Package locally" { dotnet pack $project --configuration Release --no-restore --output artifacts -p:PackageVersion=$Version --nologo }

git add -- $project
Invoke-Step "commit $Package version $Version" { git commit -m "Prepare $Package $Version release" }
Invoke-Step "create annotated tag $tag" { git tag -a $tag -m "Release $Package $Version" }
Invoke-Step 'push main and release tag' { git push --atomic --follow-tags origin main }

Write-Host "Release $Package $Version pushed. GitHub Actions will publish the package." -ForegroundColor Green
