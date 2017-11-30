Param(
    [System.Object] $catalogFile,
	[int]$vendorId,
    [string] $catalogsRetrievedPath,
    [string] $logFile
)

Try{
    $fileName = "Catalog_$vendorId.json"
    $filePath = $catalogsRetrievedPath + $fileName
    $message = "Saving Catalog file to $filePath"
    Add-content $logFile $message
	
    $catalogFile | ConvertTo-Json | Out-File $filePath
    $message = "Saving Catalog file."
    Add-content $logFile $message
}

Catch{
    $message = "JsonCatalogFormat.ps1 Error Message: " + $_.Exception.Message
    Add-content $logFile $message
    $message = "Error occurred in line " +  $_.InvocationInfo.ScriptLineNumber
    Add-Content $logFile $message
    Throw $_.Exception
}