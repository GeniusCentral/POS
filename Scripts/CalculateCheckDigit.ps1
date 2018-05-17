Param(
    [string]$upc
)

$upcLength = $upc.length

if ($upcLength -eq 12)
{
    $useEvenDigit = 1
}
else{
    $useEvenDigit = 0
}

if ($upcLength -lt 14)
{
    $upcArray = $upc.ToCharArray()
    $checksum = 0

    for($i=0; $i -lt $upcLength; $i++){
        $upcDigit = [int]::parse($upcArray[$i])
        if($i%2 -eq $useEvenDigit){
            $upcDigit = $upcDigit*=3
        }
        $checksum+=$upcDigit
    }

    #calculate the check digit
    $checkdigit=(10-($checksum%10))

    if ($checkdigit -eq 10){
        $checkdigit = 0
    }

    #Add check digit to EAN
    $upc = $upc + $checkdigit

}

return $upc
