param(
[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
[bool] $IstoStop,
[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
[string]$ServiceName
)




    
    function checkerror($ServiceName)
    {
        if($error.Count  -gt 0)
        {
         Write-host "Can Not service ::  " $ServiceName
        }
    }
    
    
  function Dependencysercice([string]  $DepencySerToStopStr, [bool] $IstoStop)
  {
   $error.Clear()
   $DepencySerToStopObj = Get-Service $DepencySerToStopStr
      if($IstoStop)
      {
          
          
              Write-host  "stoping service" $DepencySerToStopObj.name   
              Stop-Service $DepencySerToStopObj.name
              checkerror($DepencySerToStopObj.name)
          
       }
       if (-not $IstoStop)
       {
       Write-host  "starting  service" $DepencySerToStopObj.name   
              start-Service $DepencySerToStopObj.name
              checkerror($DepencySerToStopObj.name)
       
       } 
  }
  
  function isServiceExist([string] $ServiceName)
  {
  [bool] $Return = $False
  if ( Get-WmiObject -Class Win32_Service -Filter "Name='$ServiceName'") {
        $Return = $True
    }
    
    Return $Return
  }




        [bool] $Temp1 = isServiceExist($ServiceName)
        if(-not $Temp1 )
        {
        return 
        }
    
        $ServiceToStop = Get-Service $ServiceName
            if($ServiceToStop.status -eq 'running' -and $IstoStop  )
            {
          
               
                if( $ServiceToStop.DependentServices) 
                {
                     Write-host "----::" $ServiceToStop.name ":: its dependency service ------- " 
                     #foreach($r in $ServiceToStop.RequiredServices) 
                     foreach($r in $ServiceToStop.DependentServices)
                     {                   
                           Dependencysercice $r.name $true                        
                     } 
                 } 
                 else
                 {
                     Write-host "----::" $ServiceToStop.name ":: DONOT HAVE ANY DEPENCENDY ------- " 
                 } 
                    Write-host "stoping service" $ServiceToStop.name 
                    Stop-Service $ServiceToStop.name    
                    
                    checkerror $ServiceToStop.name
            }
            
            ## Start Service##
            if( -not $IstoStop )
            {
            
            if( $ServiceToStop.RequiredServices) 
                {
                     Write-host "----::" $ServiceToStop.name ":: its dependency service ------- " 
                     foreach($r in $ServiceToStop.RequiredServices) 
                     {                   
                           Dependencysercice $r.name $false                       
                     } 
                     
                 } 
                 Write-host "Start  service" $ServiceToStop.name 
                 start-Service $ServiceToStop.name                   
                    checkerror($ServiceToStop.name)
                    
            }
         
        