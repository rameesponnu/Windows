#created by ramees vattakkandy
#date    06.06.2016

$file = gc "computer.txt"
$out = "test.log"
$date = (get-date)
#---------------------------------------------------------------
$count_no_ping            =[int]0
$count_total              =[int]0
$count_tried              =[int]0
$count_access_denied      =[int]0
$count_error              =[int]0

#---------------------------------------------------------------

echo " following services were ignored during the check
                    
*----------------------------------------------------------------*
         Microsoft .NET Framework NGEN v4.0.30319_X64
         Microsoft .NET Framework NGEN v4.0.30319_X86
            Windows Licensing Monitoring Service
             Windows Image Acquisition (WIA)
                 Shell HardWare Detection
                   Software Protection
                    TPM Base Services                                 
*----------------------------------------------------------------*                   
               " |Out-File $out -Append   

$count_total  = $file.Count

echo "" | Out-File $out -Append -force

echo "located $count_total servers , getting information from each server"

echo ""

#--------------------------------------------------------------------

Foreach ($computername in $file)
{


#get Ip and ping result

$ping_result =Test-Connection -ComputerName $computername -Count 1 -Quiet

echo "" 

if ($ping_result -eq $false)

{

echo "Error : $computername - Unable to connect , please check manually ($date)" |Out-File $out -Append -Force

$count_no_ping = $count_no_ping +1
  

}

else #we could ping server

{

$result = Get-WmiObject win32_service -Filter "startmode = 'auto' and state != 'running'" -ComputerName $computername -ErrorAction SilentlyContinue -ErrorVariable result_error|  Where-Object {($_.name -notlike  "clr_optimization_v4*" )-and  ($_.name -notlike  "sppsvc*" )  -and  ($_.name -notlike  "WLMS*" ) -and ($_.name -notlike  "ShellHWDetection*" )}

     if(!($result_error[0] -eq $null))

         {
         
         echo  "Error : $computername - Access Denied  ,    please check manually ($date)" | Out-File $out -Append -Force

      $count_error = $count_error + 1

       sleep -Seconds 5
   
          }}}

      foreach($computer in $file)

          {
          
          sleep -seconds 2
          
         $result = Get-WmiObject win32_service -Filter "startmode = 'auto' and state != 'running'" -ComputerName $computer -ErrorAction SilentlyContinue -ErrorVariable result_error|  Where-Object {($_.name -notlike  "clr_optimization_v4*" )-and ($_.name -notlike  "TBS*" ) -and ($_.name -notlike  "stisvc*" )-and ($_.name -notlike  "sppsvc*" )  -and  ($_.name -notlike  "WLMS*" ) -and ($_.name -notlike  "ShellHWDetection*" )}    
         
         sleep -seconds 2
         
         echo "$computer" | out-file $out -Append -force
                          
         $result | select-object  Name,state  |out-file $out -Append -force

         $count_tried = $count_tried +[int]1
         
         sleep -seconds 2

          }



$count_tried =$count_total-($count_no_ping+$count_error)
echo ""                                                       |Out-File $out -Append -force
echo "Total number of Servers               = $count_total"         | Out-File $out -Append -force
echo "Check was successfull for             = $count_tried "                             | Out-File $out -Append -force
echo "Check Failed with Unable to connect   = $count_no_ping"                          | Out-File $out -Append -force
echo "Check Failed with Access denied       = $count_error"                              | Out-File $out -Append -force



$from = "service.check@example.com"
$to   = "end-user@example.com"
$cc   = "ramees.vattakkandy@example.com"
$subject= "SVCcheck"
$Smtp  = "smtp.example.com"
$body = "Automated  Service Check ( PATCH UPDATE - Monitoring Team )"
$attachment = "test.log"

Send-MailMessage -From $from -To $to -CC $cc -Subject $subject -Body $body -Attachments $attachment -SmtpServer $Smtp






