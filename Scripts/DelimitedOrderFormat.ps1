Param(
    [System.Object] $orderFile,
    [string] $orderHistoryPath,
    [string] $d, #Delimeter
    [string] $logFile
)
Try{
    $fileName = New-Guid
    $pathFile = $orderHistoryPath + $fileName + ".txt"
    $orderHeaderLine = "orderID$($d)storeID$($d)storeName$($d)uniqueOrderID$($d)dateCreated$($d)supplierID$($d)supplierName$($d)orderTotal$($d)storePONumber$($d)accountNumber$($d)orderSource$($d)orderStatus$($d)message"
    $orderDetailLine = "supplierSKU$($d)quantity$($d)cost$($d)itemDescription$($d)pagePartition$($d)casePackSize$($d)uom$($d)gtin"

    ForEach ($order In $orderFile)
    {
        Add-content $pathFile $orderHeaderLine
        $orderLine = $order.header.orderID.ToString() + $d
        $orderLine +=  $order.header.storeID.ToString() +  $d
        $orderLine +=  $order.header.storeName +  $d
        $orderLine +=  $order.header.uniqueOrderID + $d
        $orderLine +=  $order.header.dateCreated + $d
        $orderLine +=  $order.header.supplierID.ToString() + $d
        $orderLine +=  $order.header.storeName +  $d
        $orderLine +=  $order.header.orderTotal.ToString() + $d
        $orderLine +=  $order.header.storePONumber + $d
        $orderLine +=  $order.header.accountNumber + $d
        $orderLine +=  $order.header.orderSource.ToString() + $d
        $orderLine +=  $order.header.orderStatus.ToString() + $d
        $orderLine +=  $order.header.message 
        Add-content $pathFile $orderLine
        Add-content $pathFile $orderDetailLine
        ForEach ( $orderDetail in $order.details)
        {
            $orderLine = $orderDetail.supplierSKU +  $d
            $orderLine += $orderDetail.quantity.ToString() + $d
            $orderLine += $orderDetail.cost.ToString() + $d
            $orderLine += $orderDetail.itemDescription + $d
            $orderLine += $orderDetail.pagePartition.ToString() + $d
            $orderLine += $orderDetail.casePackSize.ToString() +  $d
            $orderLine += $orderDetail.uom +  $d
            $orderLine += $orderDetail.gtin
            Add-content $pathFile $orderLine
        }
    }
    $message = "Saving Order in Delimited format " 
    Add-content $logFile $message
}

Catch{
    $message = "DelimitedOrderFormat.ps1 Error Message: " + $_.Exception.Message
    Add-content $logFile $message
    $message = "Error occurred in line " +  $_.InvocationInfo.ScriptLineNumber
    Add-Content $logFile $message
    Throw $_.Exception
}

