#requires -version 2.0

# -----------------------------------------------------------------------------
# Script: Invoke-Bingo.ps1
# Version: 1.5.1
# Author: Jeffery Hicks
#    http://jdhitsolutions.com/blog
#    http://twitter.com/JeffHicks
# Date: 3/23/2012
# Keywords:
# Comments:
#
# Fixed hard code module path that shouldn't have been there.
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

Function Invoke-Bingo {

#.ExternalHelp .\PowerShellBingo-help.xml


[cmdletBinding(DefaultParameterSetName="Normal")]

Param(
    [Parameter(Mandatory=$False)]
    [ValidateScript({$_ -gt 0 -AND $_ -le 3})]
    [int]$Free=1,
    [Parameter(ParameterSetName="Normal")]
    [switch]$Normal=$True,
    [Parameter(ParameterSetName="CardOnly")]
    [switch]$CardOnly,
    [Parameter(ParameterSetName="AutoPlay")]
    [switch]$AutoPlay,
    [Parameter(ParameterSetName="AutoPlay")]
    [ValidateScript({$_ -gt 0})]
    [int]$Sleep=3
)

#get a bingo card
$card=New-BingoCard -Free $Free

#make a copy of it so we can track the original numbers
$global:cardCopy=$card | foreach {$_.psObject.Copy()}

#replace Free Space (FS) with X
foreach ($letter in @("b","i","n","g","o"))
{
    #go threw each object in $card looking at each property
    #for a match on FS
    $row=$card | where {$_.$letter -eq "FS"}
    if ($row)
    {
        #make the change to an X
        $row.$letter="X"
    }
}

#display the card
Clear-Host
$card | Format-Table

if ((-Not $CardOnly) -AND (-not $AutoPlay))
{
    #launch Get-BingoNumber in a new PowerShell window
    Start-Process -FilePath "powerShell.exe" -ArgumentList "-noprofile -command ""&{
import-module PowerShellBingo;Get-BingoNumber -prompt}"""
}

#define an array to hold draw history
$drawHistory=@()

$Playing=$True

While ($Playing)
{
    if ($AutoPlay)
    {
        [string]$call=Get-BingoNumber
    }
    else
    {
        [string]$call=Read-Host "Enter a called number. Enter nothing to quit"
    }
       
    #check the value of $call    
    if ($call.length -eq 0) 
    {
        $playing=$False
    }
    else
    {    
        #use regular expression to make sure a valid call was made
        Switch -regex ($call) {
            "^[bB]([1-9]|[1][0-5])$" {$valid=$True}
            "^[iI]([1][5-9]|[2][0-9]|[3][0])$" {$valid=$True}
            "^[nN]([3][1-9]|[4][0-5])$" {$valid=$True}
            "^[gG]([4][6-9]|[5][0-9]|[6][0])$" {$valid=$True}
            "^[oO]([6][1-9]|[7][0-5])$" {$valid=$True}
            Default {
                $valid=$False
                Write-Warning "$Call is an invalid option. Please try again."
                }
        } #Switch
        
        if ($valid)
        {
    
        $drawHistory+=$call.ToUpper()
        $letter=$call[0]
        $number=$call.Substring(1)
        
        #go through each bingo object in $card
        #get the letter property and if the value matches the number
        #replace it with an X

        $find=$card | where {$_.$letter -eq $number}
        if ($find)
        {
            $find.$letter="X"           
        }
        
       #redraw the card
       Clear-Host
       $card | Format-Table
       Write-Output `n
       
       if ($AutoPlay) {Write-Host "Called $($call.ToUpper())" -ForegroundColor Green }

        #test if we have bingo
        $Winning=Test-Bingo $card
        if ($winning)
        {
            Write-Host "BINGO!!" -ForegroundColor Green
            #display winning numbers
            Write-Output "Winning numbers are $Winning"
            $Playing=$False
        }
        #repeat until play is ended
        
        #sleep if running on AutoPlay
        if ($AutoPlay)
        {
            Start-Sleep -Seconds $Sleep
        }
    } #else
    } #if $valid
} #while
    #clear explicitly scoped variables
    Remove-Variable "cardCopy" -scope Global 
    Write-Host "Thanks for playing!" -ForegroundColor Green
    Write-output "Draw history is $drawhistory"
} #end function



