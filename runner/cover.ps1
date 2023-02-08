param (
    [Parameter(Mandatory=$true)]$suite,
    [Parameter(Mandatory=$true)]$dll,
    $namespace,
    $class,
    $method,
    $output,
    $searchers = "BFS",
    $timeouts = "-1",
    [switch]$drawCharts = $false,
    [switch]$renderTests = $false
)

$START_DIR=Get-Location

try
{
    $SCRIPT_DIR="$PSScriptRoot"
    $DLL_PATH="$Env:VS_BENCH_PATH/$suite/$dll.dll"
    $DATE=Get-Date -Format "yyyy-MM-dd_HH-mm"
    $OUTPUT_DIR_NAME="$date-$suite-$dll-$namespace$class$method"

    if ($output)
    {
        $OUTPUT_PATH="$output/$OUTPUT_DIR_NAME"
    }
    else
    {
        $OUTPUT_PATH="$SCRIPT_DIR/outputs/$OUTPUT_DIR_NAME"
    }
    
    $TEMP_DIR="$SCRIPT_DIR/tmp"

    if (Test-Path $TEMP_DIR)
    {
        Remove-Item $TEMP_DIR -Recurse
    }

    md $OUTPUT_PATH

    cd "$Env:VS_PATH"
    dotnet build -c Release

    if ($drawCharts)
    {
        $VERBOSITY="StatisticsCollection"
    }
    else
    {
        $VERBOSITY="Error"
    }

    foreach ($s in $searchers.Split(" "))
    {
        $SEARCHER_PATH="$OUTPUT_PATH/$s"
        md $SEARCHER_PATH

        foreach ($t in $timeouts.Split(" "))
        {
            md $TEMP_DIR
            
            $TIMEOUT_PATH="$SEARCHER_PATH/$t"
            md $TIMEOUT_PATH  

            cd "$Env:VS_PATH\VSharp.Runner\bin\Release\netcoreapp6.0"

            if ($renderTests)
            {
                if ($namespace) 
                {
                    dotnet VSharp.Runner.dll --namespace "$namespace" "$DLL_PATH" -t "$t" -o "$TEMP_DIR" --strat "$s" -v "$VERBOSITY" --render-tests
                } 
                elseif ($method) 
                {
                    dotnet VSharp.Runner.dll --method "$method" "$DLL_PATH" -t "$t" -o "$TEMP_DIR" --strat "$s" -v "$VERBOSITY" --render-tests
                } 
                elseif ($class) 
                {
                    dotnet VSharp.Runner.dll --public-methods-of-class "$class" "$DLL_PATH" -t "$t" -o "$TEMP_DIR" --strat "$s" -v "$VERBOSITY" --render-tests
                } 
                else
                {
                    dotnet VSharp.Runner.dll --all-public-methods "$DLL_PATH" -t "$t" -o "$TEMP_DIR" --strat "$s" -v "$VERBOSITY" --render-tests
                } 
            }
            else
            {
                if ($namespace) 
                {
                    dotnet VSharp.Runner.dll --namespace "$namespace" "$DLL_PATH" -t "$t" -o "$TEMP_DIR" --strat "$s" -v "$VERBOSITY"
                } 
                elseif ($method) 
                {
                    dotnet VSharp.Runner.dll --method "$method" "$DLL_PATH" -t "$t" -o "$TEMP_DIR" --strat "$s" -v "$VERBOSITY"
                } 
                elseif ($class) 
                {
                    dotnet VSharp.Runner.dll --public-methods-of-class "$class" "$DLL_PATH" -t "$t" -o "$TEMP_DIR" --strat "$s" -v "$VERBOSITY"
                } 
                else
                {
                    dotnet VSharp.Runner.dll --all-public-methods "$DLL_PATH" -t "$t" -o "$TEMP_DIR" --strat "$s" -v "$VERBOSITY"
                } 
            }

            cd "$Env:VS_PATH\VSharp.TestRunner\bin\Release\netcoreapp6.0"

            Copy-Item "$TEMP_DIR\VSharp.tests.0" -Destination "$TIMEOUT_PATH" -Recurse

            if ($renderTests)
            {
                Copy-Item "$TEMP_DIR\*.Tests" -Destination "$TIMEOUT_PATH" -Recurse
                Push-Location -Path "$TEMP_DIR\*.Tests"
                dotnet test
                Pop-Location
            }

            dotnet-dotcover exec VSharp.TestRunner.dll "$TEMP_DIR/VSharp.tests.0" --dcFilters="-:module=Microsoft.*;-:module=FSharp.*;-:class=VSharp.*;-:module=VSharp.Utils" --dcReportType="JSON|HTML" --dcOutput="$TIMEOUT_PATH/coverage.json;$TIMEOUT_PATH/coverage.html"

            if ($drawCharts)
            {
                Copy-Item "$TEMP_DIR\VSharp.tests.0\reports\continuous.csv" -Destination "$TIMEOUT_PATH"
            }
            
            Remove-Item $TEMP_DIR -Recurse -Force
        }
    }

    if ($drawCharts)
    {
        cd "$SCRIPT_DIR\python_venv\Scripts"
        .\activate.bat
        pip install -r "$SCRIPT_DIR\requirements.txt"
        python "$SCRIPT_DIR\draw_charts.py" $OUTPUT_PATH
        .\deactivate.bat
    }

    Exit 0
}
finally
{
    cd "$START_DIR"
}
