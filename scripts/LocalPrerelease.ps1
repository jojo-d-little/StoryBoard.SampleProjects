[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateSet('SampleProjects', 'SourceAssets')]
    [string]$Package,

    [Parameter(Position = 1)]
    [string]$LocalNuGetFeed,

    [switch]$KeepPackage
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
Set-Location $repoRoot

if (-not $LocalNuGetFeed) {
    $LocalNuGetFeed = 'C:\work\LocalNugetDevFeed'
}
elseif (-not [IO.Path]::IsPathRooted($LocalNuGetFeed)) {
    $LocalNuGetFeed = Join-Path $repoRoot $LocalNuGetFeed
}

$LocalNuGetFeed = [IO.Path]::GetFullPath($LocalNuGetFeed)
$projectFile = if ($Package -eq 'SampleProjects') {
    Join-Path $repoRoot 'StoryBoard.SampleProjects.csproj'
}
else {
    Join-Path $repoRoot 'StoryBoard.SourceAssets.csproj'
}
$packageId = "StoryBoard.$Package"
$projectText = Get-Content -LiteralPath $projectFile -Raw
$versionMatch = [regex]::Match(
    $projectText,
    '<Version>(?<version>[^<]+)</Version>')
if (-not $versionMatch.Success) {
    throw "Could not read <Version> from '$projectFile'."
}

$currentVersion = $versionMatch.Groups['version'].Value.Trim()
$semanticVersion = [regex]::Match(
    $currentVersion,
    '^(?<major>0|[1-9]\d*)\.(?<minor>0|[1-9]\d*)\.(?<patch>0|[1-9]\d*)(?:-(?<prerelease>[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?$')
if (-not $semanticVersion.Success) {
    throw "Cannot create a local prerelease from current version '$currentVersion'."
}

$major = $semanticVersion.Groups['major'].Value
$minor = $semanticVersion.Groups['minor'].Value
$patch = $semanticVersion.Groups['patch'].Value
if ($semanticVersion.Groups['prerelease'].Success) {
    $prereleaseBaseVersion = "$major.$minor.$patch"
}
else {
    $patchNumber = [System.Numerics.BigInteger]::Parse($patch, [Globalization.CultureInfo]::InvariantCulture)
    $nextPatch = ($patchNumber + [System.Numerics.BigInteger]::One).ToString([Globalization.CultureInfo]::InvariantCulture)
    $prereleaseBaseVersion = "$major.$minor.$nextPatch"
}

$utcNow = [DateTime]::UtcNow
$timestamp = $utcNow.ToString('yyyyMMdd', [Globalization.CultureInfo]::InvariantCulture) + '.t' +
    $utcNow.ToString('HHmmssfff', [Globalization.CultureInfo]::InvariantCulture)
$version = "$prereleaseBaseVersion-local.$timestamp"
$packageRoot = Join-Path $repoRoot 'artifacts\packages\local-prerelease'
$packageOutput = Join-Path $packageRoot $version
$packageFile = Join-Path $packageOutput "$packageId.$version.nupkg"
$feedPackage = Join-Path $LocalNuGetFeed "$packageId.$version.nupkg"
$packagePacked = $false

New-Item -ItemType Directory -Force -Path $LocalNuGetFeed, $packageOutput | Out-Null

Write-Host "Package:          $packageId"
Write-Host "Current version:  $currentVersion"
Write-Host "Prerelease base:  $prereleaseBaseVersion"
Write-Host "Local prerelease: $version"
Write-Host "NuGet feed:       $LocalNuGetFeed"

try {
    Write-Host "Packing $packageId (Release)..."
    & dotnet pack $projectFile --configuration Release --output $packageOutput `
        -p:Version=$version -p:PackageVersion=$version
    if ($LASTEXITCODE -ne 0) {
        throw "dotnet pack failed with exit code $LASTEXITCODE."
    }
    if (-not (Test-Path -LiteralPath $packageFile -PathType Leaf)) {
        throw "Expected package '$packageFile' was not produced."
    }
    $packagePacked = $true

    Copy-Item -LiteralPath $packageFile -Destination $feedPackage -Force
    Write-Host "Local prerelease package is available as $version." -ForegroundColor Green
    Write-Host "  $feedPackage"
}
finally {
    if (-not $packagePacked -and (Test-Path -LiteralPath $feedPackage -PathType Leaf)) {
        Remove-Item -LiteralPath $feedPackage -Force
    }

    if (-not $KeepPackage -and (Test-Path -LiteralPath $packageOutput -PathType Container)) {
        $resolvedOutput = (Resolve-Path -LiteralPath $packageOutput).Path
        $resolvedPackageRoot = [IO.Path]::GetFullPath($packageRoot)
        $packageRootPrefix = $resolvedPackageRoot + [IO.Path]::DirectorySeparatorChar
        if (-not $resolvedOutput.StartsWith($packageRootPrefix, [StringComparison]::OrdinalIgnoreCase)) {
            throw "Refusing to remove package output outside '$packageRoot'."
        }

        Remove-Item -LiteralPath $resolvedOutput -Recurse -Force
    }
}
