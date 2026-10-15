# StoryBoard.SampleProjects

Content-only NuGet package containing the StoryBoard sample projects and the source assets they use for testing.

Install it with:

```xml
<PackageReference Include="StoryBoard.SampleProjects" Version="1.0.0" />
```

The package preserves these folders:

- `Samples/`
- `SourceAssets/`

The files are published as NuGet `contentFiles` and are configured to copy to the consuming project's output directory. This package contains no library assemblies or source code.

## Local prerelease packages

To pack either package with a timestamped local prerelease version and copy it to `C:\work\LocalNugetDevFeed`:

```powershell
.\scripts\LocalPrerelease.ps1 SampleProjects
.\scripts\LocalPrerelease.ps1 SourceAssets
```

Pass a different feed as the second argument, or use `-KeepPackage` to retain the package under `artifacts\packages\local-prerelease`:

```powershell
.\scripts\LocalPrerelease.ps1 SampleProjects .\local-feed -KeepPackage
```
