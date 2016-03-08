# CompareMatchPattern

Little PowerShell module 'CompareMatchPattern' which contains just one function 'Compare-MatchPattern'. This function applies multiple regex patterns against input string using -match operator. Function is providing simple result $true / $false depending on if all patterns match or if any of them doesn't match. Function can provide detailed report as well (like how many patterns match and which of them, etc.) which might be useful for further analyses.

Requires PowerShell 3.0 and above.
