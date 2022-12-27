# V# benchmarks

This repository contains various built .NET projects used for [V# symbolic execution engine](https://github.com/VSharp-team/VSharp) performance testing.  It is structured as follows: subdirectories in the root directory correspond to different test suites. For each suite there are standalone binaries on which V# can be run.

## Test suites:

- `jb_lifetimes` — https://github.com/JetBrains/rd/tree/master/rd-net/RdFramework and https://github.com/JetBrains/rd/tree/master/rd-net/Lifetimes (.NET Framework). To build (Windows only) use `dotnet publish --self-contained -f net461`
- `loan_exam` — a dummy ASP.NET service for credit percent calculation. Target dll is `LoanExam.dll`. Target method is `CreditCalculator.Build`. Sources are located in `sources/LoanExam`. To build (on Windows, for other platforms use a different `-r`), use `dotnet publish -r win10-x64 --self-contained -c Release`
- `max_arshinov_web` — another demo ASP.NET project. Target dll is `HightechAngular.Web.dll`. Sources: https://github.com/max-arshinov/DotNext-Moscow-2020/tree/step-1 (commit [7ff649b](https://github.com/max-arshinov/DotNext-Moscow-2020/commit/7ff649bba45cf2b06624eaff00da4e61e46573a1)). To build (on Windows, for other platforms use a different `-r`):
  - Install node.js
  - Replace `npm install` in https://github.com/max-arshinov/DotNext-Moscow-2020/blob/7ff649bba45cf2b06624eaff00da4e61e46573a1/Apps/HightechAngular.Web/HightechAngular.Web.csproj#L77 with `npm install --legacy-peer-deps`
  - Run `dotnet publish -r win10-x64 --self-contained -c Release`

*PR-s with new benchmarks are welcomed!*   

