#requires -version 2.0


# -----------------------------------------------------------------------------
# Script: Test-Bingo.ps1
# Version: 1.0
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


Function Test-Bingo {

   #.ExternalHelp .\PowerShellBingo-help.xml
  

    Param(
    [Parameter(Position=0,Mandatory=$True,HelpMessage="Enter a bingo card object")]
    [object]$card
    )
    
    #define a win
    
    #count 5 down
    foreach ($letter in @("b","i","n","g","o"))
    {
        $count=0
        
        #if there are 5 Xs for any one property (ie a letter column), then we have a Bingo
        $count+=($card | where {$_.$letter -eq "X"} | measure-object).count
        #"{0}={1}" -f $letter,$count
        if ($count -eq 5) 
        {
            #write the winning list of numbers
           
            Return @(
            ("{0}{1}" -f $letter.ToUpper(), $global:cardCopy[0].$letter),
            ("{0}{1}" -f $letter.ToUpper(), $global:cardCopy[1].$letter),
            ("{0}{1}" -f $letter.ToUpper(), $global:cardCopy[2].$letter),
            ("{0}{1}" -f $letter.ToUpper(), $global:cardCopy[3].$letter),
            ("{0}{1}" -f $letter.ToUpper(), $global:cardCopy[4].$letter)
            
            )
        } #if
    } #foreach

    #count 5 across
    for ($z=0;$z -lt 5;$z++)
    {
        $count=($card[$z].b,$card[$z].i,$card[$z].n,$card[$z].g,$card[$z].o | 
          Where {$_ -eq "X"} | Measure-object).count
        #"Row {0}={1}" -f $z,$count
        if ($count -eq 5) 
        {
            #write the winning list of numbers
            Return @(
            ("{0}{1}" -f "B",$global:cardCopy[$z].b),
            ("{0}{1}" -f "I",$global:cardCopy[$z].i),
            ("{0}{1}" -f "N",$global:cardCopy[$z].n),
            ("{0}{1}" -f "G",$global:cardCopy[$z].g),
            ("{0}{1}" -f "O",$global:cardCopy[$z].o)
            )
        }
    }
    
    #count diagonal
    $count=($card[0].b,$card[1].i,$card[2].n,$card[3].g,$card[4].o |
     Where {$_ -eq "X"} | Measure-object).count
    #"Upper Right to lower left=$count"
    if ($count -eq 5) 
    {
        #write the winning list of numbers
        Return @(
        ("{0}{1}" -f "B",$global:cardCopy[0].b),
        ("{0}{1}" -f "I",$global:cardCopy[1].i),
        ("{0}{1}" -f "N",$global:cardCopy[2].n),
        ("{0}{1}" -f "G",$global:cardCopy[3].g),
        ("{0}{1}" -f "O",$global:cardCopy[4].o)
        )
        
    }

    $count=($card[4].b,$card[3].i,$card[2].n,$card[1].g,$card[0].o |
     Where {$_ -eq "X"} | Measure-object).count
    #"Lower Right to Upper left=$count"
    if ($count -eq 5) 
    {
        #write the winning list of numbers
        Return  @(
       ("{0}{1}" -f "B",$global:cardCopy[4].b),
        ("{0}{1}" -f "I",$global:cardCopy[3].i),
        ("{0}{1}" -f "N",$global:cardCopy[2].n),
        ("{0}{1}" -f "G",$global:cardCopy[1].g),
        ("{0}{1}" -f "O",$global:cardCopy[0].o)
        )
        
    }
    #no winning combinations
    Write-Output $False

} #end Function