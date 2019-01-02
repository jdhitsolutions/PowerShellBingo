#
# Module manifest for module 'PowerShellBingo'
#


@{

# Script module or binary module file associated with this manifest
ModuleToProcess = 'PowerShellBingo.psm1'

# Version number of this module.
ModuleVersion = '2.0'

# ID used to uniquely identify this module
GUID = 'bf2adca0-754a-4a96-8491-63ffbfbe5166'

# Author of this module
Author = 'Jeffery Hicks http://jdhitsolutions.com/blog'

# Company or vendor of this module
CompanyName = 'JDH Information Technology Solutions, Inc.'

# Copyright statement for this module
Copyright = '2011-2014'

# Description of the functionality provided by this module
Description = 'A PowerShell based bingo game'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '2.0'

# Name of the Windows PowerShell host required by this module
PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
PowerShellHostVersion = '3.0'

# Minimum version of the .NET Framework required by this module
DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module
CLRVersion = ''

# Processor architecture (None, X86, Amd64, IA64) required by this module
ProcessorArchitecture = 'None'

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module
ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = 'PowerShellBingo.Format.ps1xml'

# Modules to import as nested modules of the module specified in ModuleToProcess
NestedModules = @()

# Functions to export from this module
FunctionsToExport =@("Invoke-Bingo","Get-BingoNumber","New-BingoCard")

# Cmdlets to export from this module
CmdletsToExport = ""

# Variables to export from this module
VariablesToExport = ""

# Aliases to export from this module
AliasesToExport = @("Play-Bingo","bingo")

# List of all modules packaged with this module
ModuleList = @()

# List of all files packaged with this module
FileList = @("New-BingoCard.ps1","Test-Bingo.ps1","Get-BingoNumber.ps1","Invoke-Bingo.ps1","PowerShellBingo.Format.ps1xml")

# Private data to pass to the module specified in ModuleToProcess
PrivateData = ''

}



