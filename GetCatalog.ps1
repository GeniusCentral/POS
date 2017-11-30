Param(
  [int]$vendorId
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

#Created a Log File
$logFile = $config.logFile + "Log - " +  (Get-Date).toString("yyyy-MM-dd") + ".txt"
Add-Content $logFile " "
$message = "Start of running retrieve orders script - " +  (Get-Date).toString("u")
Add-Content $logFile " "
Add-Content $logFile $message

Try{

    #Get the access token from our Authentication Server
    $accessToken = .\scripts\GetAccessToken.ps1 $config.clientSecret $config.identityAPIUri $config.clientId $logFile $config.debug

    If ($accessToken){
		#Get the Catalog from the API
		$catalogFile = .\scripts\GetCatalogFromAPI.ps1 $accessToken $config.posAPIUri $logFile $config.catalogsRetrievedPath $vendorId $config.debug $config.outputToConsole
		.\scripts\JsonCatalogFormat.ps1 $catalogFile $vendorId $config.catalogsRetrievedPath $logFile
    }

    $message = "End of retrieving catalog script - " +  (Get-Date).toString("u")
    Add-Content $logFile $message
}
Catch{

    $message = "GetCatalog Error Message: " + $_.Exception.Message
    Add-Content $logFile $message
    $message = "Error occurred in line " +  $_.InvocationInfo.ScriptLineNumber
    Add-Content $logFile $message
    Throw $_.Exception

}
