Function Calculate-File-Hash($filepath) {
    $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
    return $filehash
}

Function Erase-Baseline-If-Already-Exists() {
    $baselineExists = Test-Path -Path .\PoemsBaselineHash.txt
    
	# If baseline hashes already exist, it will be deleted.	
    if ($baselineExists) {
        Remove-Item -Path .\PoemsBaselineHash.txt
    }
}

Write-Host "Hello! What would you like to do?"
Write-Host ""
Write-Host "A. Create baseline hashes and save in a secure folder?"
Write-Host "B. Monitor existing file/s for changes?"
Write-Host ""
$response = Read-Host -Prompt "Kindly input either 'A' or 'B'"
Write-Host ""

if ($response -eq "A".ToUpper()) {
    # If .\PoemsBaselineHash.txt already exists, it will be deleted.
    Erase-Baseline-If-Already-Exists

    # Each file inside the .\FIM folder will have calculated hashes SHA512 and will be saved in the .\PoemsBaselineHash.txt subfolder
    $files = Get-ChildItem -Path .\FIM

    foreach ($f in $files) {
        $hash = Calculate-File-Hash $f.FullName
        "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\PoemsBaselineHash.txt -Append
    }
}

elseif ($response -eq "B".ToUpper()) {
    
    $fileHashDictionary = @{}

    # A dictionary will be created and will display the file name and calculated algorithm
    $filePathsAndHashes = Get-Content -Path .\PoemsBaselineHash.txt
    
    foreach ($f in $filePathsAndHashes) {
         $fileHashDictionary.add($f.Split("|")[0],$f.Split("|")[1])
    }

    # When the user answers 'B', the application will start continuously loop to monitor...
    #...changes, deletion, or creation of file/s
    while ($true) {
        Start-Sleep -Seconds 1
        
        $files = Get-ChildItem -Path .\FIM

        # Individual files will then be screened with their corresponding hashes compared to...
	    #... what was saved in .\PoemsBaselineHash.txt
        foreach ($f in $files) {
            $hash = Calculate-File-Hash $f.FullName
            #"$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\PoemsBaselineHash.txt -Append

            # Different notifications will pop-up depending on what transpired

		#If a new file has been created,
            if ($fileHashDictionary[$hash.Path] -eq $null) {
                Write-Host "$($hash.Path) has been created." -ForegroundColor Yellow -BackgroundColor Black 
            }
            else {

                # If a file HAS NOT been changed
                if ($fileHashDictionary[$hash.Path] -eq $hash.Hash) {
                }

		    #If a file HAS been changed,
                else {
                    Write-Host "$($hash.Path) has been changed." -ForegroundColor Cyan -BackgroundColor Black
                }
            }
        }

        foreach ($key in $fileHashDictionary.Keys) {
            $baselineFileStillExists = Test-Path -Path $key

		#If a file has been deleted,
            if (-Not $baselineFileStillExists) {
                Write-Host "$($key) has been deleted." -ForegroundColor Magenta -BackgroundColor Black
            }
        }
    }
}