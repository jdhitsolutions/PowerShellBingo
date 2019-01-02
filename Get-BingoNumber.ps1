#requires -version 3.0

Function Get-BingoNumber {

<#
   .Synopsis
    Return a Bingo number.
    .Description
    This function returns a Bingo number using traditional numbering. The function keeps track of draw history so no number is repeated.
   .Example
    PS C:\> get-bingonumber
    B11
  
#>

[cmdletbinding()]

Param()

#if no global variable for $master is found then create it
if (-Not $global:master)
{
    #generate unique arrays of numbers for each letter, 
    #create a letter/number combination
    #and then randomize again for good measure
    $B = 1..15  | Get-Random -count 15 | foreach {"B$_"} | Get-Random -count 15
    $I = 16..30 | Get-Random -count 15 | foreach {"I$_"} | Get-Random -count 15
    $N = 31..45 | Get-Random -count 15 | foreach {"N$_"} | Get-Random -count 15
    $G = 46..60 | Get-Random -count 15 | foreach {"G$_"} | Get-Random -count 15
    $O = 61..75 | Get-Random -count 15 | foreach {"O$_"} | Get-Random -count 15

    #build a master array of all possible numbers
    $global:master = $B+$I+$N+$G+$O 
}

#create a randomized array of $master if it doesn't already exist
if (-not $global:draw)
{
    $global:draw= $global:master | Get-Random -count $global:master.count
}

#Draw each number from $draw starting at the beginning of the array

$global:draw[0]

#remove the first element from $draw
$global:draw= $global:draw[1..$($global:draw.count)]

} #end function

