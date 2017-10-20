Param(
    [System.Object] $orderFile,
    [string] $orderHistoryPath,
    [string] $logFile
)

Try{
    $fileName = New-Guid
    $pathFile = $orderHistoryPath + $fileName + ".json"
    $orderFile | ConvertTo-Json | Out-File $pathFile -ErrorAction Stop
    $message = "Saving Order in JSON format " 
    Add-content $logFile $message
}

Catch{
    $message = "JsonOrderFormat.ps1 Error Message: " + $_.Exception.Message
    Add-content $logFile $message
    $message = "Error occurred in line " +  $_.InvocationInfo.ScriptLineNumber
    Add-Content $logFile $message
    Throw $_.Exception
}