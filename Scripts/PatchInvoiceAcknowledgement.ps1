Param(
    [string]$accessToken,
    [string]$orderingAPIUri,
    [string]$logFile,
    [string]$orderAcks,
    [bool]$debug

)

Try {
    #call API to Patch Acknowledge invoice
    $uri = $orderingAPIUri + "invoices"
    $body = $invoiceAcks;
    $header = @{"Authorization" = "Bearer $accessToken"; "Accept" = "application/json"; "Content-Type" = "application/json"}

    if ($debug) {
        $message = "Acknowledging Invoices: "
        Add-content $logFile $message
        $message = "Uri: " + $uri
        Add-content $logFile $message
    }
    Invoke-RestMethod -Method Patch -Uri $uri -Body $body -Header $header
}
Catch {

    $message = "Patch Invoice Acknowledgement Error Message: " + $_.Exception.Message
    Add-content $logFile $message
    $message = "Error occurred in line " + $_.InvocationInfo.ScriptLineNumber
    Add-Content $logFile $message
    Throw $_.Exception
}
