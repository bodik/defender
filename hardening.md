# Hardening

* disable unnecessary services
* setup host based firewall
* run all programs/services with least privileges, separate service users
	* windows: don't miss `SEAssignPrimaryTokenPrivilege`
	* linux mod_ruid2: mind the capabilities `CAP_SETUID`, `CAP_SETGID`



## Windows hardening

* enable defender (not as good as full AV, but better than nothing) [config-defender-enable.ps1](tools/windows/toolbox/config-defender-enable.ps1)
* enable and enforce full updates

* disable remoting [config-remoting-disable.ps1](tools/windows/toolbox/config-remoting-disable.ps1)
* enforce lsa ntlmv2 only [config-lsa-ntlmv2.ps1](tools/windows/toolbox/config-lsa-ntlmv2.ps1)
* enable smb signing [config-smb-signing.ps1](tools/windows/toolbox/config-smb-signing.ps1)
* disable smb1 [config-smb-smb1.ps1](tools/windows/toolbox/config-smb-smb1.ps1)

* use ssh server (https://www.bitvise.com/ssh-server), don't leak any passwords to caches.

* might be usefull [config-misc-hardening.ps1](tools/windows/toolbox/config-misc-hardening.ps1)
	* windows 7 notification center -- wscsvc service
	* UAC
	* elevated installers
	* plaintext credentials caching
	* LocalAccountTokenFilterPolicy


### TODO
* Applocker & SRP
* disable execute downloaded exe
