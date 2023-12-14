# poovvsh
An userspace OOM Killer written in Powershell
 ------
![image](https://github.com/kawaii-ghost/poovvsh/assets/86765295/bed7a783-3fed-44ef-a883-9914957ee7c2)

The name comes from `pwsh` an `oom` to `oovv`

Windows has no OOM Killer, instead it will expand the pagefile which is bad because we don't know when will it stop swapping.

Someone has already made an OOM Killer written in Python for Windows but I want to create this one in powershell so anyone can run it without needing additional program.

Inspired by https://github.com/rfjakob/earlyoom and https://gist.github.com/CTimmerman/6d1fc20c3fb61ef0ba3e2d6de2c582ce

By Default it checks if the freeRAM is below `0.36*9` Bytes and the interval is 1 second.

The Notification is optional but I enable it by default. It use this powershell module https://github.com/Windos/BurntToast. You can install it.

# ISSUES
 - SIGNAL
   We already know `SIGTERM` and `SIGKILL` in *nix, the problem is Windows didn't have signalling. `SIGTERM` equal to `WM_QUIT` and `SIGKILL` to `TerminateProcess`, `Stop-Process` in `pwsh` also calling `TerminateProcess`. https://github.com/PowerShell/PowerShell/issues/13664
 - Memory Management mechanism (?)
   NT kernel has different memory mechanism from Linux, so I would think detecting freePageFile is useless. See the OOM Killer python reference I give above.
 - Configuration
   Will do it in the future release, Insha Allah.
