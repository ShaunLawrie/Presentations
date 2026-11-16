@{
    RootModule = 'FmACP.psm1'
    ModuleVersion = '0.1.0'
    GUID = '7e1a2b3c-4d5e-4f60-8a91-2b3c4d5e6f70'
    Author = 'Shaun Lawrie'
    Description = 'Minimal Agent Client Protocol (ACP) client for testing fm-acp-agent over stdio.'
    PowerShellVersion = '7.0'
    CompatiblePSEditions = @('Core')
    FunctionsToExport = @(
        'Connect-AcpAgent',
        'Disconnect-AcpAgent',
        'New-AcpSession',
        'Invoke-AcpPrompt',
        'Set-AcpMode',
        'Send-AcpCancel',
        'Get-AcpAgent',
        'Get-AcpSession',
        'Get-AcpMode',
        'Get-AcpUpdate',
        'Remove-AcpSession'
    )
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('ACP', 'agent', 'testing')
        }
    }
}
