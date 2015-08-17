#requires -version 2.0

# -----------------------------------------------------------------------------
# Script: Get-BingoNumber.ps1
# Version: 1.1
# Author: Jeffery Hicks
#    http://jdhitsolutions.com/blog
#    http://twitter.com/JeffHicks
# Date: 2/1/2011
# Keywords:
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

Function Get-BingoNumber {


#.ExternalHelp .\PowerShellBingo-help.xml

[cmdletbinding()]

Param(
[switch]$Prompt
)

#if no global variable for $master is found then create it
if (-Not $global:master)
{
    #generate unique arrays of numbers for each letter, 
    #create a letter/number combination
    #and then randomize again for good measure
    $B=1..15  | Get-Random -count 15 | foreach {write "B$_"} | Get-Random -count 15
    $I=16..30 | Get-Random -count 15 | foreach {write "I$_"} | Get-Random -count 15
    $N=31..45 | Get-Random -count 15 | foreach {write "N$_"} | Get-Random -count 15
    $G=46..60 | Get-Random -count 15 | foreach {write "G$_"} | Get-Random -count 15
    $O=61..75 | Get-Random -count 15 | foreach {write "O$_"} | Get-Random -count 15

    #build a master array of all possible numbers
    $global:master=$B+$I+$N+$G+$O 
}

#create a randomized array of $master if it doesn't already exist
if (-not $global:draw)
{
    $global:draw= $global:master | Get-Random -count $global:master.count
}

#Draw each number from $draw starting at the beginning of the array
Write-Output $global:draw[0]
#remove the first element from $draw
$global:draw=$global:draw[1..$($global:draw.count)]

#if $Prompt, then ask the user if they want to draw another number
if ($Prompt) 
{
 $r=Read-Host "Draw again? Press any other key to quit.[Y {ENTER}]"
    if (($r -match "^Y") -or ($r.length -eq 0))  
    {
        Get-BingoNumber -Prompt
    }
}

 Remove-Variable "master","draw" -scope Global -ErrorAction "SilentlyContinue"

} #end function

