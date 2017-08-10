Param(
    [string]$accessToken,
    [string]$orderingAPIUri,
    [string]$logFile,
    [string]$orderAcks,
    [int]$storeId,
    [bool]$debug

)

Try {
    #call API to Put Acknowledge order
    $uri = $orderingAPIUri + "stores/" + $storeId + "/orders"
    $body = $orderAcks;
    $header = @{"Authorization" = "Bearer $accessToken"; "Accept" = "application/json"; "Content-Type" = "application/json"}
    Invoke-RestMethod -Method PATCH -URI $uri -body $body -Header $header
}
Catch {

    $message = "Patch Order Acknowledgement Error Message: " + $_.Exception.Message
    Add-content $logFile $message
    $message = "Error occurred in line " + $_.InvocationInfo.ScriptLineNumber
    Add-Content $logFile $message
    Throw $_.Exception
}
