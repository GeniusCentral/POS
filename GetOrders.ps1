Clear-Host

#Read in Configuration file
$config = Get-Content -Raw -Path "config.json" | ConvertFrom-Json

#Create folders if they do not exists
If(!(Test-Path $config.logFile)){
    New-Item $config.logFile -type directory
}
If(!(Test-Path $config.ordersRetrievedPath)){
    New-Item $config.ordersRetrievedPath -type directory
}   

#Created a Log File
$logFile = $config.logFile + "Log - " +  (Get-Date).toString("yyyy-MM-dd") + ".txt"
Add-Content $logFile " "
$message = "Start of running retrieve orders script - " +  (Get-Date).toString("u")
Add-Content $logFile " "
Add-Content $logFile $message

Try{

    #Get the access token from our Authentication Server
    $accessToken = .\scripts\GetAccessToken.ps1 $config.clientSecret $config.identityAPIUri $logFile $config.debug

    If ($accessToken){
        #The API will only return up to 10 orders at a time
        #We are going to do this until the numnber of orders returned is less than 10
        Do
        {
            #Get the Orders from the API
            $orderFile = .\scripts\GetOrdersFromAPI.ps1 $accessToken $config.orderingAPIUri $logFile $config.ordersRetrievedPath $config.storeId $config.debug
            
            #Loop thru successfully downloaded orders and build JSON file used to acknowledge
            $orderAcks = @{Orders=@{}}
            $orders = @()

            if($orderFile){
                ForEach ($order In $orderFile)
                {
                    $orders += @{OrderId = $order.header.orderID}
                }
                $orderAcks.orders =$orders
                $orderAcks = ConvertTo-Json -InputObject $orderAcks
                #Acknowledge Orders with the API
                .\scripts\PutOrderAcknowledgement.ps1 $accessToken $config.orderingAPIUri $logFile $orderAcks $config.debug
            }
        } While ($orderFile.length -gt 9)
    }  
    
    $message = "End of running retrieve orders script - " +  (Get-Date).toString("u")
    Add-Content $logFile $message   
}
Catch{

    $message = "Retrieve Orders Error Message: " + $_.Exception.Message
    Add-Content $logFile $message
    $message = "Error occurred in line " +  $_.InvocationInfo.ScriptLineNumber
    Add-Content $logFile $message      
    Throw $_.Exception    

}
