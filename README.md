# puppet-vmwaretools

This module has been developped to use fact vmwaretools in your puppet manifest.
Working for linux and windows operating system.


With this custom fact we can obtain : 

 - Vmware tools is installed or not installed
 - VMware tools version
 - Where VMware tools has been installed (homedir)
 - Parameter timesync status (recommended to be disable if you have an ntp server configured)
 
 
 ---
 Example :
 
 ```
 foreman :: puppet-vmwaretools/lib/facter # facter -p vmwaretools
{
  status => "installed",
  version => "10.0.5.52125 (build-3227872)",
  location => "/usr/bin/vmtoolsd",
  timesync => "disabled"
}
 ```
