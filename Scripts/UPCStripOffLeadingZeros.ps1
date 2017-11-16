Param(
    [string]$upc,
    [bool]$hasCheckDigit
)

if ($hasCheckDigit){
    $minimumLength = 12
}
else{
    $minimumLength = 11
}

#Stip off leading 0's until the UPC is the minimum length
While ($upc.Length -gt $minimumLength -and $upc.StartsWith(0)){
    $upc = $upc.subString(1);
}

return $upc

