Param(
  [string]$sourceOrderXmlFilePath,
  [string]$destinationPath,
  [string]$logFile,
  [bool]$outputToConsole,
  [bool]$useStoreMap,
  [System.Object] $storeMap
)


$fileFound = Test-Path  $sourceOrderXmlFilePath
if(-not $fileFound){
    Add-Content $logFile "Source XML File Not Found : " $sourceOrderXmlFilePath
    exit;
}


Try{

    $orderXml = [XML](Get-Content -Path $sourceOrderXmlFilePath)

    $orderHeader = $orderXml.OrderRecord.OrderHeader;

    if ($useStoreMap){
        $geniusCentralStoreId=0;
        foreach($store in $storeMap.stores){
            if ($store.clientStoreId -eq $orderHeader.StoreID){
                $geniusCentralStoreId = $store.geniusCentralStoreId
                break
            }
        }
        if ($geniusCentralStoreId -eq 0){
            $message = "Could not find a match for store mapping for store id : " + $orderHeader.StoreID
            Add-Content $logFile $message
            exit;
        }
        else{
            $orderHeader.StoreID = $geniusCentralStoreId.ToString()
        }
    }

    $headerHash = @{
        StoreID = $orderHeader.StoreID;
        StoreName = $orderHeader.StoreName;
        UniqueOrderID = [guid]::NewGuid().guid;
        DateCreated = $orderHeader.DateCreated;
        SupplierID = $orderHeader.SupplierID;
        SupplierName = $orderHeader.SupplierName;
        OrderTotal = $orderHeader.OrderTotal;
        StorePONumber = $orderHeader.PONumber;
        AccountNumber = $orderHeader.AccountNumber;
        OrderSource = $orderHeader.OrderSource;
        OrderStatus = $orderHeader.OrderStatus;
        ValidateItemData = $orderHeader.ValidateItemData;
        Message = $orderHeader.MessageToSupplier
    }

    $orderDetail = $orderXml.OrderRecord.OrderDetail;


    $detailsHash = New-Object System.Collections.Generic.List[System.Object];

    foreach($detail in $orderDetail){

        #UPC's have leading 0's and are missing check digits
        #SKU's have leading 0's
        $upc = .\scripts\UPCStripOffLeadingZeros.ps1 $detail.GTIN $false
        $upc = .\scripts\CalculateCheckDigit.ps1 $upc
        if ($detail.OrderedBy.ToLower() -eq "case"){
            $uom = "CS"
        }
        else{
            $uom = "EA"
        }


        if ($detail.SupplierSKU){
            $sku = $detail.SupplierSKU
        }
        else{
            $sku = "NA"
        }

        $orderDetailItem = @{
            GTIN = $upc;
            SupplierSKU = $sku
            Quantity = $detail.Quantity;
            Cost = $detail.Cost;
            Front = $detail.Front;
            Back = $detail.Back;
            ItemDescription = $detail.ItemDescription;
            PagePartition = $detail.PagePartition;
            CasePackSize = $detail.CasePack;
            UOM = $uom;
        }
        $detailsHash.Add($orderDetailItem);
    }

    $orderHash = @{
        Header = $headerHash;
        Details = $detailsHash;
    }

    $outFileName = $headerHash.UniqueOrderID;
    $outFileName = $outFileName.replace("{","");
    $outFileName = $outFileName.replace("}","");
    $outFileName = $outFileName + ".json";

    $jsonOutFilePath = $destinationPath + $outFileName
    $message = "Output file: $jsonOutFilePath"
    Add-Content $logFile $message
    if($outputToConsole) {
        Write-Host $message
    }

    ConvertTo-Json -InputObject $orderHash | Out-File -Encoding ASCII $jsonOutFilePath -ErrorAction Stop
    return $jsonOutFilePath

}
catch{
    Add-Content $logFile "OrderXMLtoJSON Error Message: $_.Exception.Message"
    $message = "Error occurred in line " +  $_.InvocationInfo.ScriptLineNumber
    Add-Content $logFile $message
    Throw  $_.Exception
}
