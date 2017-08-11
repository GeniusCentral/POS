Param(
  [string]$accessToken,
  [string]$orderingAPIUri,
  [string]$logFile,
  [string]$orderHistoryPath,
  [int]$storeId,
  [bool]$debug,
  [bool]$outputToConsole
)


Try{
    $header = @{"Authorization" = "Bearer $accessToken"; "Accept" = "application/json"; "Content-Type" = "application/json"}
    $uri = $orderingAPIUri +  "stores/" + $storeId + "/orders" + "?previouslyExportedOrders=false";
    $message = "Accessing API - " + $uri
    Add-content $logFile $message
    if($outputToConsole) {
        Write-Host $message
    }

    $result = Invoke-RestMethod -Method GET -URI $uri -Header $header
    $message = "Number of orders retrieved - " + $result.orders.length
    Add-content $logFile $message
    if($outputToConsole) {
        Write-Host $message
    }

    If($result.orders.length -gt 0){
        $fileName = New-Guid
        $pathFile = $orderHistoryPath + $fileName + ".json"
        $result.orders | ConvertTo-Json | Out-File $pathFile -ErrorAction Stop
        $message = "Writing Downloaded Orders to File: " + $pathFile
        Add-content $logFile $message
    }

    Return $result.orders
}
Catch{
    $message = "GetOrdersFromAPI Error Message: " + $_.Exception.Message
    Add-content $logFile $message
    $message = "Error occurred in line " +  $_.InvocationInfo.ScriptLineNumber
    Add-Content $logFile $message
    Throw $_.Exception
}
