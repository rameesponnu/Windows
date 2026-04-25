############################################################
<#
 .Description
   this script will uninstall OCS agent from windows servers 
   however a reboot is required to remove the service .
 .Test
   tested on windows 2008 , 2012 , 2016 and 2019 .
   was successfull .   
 .Info 
   Version:        1.0
   Author:         Ramees Vattakkandy
   Email:          ramees.vattakkandy@safrangroup.com
      
#>

############################################################
#input server list in "Servers.txt" file

$Servers= get-content "Servers.txt"


<#--------------------------------------------------------#>

foreach($Server in $Servers)

{
#checking for Ping Response
 
$ping_result =Test-Connection -ComputerName $Server -Count 1 -Quiet

if ($ping_result -eq $false){echo "Error : $Server - Unable to connect , please check manually "}
            
else { Invoke-Command -ComputerName $Server -ScriptBlock {


                                                         $computer=$env:computerName 

                                                         $OS=(Get-WMIObject win32_operatingsystem).caption
 
               $test=Test-Path  "C:\Program Files (x86)\OCS Inventory Agent\uninst.exe"
 
 if ($test) {

 Write-Host " Uninstalling Agent from $env:computerName , please wait ----------" -ForegroundColor DarkYellow

 Start-Process -NoNewWindow -FilePath  "C:\Program Files (x86)\OCS Inventory Agent\uninst.exe" -ArgumentList "/S"  -Wait -ErrorAction SilentlyContinue -ErrorVariable result_error 

 $test1=Test-Path  "C:\Program Files (x86)\OCS Inventory Agent\uninst.exe"
 
 if (!($test1)) {   Write-Host "Uninstalled OCS Agent Successfully" -ForegroundColor Cyan }

}

else { if($test -eq $false ){ write-host " $computer - OCS agent is not available in this sytem " -ForegroundColor White }}

}

}

}
 