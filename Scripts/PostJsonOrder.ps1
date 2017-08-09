Param(
  [string]$orderFileLocation,
  [string]$accessToken,
  [string]$orderingAPIUri,
  [string]$logFile,
  [bool]$debug

)

$fileFound = Test-Path  $orderFileLocation;
if(-not $fileFound){
    Add-Content $logFile "JSON Order File Not Found: " $orderFileLocation
    exit;
}


#call API to POST order
$uri = $orderingAPIUri +  "stores/" + $config.storeId + "/orders";
$body = Get-Content $orderFileLocation;
$header = @{"Authorization" = "Bearer $accessToken"; "Accept" = "application/json"; "Content-Type" = "application/json"}

if($debug){
    Add-Content $logFile "postOrderUri: $uri"      
    Add-Content $logFile "postOrderBody: $body"    
}   

Try{
    $result = Invoke-RestMethod -Method POST -URI $uri -body $body -Header $header
    if($debug){ 
     Add-Content $logFile "Result from Order Pos:t"         
       $message = ConvertTo-Json -InputObject $result     
       Add-Content $logFile $message        
    } 
}
Catch{
    Add-Content $logFile "PostJsonOrder Error Message: $_.Exception.Message"  
    $message = "Error occurred in line " +  $_.InvocationInfo.ScriptLineNumber
    Add-Content $logFile $message  
    Throw  $_.Exception
}
