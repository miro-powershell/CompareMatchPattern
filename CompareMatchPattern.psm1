<#
PowerShellModule 'CompareMatchPattern'
ModuleVersion '1.0.0.0'
Author 'Miroslav Harlas'


Copyright (c) 2016, Miroslav Harlas
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of CompareMatchingPatterns nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#>

#Requires -Version 3.0




Function Compare-MatchPattern
{
<#
.SYNOPSIS
This function 'Compare-MatchPattern' is comparing a result of multiple -match operations using multiple patterns
(regular expressions) against a single string and returns $true or $false or a detailed result.

.DESCRIPTION
This function 'Compare-MatchPattern' performs match operation betwen 'SourceString' and all provided patterns
(regular expressions) with use of operator '-match'

You can provide single string or collection of strings to parameter 'Pattern' where each string is represents one pattern 
(regular expression). If string provided to parameter 'SourceString' matches all patterns than function returns $true. 
If 'SourceString' doesn't match any member of the provided collection of patterns than it returns $false.

Matching is case-insensitive by default.

If you use switch parameter 'Details' you will not get '$true' or '$false' but the detailed report with a number
of patterns which matches and number of those which not and some other details.
Type 'Get-Help Compare-MatchPattern -Parameter Details' to get the list of attributes of the detailed report.


Type 'Get-Help About_Regular_Expressions' to see help topic related to regular expressions in PowerShell
or look at 'https://msdn.microsoft.com/library/az24scfc.aspx' for reference quide for .NET regular expressions.


.PARAMETER SourceString
Parameter 'SourceString' accepts any string. This is the original string which has to match with all patterns specified
in parameter 'Pattern'.

.PARAMETER Pattern
Parameter 'Pattern' can contain one or more strings (collection of the strings) which represent patterns (regular expressions).
Function 'Compare-MatchPattern' returns $true if 'SourceString' is matching all patterns provided by parameter 'Pattern'.
Function 'Compare-MatchPattern' returns $false if 'SourceString' doesn't match any of the provided patterns.

.Parameter Details
This switch change the result of the function 'Compare-MatchPattern'. If the switch is not used you get only '$true' or '$false'
as a result. If you use a switch '-Details' you can get a result in thje form of the custom PSObject which contains 
a following list of properties:

'SourceString' <string>       => conatins original source string from input parameter 'SourceString'
'Patterns' <string[]>         => conatins original patterns from input parameter 'Pattern'
'NumberOfPatterns'<int>       => number of patterns from input parameter 'Pattern'
 MatchSuccess' <bool>         => Overall result containing '$true' or '$false'. the same result as if you run function without arameter '-Details'
'MatchSuccessPercent' <int>   => Approximate percentage of matching patterns
'NumberOfMatch' <int>         => number of matching patterns
'MatchPatterns' <string[]>    => subset of patterns provided in input parameter '-Pattern' which are matching the source string
'NumberOfNotMatch' <int>      => number of patterns which are not matching
'NotMatchPatterns' <string[]> => subset of patterns provided in input parameter '-Pattern' which are not matching the source string


.OUTPUTS
System.Boolean
System.Management.Automation.PSCustomObject

.EXAMPLE
PS> Compare-MatchPattern -SourceString 'My phone number is 345678908' -Pattern 'phone','\d'
True

Result of applying regexs ('My phone number is 345678908' -match 'phone') and ('My phone number is 345678908' -match '\d')
is $true in both cases. Therefore the result of the whole operation is $true as well.

.EXAMPLE
PS> "Everytime I write a script I like to start with 'hello world' and than to extend the script." | Compare-MatchPattern -Pattern 'hello','world','write','script'
True

The original string which is sent to pipe contains all following sub-strings 'hello','world','write','script'.

.EXAMPLE
PS> "Everytime I write a script I like to start with 'hello world' and than to extend the script." | Compare-MatchPattern -Pattern 'hello','world','write','script','somethingelse'
False

The original string which is sent to pipe contains all following sub-strings 'hello','world','write','script' but
it does not contain sub-string 'somethingelse' and therefore the result of the whole command is $false.

.EXAMPLE
PS> $CollectionOfStrings = "My phone number is 406456789","I know my phone number is 123456789","I don't know"
PS> $Patterns = "know","\d"
PS> $CollectionOfStrings | Where-Object{Compare-MatchPattern -SourceString $_ -Pattern $Patterns} 
I know my phone number is 123456789

Filtering a collection of the strings based on the specified set of regular expressions.


.EXAMPLE
PS> $String1 = "My phone number is 406215648"
PS> $Pattern1 = "phone","\d"
PS> $String2 = "I don't remember my phone number"
PS> $Pattern2 = "phone","\d"
PS> $String3 = "406215648"
PS> $Pattern3 = "\d"
PS> $Object1 = New-Object PSObject -Property @{"SourceString"=$String1;"Pattern"=$Pattern1}
PS> $Object2 = New-Object PSObject -Property @{"SourceString"=$String2;"Pattern"=$Pattern2}
PS> $Object3 = New-Object PSObject -Property @{"SourceString"=$String3;"Pattern"=$Pattern3}
PS> $collection = @($Object1,$Object2,$Object3)
PS> $collection | Compare-MatchPattern
True
False
True

Using collection containing custom object where each object contains 'SourceString' and its own
set of regular expressions.


.EXAMPLE
PS> $String1 = "My phone number is 406215648"
PS> $Pattern1 = "phone","\d"
PS> $String2 = "I don't remember my phone number"
PS> $Pattern2 = "phone","\d"
PS> $String3 = "406215648"
PS> $Pattern3 = "\d"
PS> $Object1 = New-Object PSObject -Property @{"SourceString"=$String1;"Pattern"=$Pattern1}
PS> $Object2 = New-Object PSObject -Property @{"SourceString"=$String2;"Pattern"=$Pattern2}
PS> $Object3 = New-Object PSObject -Property @{"SourceString"=$String3;"Pattern"=$Pattern3}
PS> $collection = @($Object1,$Object2,$Object3)
PS> $collection | Compare-MatchPattern -Details

MatchPatterns       : {phone, \d}
NumberOfNotMatch    : 0
NotMatchPatterns    : 
NumberOfMatch       : 2
SourceString        : My phone number is 406215648
NumberOfPatterns    : 2
MatchSuccessPercent : 100
MatchSuccess        : True
Patterns            : {phone, \d}

MatchPatterns       : {phone}
NumberOfNotMatch    : 1
NotMatchPatterns    : {\d}
NumberOfMatch       : 1
SourceString        : I don't remember my phone number
NumberOfPatterns    : 2
MatchSuccessPercent : 50
MatchSuccess        : False
Patterns            : {phone, \d}

MatchPatterns       : {\d}
NumberOfNotMatch    : 0
NotMatchPatterns    : 
NumberOfMatch       : 1
SourceString        : 406215648
NumberOfPatterns    : 1
MatchSuccessPercent : 100
MatchSuccess        : True
Patterns            : {\d}

Using collection containing custom object where each object contains 'SourceString' and its own
set of regular expressions and providing detailed result.


.EXAMPLE
PS> @"
10:00:01 Error # Issue Occured during some kind of operation
10:00:02 Information # Hello this is informative message
10:00:03 Warning # Issue Occured during some kind of operation
10:00:04 Information # No issue occured at this moment
10:00:05 Error # this is false alarm
10:00:06 Information # No issue occured at this moment
10:00:07 Error # another issue might occur
"@ | Out-File C:\Temp\log.txt

PS> Get-Content -Path C:\Temp\log.txt | Compare-MatchPattern -Pattern 'error','issue','occur'
True
False
False
False
False
False
True

PS> Get-Content -Path C:\Temp\log.txt | Where-Object {Compare-MatchPattern -SourceString $_ -Pattern "error","issue","occur"}
10:00:01 Error # Issue Occured during some kind of operation
10:00:07 Error # another issue might occur

This example presents a simulation of the log file and how to parse it:

- First operation creates a test file from a Here-String.
- Second operation returns $true or $false for each line of the log file, depends on the condition that line has to contain 
all specified patterns (sub-strings in this case).
- Third operation returns all the lines of the log files which meets the condition that line has to contain all specified 
specified patterns (sub-strings).


.EXAMPLE
PS> @"
10:00:01 Error # Issue Occured during some kind of operation
10:00:02 Information # Hello this is informative message
10:00:03 Warning # Issue Occured during some kind of operation
10:00:04 Information # No issue occured at this moment
10:00:05 Error # this is false alarm
10:00:06 Information # No issue occured at this moment
10:00:07 Error # another issue might occur
"@ | Out-File C:\Temp\log.txt

PS> $log = Get-Content -Path C:\Temp\log.txt 

PS> $log | Where-Object {(Compare-MatchPattern -SourceString $_ -Pattern "error","issue","occur" -Details).NumberOfMatch -ge 2}
10:00:01 Error # Issue Occured during some kind of operation
10:00:03 Warning # Issue Occured during some kind of operation
10:00:04 Information # No issue occured at this moment
10:00:06 Information # No issue occured at this moment
10:00:07 Error # another issue might occur

This example presents a simulation of the log file and how to parse it, with use of the '-Details' paramter.
This example is filtering those lines of the log file which are matching two or more provided patterns.


.EXAMPLE
PS> @"
10:00:01 Error # Issue Occured during some kind of operation
10:00:02 Information # Hello this is informative message
10:00:03 Warning # Issue Occured during some kind of operation
10:00:04 Information # No issue occured at this moment
10:00:05 Error # this is false alarm
10:00:06 Information # No issue occured at this moment
10:00:07 Error # another issue might occur
"@ | Out-File C:\Temp\log.txt

PS> $log = Get-Content -Path C:\Temp\log.txt 
PS> $Patterns = "error","issue","occur"
PS> $log | Compare-MatchPattern -Pattern $Patterns  -Details | 
            Select-Object -Property SourceString,MatchSuccess,MatchSuccessPercent,MatchPatterns | 
            Format-Table -Autosize

SourceString                                                   MatchSuccess MatchSuccessPercent MatchPatterns      
------------                                                   ------------ ------------------- -------------      
10:00:01 Error # Issue Occured during some kind of operation           True                 100 {error, issue, o...
10:00:02 Information # Hello this is informative message              False                   0                    
10:00:03 Warning # Issue Occured during some kind of operation        False                  67 {issue, occur}     
10:00:04 Information # No issue occured at this moment                False                  67 {issue, occur}     
10:00:05 Error # this is false alarm                                  False                  33 {error}            
10:00:06 Information # No issue occured at this moment                False                  67 {issue, occur}     
10:00:07 Error # another issue might occur                             True                 100 {error, issue, o...


This example presents a simulation of the log file and how to parse it, with use of the '-Details' parameter.
This example is providing a graphical result of the log file in the table format with a selected set of properties
from output of the function 'Compare-MatchPattern'


.NOTES
Type 'Get-Help About_Regular_Expressions' to see details in powershell
or look at 'https://msdn.microsoft.com/library/az24scfc.aspx' for reference quide for .NET regular expressions

#>
    [CmdletBinding()]
    param
    (

        [parameter(Mandatory=$true,
                   valuefrompipeline=$true,
                   valuefrompipelinebypropertyname=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$SourceString,

        [parameter(Mandatory=$true,
                   valuefrompipelinebypropertyname=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Pattern,
        [switch]$Details


    )
    begin
    {
    }
    process
    {
        # Declare local variables
        [bool]$CmdResult = $true
        If($Details)
        {
            Write-Verbose "Detailed result would be generated."
            [string[]]$MatchPattern = $null 
            [string[]]$NotMatchPattern = $null
            [int]$NumberOfMatch = 0
            [int]$NumberOfNotMatch = 0
        }
        Else
        {
            Write-Verbose "Result '$true' or '$false' would be generated without any other details."
        }

        ForEach($p in $pattern)
        {
            Write-Verbose "Performing operation (""$SourceString"" -match ""$p"")"
            If($SourceString -match $p)
            {
                If($Details)
                {
                    $NumberOfMatch++
                    $MatchPattern += $p
                }
            }
            Else
            {
                $CmdResult = $false
                If($Details)
                {
                    $NumberOfNotMatch++
                    $NotMatchPattern += $p
                }
            }
        }

        If($Details)
        {
            $CustomCmdResultHash = @{
                        "SourceString" = $SourceString;
                        "Patterns" = $Pattern;
                        "NumberOfPatterns" = $( If($Pattern.count){$Pattern.count}Else{1} );
                        "MatchSuccess" = $CmdResult;
                        "MatchSuccessPercent" = $( ($NumberOfMatch / $Pattern.count) * 100 -as [int] );
                        "NumberOfMatch" = $NumberOfMatch;
                        "MatchPatterns" = $MatchPattern;
                        "NumberOfNotMatch" = $NumberOfNotMatch;
                        "NotMatchPatterns" = $NotMatchPattern
                     }
            $CustomCmdResultObject = New-Object -TypeName PSObject -property $CustomCmdResultHash
            Write-OutPut $CustomCmdResultObject
        }
        Else
        {
            Write-Output $CmdResult
        }
    }
    end
    {
    }
}


# Export function
Export-ModuleMember Compare-MatchPattern