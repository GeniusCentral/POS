Param(
    [System.Object] $catalogFile,
	[int]$vendorId,
    [string]$updatesSinceDate,
    [string] $catalogsRetrievedPath,
    [string] $logFile
)

Try{
    $cleanDate = $updatesSinceDate
    $cleanDate = $cleanDate -replace ":", "_"
    $fileName = "Catalog_$vendorId $cleanDate.json"
    $filePath = $catalogsRetrievedPath + $fileName
    $message = "Saving Catalog Updates file to $filePath"
    Add-content $logFile $message

    $catalogFile | ConvertTo-Json | Out-File $filePath
    $message = "Saving Catalog Updates file."
    Add-content $logFile $message
}

Catch{
    $message = "JsonCatalogUpdatesFormat.ps1 Error Message: " + $_.Exception.Message
    Add-content $logFile $message
    $message = "Error occurred in line " +  $_.InvocationInfo.ScriptLineNumber
    Add-Content $logFile $message
    Throw $_.Exception
}
