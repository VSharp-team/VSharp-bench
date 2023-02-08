# V# benchmarks

This repository contains various built .NET projects used for [V# symbolic execution engine](https://github.com/VSharp-team/VSharp) performance testing.  It is structured as follows: subdirectories in the root directory correspond to different test suites. For each suite there are standalone binaries on which V# can be run.

## How to run:

### Requirements

- powershell (tested on Windows)
- environment variables VS_BENCH_PATH and VS_PATH set to this repository path and to the V# path respectively
- dotcover global tool installed
- dotnet installed

There is a powershell script `cover.ps1` in `\runner` dir. It has the following parameters

```
param (
    [Parameter(Mandatory=$true)]$suite, # name of the suite directory (i.e. jb_lifetimes)
    [Parameter(Mandatory=$true)]$dll, # name of the dll file without extension
    $namespace, # name of the namespace to cover
    $class, # name of the type to cover
    $method, # name of the method to cover
    $output, # output directory (default is <script dir>\outputs)
    $searchers = "BFS", # different searchers to run V# with (can be separated with whitespaces)
    $timeouts = "-1", # different timeouts to run V# with (can be separated with whitespaces)
    [switch]$drawCharts = $false, # if true, coverage and statistics charts for diffetent timeouts and searchers are drawn and saved to output
    [switch]$renderTests = $false # if true, tests are also rendered and run
)
```

If namespace, method and class are not specified, all methods in dll are covered

Example:

```
.\cover.ps1 -suite jb_lifetimes -dll JetBrains.Lifetimes -namespace JetBrains.Collections -t "20" -renderTests
```

## Test suites:

- `jb_lifetimes` — https://github.com/JetBrains/rd/tree/master/rd-net/RdFramework and https://github.com/JetBrains/rd/tree/master/rd-net/Lifetimes (.NET Framework). To build (Windows only) use `dotnet publish --self-contained -f net461`
- `loan_exam` — a dummy ASP.NET service for credit percent calculation. Target dll is `LoanExam.dll`. Target method is `CreditCalculator.Build`. Sources are located in `sources/LoanExam`. To build (on Windows, for other platforms use a different `-r`), use `dotnet publish -r win10-x64 --self-contained -c Release`
- `max_arshinov_web` — another demo ASP.NET project. Target dll is `HightechAngular.Web.dll`. Sources: https://github.com/max-arshinov/DotNext-Moscow-2020/tree/step-1 (commit [7ff649b](https://github.com/max-arshinov/DotNext-Moscow-2020/commit/7ff649bba45cf2b06624eaff00da4e61e46573a1)). To build (on Windows, for other platforms use a different `-r`):
  - Install node.js
  - Replace `npm install` in https://github.com/max-arshinov/DotNext-Moscow-2020/blob/7ff649bba45cf2b06624eaff00da4e61e46573a1/Apps/HightechAngular.Web/HightechAngular.Web.csproj#L77 with `npm install --legacy-peer-deps`
  - Run `dotnet publish -r win10-x64 --self-contained -c Release`
- `gsv_gamemaps` — algorithms on graphs, matrices etc. Sources can be found in `sources/GsvGameMaps`

*PR-s with new benchmarks are welcomed!*   

