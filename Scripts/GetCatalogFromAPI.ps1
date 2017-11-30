Param(
  [string]$accessToken,
  [string]$posAPIUri,
  [string]$logFile,
  [string]$catalogsRetrievedPath,
  [int]$vendorId,
  [bool]$debug,
  [bool]$outputToConsole
)

Try{
    $header = @{"Authorization" = "Bearer $accessToken"; "Accept" = "application/json"; "Content-Type" = "application/json"}
    $uri = $posAPIUri +  "catalogs/" + $vendorId;
    $message = "Accessing API - " + $uri
    Add-content $logFile $message
    if($outputToConsole) {
        Write-Host $message
    }

    $result = Invoke-RestMethod -Method GET -URI $uri -Header $header
    $message = "Number of products retrieved - " + $result.length
    Add-content $logFile $message
    if($outputToConsole) {
        Write-Host $message
    }
    Return $result
}
Catch{
    $message = "GetCatalogFromAPI Error Message: " + $_.Exception.Message
    Add-content $logFile $message
    $message = "Error occurred in line " +  $_.InvocationInfo.ScriptLineNumber
    Add-Content $logFile $message
    Throw $_.Exception
}
