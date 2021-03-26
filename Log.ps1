<#
.SYNOPSIS
    Function to log in a file
.DESCRIPTION
    All is in da title baby :p
.EXAMPLE
    Write-Log -Header -FilePath "C:\Labs\01 - Fonctions avancées\test.log" -ToScreen
.EXAMPLE
    Write-Log -Category Information -Message "Ceci est un message d'information" -Filepath "C:\Labs\01 - Fonctions avancées\test.log" -ToScreen
    Write-Log -Category Warning -Message "Ceci est un message de warning" -Filepath "C:\Labs\01 - Fonctions avancées\test.log" -ToScreen
    Write-Log -Category Error -Message "Ceci est un message d'erreur" -Filepath "C:\Labs\01 - Fonctions avancées\test.log" -ToScreen
.EXAMPLE
    Write-Log -Footer -FilePath "C:\Labs\01 - Fonctions avancées\test.log" -ToScreen
.INPUTS
    Use help
.OUTPUTS
    Logs in file
.NOTES
    No note
.COMPONENT
    No component
.ROLE
    Anyone
.FUNCTIONALITY
    Log text in a file
#>
function Write-Log {


    [CmdletBinding(DefaultParameterSetName='SetMessage',
                   SupportsShouldProcess=$true,
                   PositionalBinding=$false
                   #HelpUri = 'http://www.microsoft.com/',
                   #ConfirmImpact='Medium'
                   )]
    #[Alias()]
    [OutputType([String])]
    Param (
        
        [Parameter(Mandatory=$true,
                   Position=0,
                   #ValueFromPipeline=$true,
                   ParameterSetName='SetHeader')]
        [Switch] 
        $Header,

        
        [Parameter(Mandatory=$true,
                   Position=1,
                   #ValueFromPipeline=$true, 
                   ParameterSetName='SetFooter')]
        [Switch] 
        $Footer,


        [Parameter(Mandatory=$true,
                   Position=2,
                   ValueFromPipelineByPropertyName
                   )]
        [String] 
        $FilePath,
        

        [Parameter(Mandatory=$true,
                   Position=3,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName,
                   ParameterSetName='SetMessage'
                   )]
        [String] 
        $Message,


        [Parameter(Mandatory=$true,
                   Position=4,
                   ValueFromPipelineByPropertyName,
                   ParameterSetName='SetMessage'
                   
                   )]
        [ValidateSet("Information", "Warning", "Error")]
        [String] 
        $Category,


        [Parameter(Position=0
                   #ValueFromPipeline=$true
                   )]
        [Switch] 
        $ToScreen

    )
    
    begin {
        #$pscmdlet.MyInvocation
    }
    
    process {
        Switch ($pscmdlet.ParameterSetName) {
            "SetHeader" {
                
                    $MyBar = "+"
                    For($i=0;$i -lt 100;$i++) { $MyBar += "-" }
                    $MyBar += "+"
                    [String]$MyOutput = $($MyBar)
                    $MyOutput += "`nScript Fullname  :       $($MyInvocation.ScriptName)"
                    $MyOutput += "`nWhen generated   :       $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
                    $MyOutput += "`nCurrent user     :       $($ENV:USERNAME)"
                    $MyOutput += "`nCurrent computer :       $((Get-CimInstance -Class Win32_ComputerSystem).Name)"
                    $MyOutput += "`nOperating System :       $((Get-CimInstance -Class Win32_OperatingSystem).Caption)"
                    $MyOutput += "`nOS Architecture  :       $((Get-CimInstance -Class Win32_ComputerSystem).SystemType)"
                    $MyOutput += "`n$($MyBar)"
                                       
            }
            "SetFooter" {
                $MyBar = "+"
                For($i=0;$i -lt 100;$i++) { $MyBar += "-" }
                $MyBar += "+"
                [String]$MyOutput = $($MyBar)
                $MyOutput += "`nEnd Time        :        $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
                $MyOutput += "`n$($MyBar)"
                
            }
            "SetMessage" {

                $MyDelimiter = ";"
                [String]$MyOutput = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
                $MyOutput += "$MyDelimiter "
                if($ToScreen) {$ActionPreference = "Continue"} else {$ActionPreference = "SilentlyContinue"}
               
                Switch ($Category) {
                "Information" { Write-Information -MessageData "$MyOutput INFORMATION : $Message" -InformationAction $ActionPreference -InformationVariable MySentence }
                "Warning" { if($ToScreen) { Write-Host -Message "$MyOutput WARNING : $Message" -ForegroundColor Yellow -InformationVariable MySentence } else {$MySentence = "$MyOutput WARNING : $Message"} }
                "Error" { if($ToScreen) { Write-Host -Message "$MyOutput ERROR : $Message" -ForegroundColor Red -InformationVariable MySentence } else {$MySentence = "$MyOutput ERROR : $Message"} }
                }
                $MyOutput = $MySentence
            }

        }
    }
    
    end {

        if($ToScreen) {
            
            if($Header) { 
                $MyOutput | Out-File -FilePath $FilePath
                $MyOutput
            } elseif($Message) {
                $MyOutput | Out-File -Append -FilePath $FilePath
            } else {
                $MyOutput | Out-File -Append -FilePath $FilePath
                $MyOutput
            }

        } else {
            if($Header) { $MyOutput | Out-File -FilePath $FilePath} else {$MyOutput | Out-File -Append -FilePath $FilePath}
        }
        
    }
}


Write-Log -Header -FilePath "C:\Labs\01 - Fonctions avancées\test.log" -ToScreen
Write-Log -Category Information -Message "Ceci est un message d'information" -Filepath "C:\Labs\01 - Fonctions avancées\test.log" -ToScreen
Write-Log -Category Warning -Message "Ceci est un message de warning" -Filepath "C:\Labs\01 - Fonctions avancées\test.log" -ToScreen
Write-Log -Category Error -Message "Ceci est un message d'erreur" -Filepath "C:\Labs\01 - Fonctions avancées\test.log" -ToScreen
Write-Log -Footer -FilePath "C:\Labs\01 - Fonctions avancées\test.log" -ToScreen

#$myObject, $myObject | Write-Log -ToScreen