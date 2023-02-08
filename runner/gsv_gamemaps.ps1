$methods = @(
    "BinarySearch",
    "Switches1",
    "Switches2",
    "NestedFors",
    "SearchWords",
    "BellmanFord",
    "bsPartition",
    "multiply_matrix",
    "mergeSort",
    "matrixInverse",
    "adjoint",
    "determinant",
    "getCofactor",
    "fillRemaining",
    "solveWordWrap",
    "waysToIncreaseLCSBy1",
    "BinaryMaze1BFS",
    "findShortestPathLength",
    "countIslands",
    "MatrixQueryModifyMatrix",
    "AhoCorasickMain",
    "KMPSearchMain",
    "BinarySearchMain",
    "MatrixMultiplicationMain",
    "MergeSortMain",
    "MatrixInverseMain",
    "SudokuMain",
    "WordWrapMain",
    "LCSMain",
    "BinaryMaze1Main",
    "BinaryMaze2Main",
    "IslandsMain",
    "MatrixQueryMain"
)

$interesting_methods = @(
    "Switches1",
    "Switches2",
    "SearchWords",
    "multiply_matrix",
    "fillRemaining"
)

$SCRIPT_DIR="$PSScriptRoot"
$DATE=Get-Date -Format "yyyy-MM-dd_HH-mm"
$OUTPUT_DIR_NAME="$date-gsv_gamemaps"
$OUTPUT_PATH="$SCRIPT_DIR/outputs/$OUTPUT_DIR_NAME"

foreach ($method in $methods) 
{
    .\cover.ps1 -suite gsv_gamemaps -dll GsvGameMaps -method "$method" -t "10" -output "$OUTPUT_PATH" -renderTests
}
