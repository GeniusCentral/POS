Clear-Host

#Read in Configuration file
$config = Get-Content -Raw -Path "config.json" | ConvertFrom-Json

#Create folders if they do not exists
If(!(Test-Path $config.logFile)){
    New-Item $config.logFile -type directory
}
If(!(Test-Path $config.invoicesRetrievedPath)){
    New-Item $config.invoicesRetrievedPath -type directory
}
#Created a Log File
$logFile = $config.logFile + "Log - " +  (Get-Date).toString("yyyy-MM-dd") + ".txt"
Add-Content $logFile " "
$message = "Start of running script retrieve invoices - " +  (Get-Date).toString("u")
Add-Content $logFile " "
Add-Content $logFile $message

Try{

    #Get the access token from our Authentication Server
    $accessToken = .\scripts\GetAccessToken.ps1 $config.clientSecret $config.identityAPIUri $config.clientId $logFile $config.debug

    If ($accessToken){

        #Get the Invoices from the API
        $invoiceFile = .\scripts\GetInvoicesFromAPI.ps1 $accessToken $config.orderingAPIUri $logFile $config.invoicesRetrievedPath $config.storeId $config.debug $config.outputToConsole

        #Loop thru successfully downloaded invoices and build JSON file used to acknowledge
        $invoiceAcks = @{Invoices=@{}}
        $invoices = @()

        if($invoiceFile){
            ForEach ($invoice In $invoiceFile)
            {
                $message = "Invoice to acknowledge - " +  $invoice.header.oid
                Add-Content $logFile $message
                $invoices += @{oid = $invoice.header.oid}
            }
            $invoiceAcks.invoices =$invoices
            $invoiceAcks = ConvertTo-Json -InputObject $invoiceAcks
            #Acknowledge Invoice with the API
            .\scripts\PatchInvoiceAcknowledgement.ps1 $accessToken $config.orderingAPIUri $logFile $invoiceAcks $config.storeId  $config.debug
        }

    }

    $message = "End of running script retrieve invoices - " +  (Get-Date).toString("u")
    Add-Content $logFile $message
}
Catch{

    $message = "Retrieve Invoices Error Message: " + $_.Exception.Message
    Add-Content $logFile $message
    $message = "Error occurred in line " +  $_.InvocationInfo.ScriptLineNumber
    Add-Content $logFile $message
    Throw $_.Exception
}
