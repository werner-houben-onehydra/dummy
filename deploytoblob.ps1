#upload 
param(
     [Parameter(Mandatory=$true)]
     [string]$environment
     )
#config
$integrationscriptContainer = "jscontainer"
$urlcleanscriptContainer = "urljs"
#


$dirs = Get-ChildItem -Path $folder -r  |  ? { $_.PsIsContainer -and $_.FullName -notmatch 'shared' }

function GetStorageAccount($env){
    if($env -eq "UAT"){
        return Get-AzureRmStorageAccount -ResourceGroupName onehydrauat-Migrated  -Name onehydrauat
    }
    elseif($env -eq "Release" ) {
        return Get-AzureRmStorageAccount -ResourceGroupName onehydrauat-Migrated  -Name onehydrauat
    }
    throw "$env is not a valid environment(UAT/Release)"
}


$map = @{}
Import-Csv .\mapping.csv | ForEach-Object {
        $map.Add($_.name, $_.token)
}


Foreach($d in $dirs)
{    
    $t = $map[$d.name]
    Write-Host "copying $d to blob $t"
    $storageAccount = GetStorageAccount($environment)
    #Get-AzureRmStorageAccount -ResourceGroupName onehydrauat-Migrated  -Name onehydrauat
    $ctx = $storageAccount.Context
    Set-AzureStorageBlobContent -File "$d\build.js" -Container $integrationscriptContainer  -Blob $t -Context $ctx -Force
    Set-AzureStorageBlobContent -File "$d\build.js" -Container $urlcleanscriptContainer -Blob $t -Context $ctx   -Force
}


#onehydrauat-Migrated