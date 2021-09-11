
 function ValidateURI($address) 
     <#
    .SYNOPSIS
        Validate URI address
    .DESCRIPTION
    #>
 {
	   ($address -as [System.URI]).AbsoluteURI -ne $null
 }



function version-checker {
    <#
    .SYNOPSIS
        Check version of application in different environments.
    .DESCRIPTION
        There is a core_version in each env. 
        The core version may change over time; thus, we should track the versions, compare them, and trigger an alert if the versions are different.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0,Mandatory=$True, ValueFromPipeline = $true, ValueFromRemainingArguments = $true)]
        [string]$dev_url,
        [Parameter(Position = 1,Mandatory=$True, ValueFromPipeline = $true, ValueFromRemainingArguments = $true)]
        [string]$prod_url
    )
    begin 
    {


    
            $web_client = new-object system.net.webclient

            ###########Validate development url ###########
            if (ValidateURI($dev_url))
            {
                 Write-Verbose "Vaid dev URL" 
            ###########Validate production url ###########           
                if (ValidateURI($prod_url))
                {
                     Write-Verbose "Vaid prod URL" 


                    try 
                    {
                            ######Get horizon details from development url
                            $dev_app_info =$web_client.DownloadString($dev_url) | ConvertFrom-Json
                            Write-Host "Development environment version is"  $dev_app_info.core_version

                            ######Get horizon details from prod environment
                            $prod_app_info=$web_client.DownloadString($prod_url) | ConvertFrom-Json
                            Write-Host "Production environment version is"  $prod_app_info.core_version


                            #########Compare both version #############################

                            if ($prod_app_info.core_version -eq $dev_app_info.core_version)

                            {
                                Write-Host "Both env Versions are same"
                            }

                            else
                            {
                                Write-Host "Different Versions in both environment"
  
                            }

                    }

                    catch 
                    {
                                Write-Host "An error occurred:"
                       
                                Write-Host $_.ScriptStackTrace
                                write-host $_
                  
                    }

                }
            else

            {

                Write-Host "InVaid prod URL please check the input" 

            }

         }
            else

            {

                Write-Host "InVaid dev URL please check the input" 

            }


    }




}

version-checker -dev_url "https://horizon-testnet.stellar.org/" -prod_url  "https://horizon.stellar.org/"