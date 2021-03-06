param(
[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
[bool] $IstoStop = $true
)

[xml]$XMLContent = Get-Content AllService.xml
foreach( $ServiceName in $XMLContent.Services.Service) 
{ 
    .\SingelService.ps1 $IstoStop  $ServiceName
}