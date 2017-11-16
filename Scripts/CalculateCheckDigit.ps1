Param(
    [string]$upc
)


if ($upc.length -eq 11)
{
    $upcArray = $upc.ToCharArray()  
    $checksum = 0
    
    for($i=0; $i -lt 11; $i++){
        $upcDigit = [int]::parse($upcArray[$i])
        if($i%2){
            #odd digits, multiply by 3
            $upcDigit = $upcDigit*=3
        }

        $checksum+=$upcDigit
    }


    Write-Host $checksum

    #calculate the check digit
    $checkdigit=(10-($checksum%10))

    if ($checkdigit -eq 10){
        $checkdigit = 0
    }
        #Add EAN with check digit to output file
    $upc = $upc + $checkdigit
}
return $upc