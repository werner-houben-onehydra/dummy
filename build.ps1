# requires nodejs & uglyfyjs
# npm install uglify-js -g 
 
$dirs = Get-ChildItem -Path $folder -r  |  ? { $_.PsIsContainer -and $_.FullName -notmatch 'shared' }

Foreach($d in $dirs)
{    
    if (Test-Path "$d/foundItCommon.js") 
    { 
        Write-Host "Building $d with custom shared"
        uglifyjs .\$d\config.js .\$d\foundItCommon.js -o .\$d\build.js --comments

    }
    else {
        Write-Host "Building $d with common shared"
        uglifyjs .\$d\config.js .\Shared\foundItCommon.js -o .\$d\build.js --comments
    }
}