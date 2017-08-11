Param(
  [string]$accessToken,
  [string]$orderingAPIUri,
  [string]$logFile,
  [string]$invoiceHistoryPath,
  [int]$storeId,
  [bool]$debug,
  [bool]$outputToConsole
)


Try{
    $header = @{"Authorization" = "Bearer $accessToken"; "Accept" = "application/json"; "Content-Type" = "application/json"}
    $uri = $orderingAPIUri +  "stores/" + $storeId + "/invoices" + "?previouslyExportedInvoices=false";
    $message = "Accessing API - " + $uri
    Add-content $logFile $message
    if($outputToConsole) {
        Write-Host $message
    }

    $result = Invoke-RestMethod -Method GET -URI $uri -Header $header
    $message = "Number of invoices retrieved - " + $result.invoices.length
    Add-content $logFile $message
    if($outputToConsole) {
        Write-Host $message
    }

    If($result.invoices.length -gt 0){
        $fileName = New-Guid
        $pathFile = $invoiceHistoryPath + $fileName + ".json"
        $result.invoices | ConvertTo-Json | Out-File $pathFile -ErrorAction Stop
        $message = "Writing Downloaded Invoices to File: " + $pathFile
        Add-content $logFile $message
    }
    Return $result.invoices
}
Catch{
    $message = "GetInvoicesFromAPI Error Message: " + $_.Exception.Message
    Add-content $logFile $message
    $message = "Error occurred in line " +  $_.InvocationInfo.ScriptLineNumber
    Add-Content $logFile $message
    Throw $_.Exception
}
