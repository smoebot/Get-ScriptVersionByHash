function Get-ScriptVersionByHash{
    $gitScriptUri = "[URL OF STORED SCRIPT GOES HERE]"
    $token = "[API FOR CODE REPOSITORY GOES HERE]"
    $headers = @{"Authorization" = "token $token" }
    $remoteScript = (Invoke-RestMethod -uri $gitScriptUri -Headers $headers -ContentType "application/json") -replace"[^ -x7e]",""
    $remoteHash = Get-FileHash -InputStream ([IO.MemoryStream]::new([Text.Encoding]::UTF8.GetBytes($remoteScript)))
    $localScript = (get-content -Raw $PSCommandPath)  -replace"[^ -x7e]","" 
    $localHash = Get-FileHash -InputStream ([IO.MemoryStream]::new([Text.Encoding]::UTF8.GetBytes($localScript)))
    if (($localHash.Hash) -eq ($remoteHash.Hash)){
        Write-Host "`r`nLocal version of script matches the Gitea Master version - This running script is the current version`r`n`r`nLocal script SHA256: $($localHash.Hash)`r`nGitea script SHA256: $($remoteHash.Hash)`r`n"
    }
    else{
        Write-host "`r`nThis running script is not the current version - Local version and Gitea Master version DO NOT match`r`nYou should do a pull/fetch from Git Extensions to get the latest changes`r`n`r`nLocal script SHA256: $($localHash.Hash)`r`nGitea script SHA256: $($remoteHash.Hash)`r`n"
    }
}
