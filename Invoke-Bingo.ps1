#requires -version 3.0


Function Invoke-Bingo {

<#
   .Synopsis
    Start a game of PowerShell Bingo
    .Description
    This command will start a game of PowerShell Bingo. By default you will get a card with any free spaces automatically converted to X. Enter the values when prompted in the game session. Press Y in the draw session to get the next number and repeat.
    
    You can also play without the draw session by using the -CardOnly parameter. Use this when several people are playing as you only need one person drawing.
    
    For fun, you can also use -AutoPlay which will automatically play a game, drawing numbers and updating the card until a Bingo is made. Use -Sleep to define the interval between draws. The default is 3 and must be greater or equal to 1.
    
    After a Bingo is made you will see a list of the winning numbers as well as a draw history so you can confirm any Bingos.
    
   .Parameter Free
    The number of free spaces to include in the card. The default is 1 with a maximum of 3.
   .Parameter Normal
    The default behavior which is to display a card and separate draw session.
   .Parameter CardOnly
    Display a bingo card only.
   .Parameter AutoPlay
    Have the computer automatically draw numbers and update the card until a Bingo is made.
   .Parameter Sleep
    The number of seconds to sleep between draws when in Autoplay mode. The default is 3 and must be at least 1.
   .Parameter Voice
    Use the text to speech engine to announce drawn numbers. Has an alias of Caller.
   .Example
    PS C:\> Invoke-Bingo
    .Example
    PS C:\> Invoke-Bingo -free 3 -voice  
   .Notes
    NAME: Invoke-Bingo
    AUTHOR: Jeffery Hicks
    VERSION: 2.0
    LASTEDIT: October 1, 2014
    
    Learn more:
     PowerShell in Depth: An Administrator's Guide (http://www.manning.com/jones6/)
     PowerShell Deep Dives (http://manning.com/hicks/)
     Learn PowerShell 3 in a Month of Lunches (http://manning.com/jones3/)
     Learn PowerShell Toolmaking in a Month of Lunches (http://manning.com/jones4/)
            
    .Inputs
    None
    
    .Outputs
   Custom object
#>
[cmdletBinding(DefaultParameterSetName="Normal")]

Param(
    [Parameter(Position=0)]
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
    [Alias("pause")]
    [int]$Sleep=3,
    [Parameter(ParameterSetName="Normal")]
    [Alias("Caller")]
    [switch]$Voice
)

if ($voice) {
 #create a global variable for the voice
  Add-Type -AssemblyName System.speech
 $MyCaller = New-Object System.Speech.Synthesis.SpeechSynthesizer
  [void]$MyCaller.SpeakAsync("Let's play a game.")
 
}

#get a bingo card
$card = New-BingoCard -Free $Free

#make a copy of it so we can track the original numbers
$global:cardCopy = $card | foreach {$_.psObject.Copy()}

#replace Free Space (FS) with X
foreach ($letter in @("b","i","n","g","o"))
{
    #go through each object in $card looking at each property
    #for a match on free space (FS)
    $rows= $card | where {$_.$letter -eq "FS"}
    if ($rows)
    {
    #there could be matches on the same letter but in different rows
    foreach ($row in $rows) {
        #make the change to an X
        $row.$letter="X"
     } #foreach row
    }
}

#define an array to hold draw history
$drawHistory=@()
    
$Playing=$True

While ($Playing)
{
    #display the card
    Clear-Host
    $card | Format-Table

    #test if we have bingo
    $Winning = Test-Bingo $card
    if ($winning)
    {
        Write-Host "BINGO!!" -ForegroundColor Green
        if ($voice) { [void]$MyCaller.SpeakAsync("Bingo") }

        #display winning numbers
        Write-Output "Winning numbers are $Winning"
        $Playing=$False
        #bail out of the while
        Break
    }

    if (-Not $Cardonly) {
        #only get numbers on Normal and Autoplay
        [string]$called = Get-BingoNumber
        Write-Host "Called $($called.ToUpper())" -ForegroundColor Green
        $l = $called.Substring(0,1)
        $n = $called.Substring(1)
        if ($voice) { [void]$MyCaller.SpeakAsync("$l $n") }
    
    }
    if ($AutoPlay)
    {
        [string]$call = $Called
    }
    else
    {
        #called number will be displayed above the prompt
        [string]$call = Read-Host "Enter a called number. Enter nothing to quit"
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
       
        
        #repeat until play is ended
        
        #sleep if running on AutoPlay
        if ($AutoPlay)
        {
            Start-Sleep -Seconds $Sleep
        }
    } #else
    } #if $valid
} #while
    
    Write-Host "Thanks for playing!" -ForegroundColor Green
    if ($voice) { [void]$mycaller.SpeakAsync("Thanks for playing.") }

    If ($drawhistory) {
     Write-Host "It took $($drawHistory.count) draws to win." -ForegroundColor Yellow
     Write-Host "Draw history is $drawhistory" -ForegroundColor yellow
    }
    
    #clear explicitly scoped variables
    Remove-Variable "cardCopy","master","draw" -scope Global -ErrorAction "SilentlyContinue"

} #end function



