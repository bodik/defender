# Windows hardening

# disable SMB1 (eternalblue workaround)
```
reg +++
dism /online /norestart /disable-feature /featurename:SMB1Protocol
```
