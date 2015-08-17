#Requires -version 2.0

# -----------------------------------------------------------------------------
# Script: PowerShellBingo.psm1
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

#dot soure all script files in the module directory
Get-ChildItem $psScriptRoot\*.PS1 | Foreach {
	Write-Verbose "Loading $_.fullname"
	. $_.fullname
}

Function HelperTest {

<#
.Synopsis
test
.Description
don't look at me
.Example

.Notes
Last Updated:
Version     : 0.9

.Link
http://jdhitsolutions.com/blog/2013/11/
#>

write 1
}
#define an alias for the game since Play is not an approved verb
Set-Alias -Name "Play-Bingo" -Value Invoke-Bingo

#export the alias and selected functions to make them visible
#these are the only commands a user needs to see.
Export-ModuleMember -alias * -function "Invoke-Bingo","Get-BingoNumber","New-BingoCard"

