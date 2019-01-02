#requires -version 3.0

Function New-BingoCard {

<#
   .Synopsis
    Create a Bingo card object 
    .Description
    This creates a standard bingo card object using traditional numbering. Each"row" is a separate object. You must use the custom format PS1XML file to properly format this object.
    .Parameter Free
    The number of free spaces to include in the card. The default is 1 with a maximum of 3.
   .Example
    PS C:\> New-BingoCard
  
    Write a bingo card object to the console
   .Example
    PS C:\> New-BingoCard -free 2 | convertto-html -title "Bingo" -css c:\work\bingo.css | out-file c:\work\bingo.htm
    
    Create an HTML version. This assumes you have created a CSS file to properly format the object.
    
   .Notes
    NAME: New-BingoCard
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
    Bingo.Card
#>

Param(
[Parameter(Position=0)]
[ValidateScript({$_ -gt 0 -AND $_ -le 3})]
[int]$Free=1
)

Write-Verbose "Generating a card with $free free spaces"
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
    $row = Get-Random -max 4
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
    
    #create an ordered hashtable
    $hash = [ordered]@{
        B=$b[$x]
        I=$i[$x]
        N=$n[$x]
        G=$g[$x]
        O=$o[$x]
     } 
         
    $obj = New-Object -TypeName PSObject -Property $hash

     #add a custom type name to this object for formatting
     $obj.psobject.Typenames[0]="Bingo.Card"
     #write the object to the pipeline
     $obj
} #close FOR

} #end function