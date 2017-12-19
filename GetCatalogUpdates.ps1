Param(
  [int]$vendorId,
  [string]$updatesSinceDate
)

Clear-Host

#Read in Configuration file
$config = Get-Content -Raw -Path "config.json" | ConvertFrom-Json

#Create folders if they do not exists
If(!(Test-Path $config.logFile)){
    New-Item $config.logFile -type directory
}
If(!(Test-Path $config.catalogsRetrievedPath)){
    New-Item $config.catalogsRetrievedPath -type directory
}

#Log File Name
$logFile = $config.logFile + "GetCatalogUpdates " +  (Get-Date).toString("yyyy-MM-dd") + ".log"

if(!$vendorId){
	$message = "vendorId parameter is required"
	Write-Host $message
	Add-Content $logFile $message
	Return;
}

if(!$updatesSinceDate){
	$message = "updatesSinceDate parameter is required ex. ""2017-11-15T14:30"""
	Write-Host $message
	Add-Content $logFile $message
	Return;
}


$message = (Get-Date).toString() + " Start of get catalog updates script ($vendorId) ($updatesSinceDate)"
Add-Content $logFile $message

Try{

    #Get the access token from our Authentication Server
    $accessToken = .\scripts\GetAccessToken.ps1 $config.clientSecret $config.identityAPIUri $config.clientId $logFile $config.debug

    If ($accessToken){
        #Get the Catalog from the API
        $startTime = Get-Date
		$catalogFile = .\scripts\GetCatalogUpdatesFromAPI.ps1 $accessToken $config.posAPIUri $logFile $config.catalogsRetrievedPath $vendorId $updatesSinceDate $config.debug $config.outputToConsole
        $finishTime = Get-Date
        $durationDownload = $finishTime - $startTime

        #Save the file to disk
        $startTime = Get-Date
        .\scripts\JsonCatalogUpdatesFormat.ps1 $catalogFile $vendorId $updatesSinceDate $config.catalogsRetrievedPath $logFile
        $finishTime = Get-Date
        $durationSaveFile = $finishTime - $startTime

        $message = "Duration, download:" + $durationDownload + " | save file: " + $durationSaveFile
        Add-content $logFile $message
        if($config.outputToConsole) {
            Write-Host $message
        }
    }

	$message = (Get-Date).toString() + " End of get catalog updates script ($vendorId) ($updatesSinceDate)"
    Add-Content $logFile $message
}
Catch{

    $message = "GetCatalogUpdates Error Message: " + $_.Exception.Message
    Add-Content $logFile $message
    $message = "Error occurred in line " +  $_.InvocationInfo.ScriptLineNumber
    Add-Content $logFile $message
    Throw $_.Exception

}
