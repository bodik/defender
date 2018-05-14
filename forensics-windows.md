# Windows forensics

## generate timeline
warning: todo



## check against known hashes

* check PE signatures
	* [AnalyzePESig-crt.bat](tools/windows/toolbox/AnalyzePESig-crt.bat)
	* [sigcheck](https://docs.microsoft.com/en-us/sysinternals/downloads/sigcheck)
* check by file hash
	* https://www.nist.gov/itl/ssd/software-quality-group/nsrl-download/current-rds-hash-sets
		* http://nsrl.hashsets.com/national_software_reference_library1_search.php
	* https://accessdata.com/product-download/kff-hash-sets



## other checks

* https://virustotal.com
* entropy analysis
* [pssuspend.bat](tools/windows/toolbox/pssuspend.bat), [procdump.bat](tools/windows/procdump.bat)
* http://www.procdot.com/


## interesting places

* registry hives
	* (HKLM|HKCU)\Software\Microsoft\Windows\CurrentVersion\(Run|RunOnce|RunOnceServices?|RunServices?|RunServicesOnce?)
	* HKLM\System\CurrentControlSet\Services\
* user profile startup folder (%USERPROFILE%\Start Menu\Programs\Startup; shell:startup)
* Windows Event Log (%windir%\System32\winevt, https://github.com/williballenthin/python-evtx)
* scheduler (%windir%\tasks)
* c:\windows\temp
* profile paths for users and services
	* %windir%\System32\config\systemprofile
	* %windir%\ServiceProfiles\LocalService\AppData\Local\Temp\TfsStore\Tfs_DAV
	* %USERPROFILE%\AppData\Local\Microsoft\Windows\Temporary Internet Files\
	* %USERPROFILE%\AppData\Local\Microsoft\Windows\INetCache\IE\<subdir>
	* %USERPROFILE%\AppData\Local\Temp (generaly all temp localtions)



## powershell magic

```
get-childitem | convertto-csv | convertfrom-csv | format-table -auto
```
