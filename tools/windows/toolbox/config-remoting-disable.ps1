"==query"
sc.exe qc winrm
sc.exe queryex winrm


"==setup"
sc.exe stop winrm
sc.exe config winrm start= disabled
