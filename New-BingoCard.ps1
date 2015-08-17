#requires -version 2.0

# -----------------------------------------------------------------------------
# Script: New-BingoCard.ps1
# Version: 2.0
# Author: Jeffery Hicks
#    http://jdhitsolutions.com/blog
#    http://twitter.com/JeffHicks
# Date: 2/1/2011
# Keywords:Get-Random, Arrays
# Comments:
#
# "Those who neglect to script are doomed to repeat their work."
#
#  ****************************************************************
#  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
#  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
#  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
#  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
#  ****************************************************************
# -----------------------------------------------------------------------------

Function New-BingoCard {

#.ExternalHelp .\PowerShellBingo-help.xml

Param(
[Parameter(Position=0,Mandatory=$False)]
[ValidateScript({$_ -gt 0 -AND $_ -le 3})]
[int]$Free=1
)

#generate unique arrays of numbers for each letter
$B=1..15  | Get-Random -count 15 | select -first 5 -unique
$I=16..30 | Get-Random -count 15 | select -first 5 -unique
$N=31..45 | Get-Random -count 15 | select -first 5 -unique
$G=46..60 | Get-Random -count 15 | select -first 5 -unique
$O=61..75 | Get-Random -count 15 | select -first 5 -unique

$Replace=0
Do {
#replace a random element with a Free Space
    $letter=1,2,3,4,5 | Get-Random
    $row=Get-Random -max 4
    Switch ($letter) {
        1 {$B[$row]="FS"}
        2 {$I[$row]="FS"}
        3 {$N[$row]="FS"}
        4 {$G[$row]="FS"}
        5 {$O[$row]="FS"}
    }
    #increment the counter
    $Replace++
    if ($free -gt 1)
    {
        #sleep just long enough so that the next random number is different
        Start-sleep -Milliseconds 200
    }
} Until ($Replace -ge $Free)
    
#loop through for the number of items in each array, which is 5
for ($x=0;$x -lt 5;$x++) 
{    
    #create a new custom object where the letters
    #B,I,N,G,O are the properties and the corresponding
    #value from the array is the property value
        
    $obj=New-Object -TypeName PSObject -Property @{
        B=$b[$x]
        I=$i[$x]
        N=$n[$x]
        G=$g[$x]
        O=$o[$x]
     } 
     #add a custom type name to this object for formatting
     $obj.psobject.Typenames[0]="Bingo.Card"
     #write the object to the pipeline
     $obj
} #close FOR

} #end function