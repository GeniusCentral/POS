Param(
  [string]$test
)

Clear-Host

#Read in configuration file
$config = Get-Content -Raw -Path "config.json" | ConvertFrom-Json

#Create folders if they do not exists
If(!(Test-Path $config.logFile)){
    New-Item $config.logFile -type directory
}
If(!(Test-Path $config.originJSONPath)){
    New-Item $config.originJSONPath -type directory
}
If(!(Test-Path $config.historyXMLPath)){
    New-Item $config.historyXMLPath -type directory
}
If(!(Test-Path $config.historyJSONPath)){
    New-Item $config.historyJSONPath -type directory
}

$logFile = $config.logFile + "Log - " +  (Get-Date).toString("yyyy-MM-dd") + ".txt"
Add-Content $logFile " "
$message = "Start of running send orders script - " +  (Get-Date).toString("u")
Add-Content $logFile $message

$test = $test.ToLower()

Try{

    #Get the access token from our Authentication Server
    $accessToken = .\scripts\GetAccessToken.ps1 $config.clientSecret $config.identityAPIUri  $config.clientId $logFile $config.debug
    if ($accessToken){
        #Read in all files in the xml source folder
        #Convert them from xml to json docuemnts and save in json source folder
        #Post the json file to GeniusCentral's API
        #Move the processed xml doucuments to the xml history folder
        Get-ChildItem $config.originXMLPath |
        Foreach-Object {
            $message = "Converting xml file  " + $_.FullName + " to JSON"
            Add-content $logFile $message
            if($config.outputToConsole) {
                Write-Host $message
            }

            $jsonFile = .\scripts\OrderXMLToJSON.ps1 $_.FullName $config.originJSONPath $logFile $config.outputToConsole

            If ($jsonFile){
                #Post Order to API
                .\scripts\PostJsonOrder.ps1 $jsonFile $accessToken $config.orderingAPIUri $logFile $config.debug $config.outputToConsole

                If ($test -ne 'true'){
                    #Move temproary files
                    $newLocation =  $_.FullName.Replace( $config.originXMLPath, $config.historyXMLPath)
                    move-Item  -Force -Path $_.FullName -Destination $newLocation
                    $newLocation =  $jsonFile.Replace( $config.originJSONPath, $config.historyJSONPath)
                    move-Item -Force -Path $jsonFile -Destination $newLocation
                }
            }

            if($config.outputToConsole) {
                Write-Host " "
            }
        }
    }
    $message = "End of running send orders script - " +  (Get-Date).toString("u")
    Add-Content $logFile $message
}
Catch{
    $message = "Send Orders Error Message: " + $_.Exception.Message
    Add-Content $logFile $message
    $message = "Error occurred in line " +  $_.InvocationInfo.ScriptLineNumber
    Add-Content $logFile $message
    Throw $_.Exception
}