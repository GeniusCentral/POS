Param(
  [string]$clientSecret,
  [string]$identityServerUri,
  [string]$logFile,
  [bool]$debug
)

Try{
  #call API for access token
  $connectTokenBody = "scope=posClient&client_secret=" + $clientSecret + "&grant_type=client_credentials&client_id=" + $config.clientId;
  $connectToken = Invoke-RestMethod -Method POST -URI $identityServerUri -body $connectTokenBody;
  $accessToken = $connectToken.access_token
  return $accessToken
}
Catch{
  Add-Content $logFile "Get Access Token Error Message: $_.Exception.Message"   
  $message = "Error occurred in line " +  $_.InvocationInfo.ScriptLineNumber
  Add-Content $logFile $message      
  Throw $_.Exception      
}

