# puppet-vmwaretools

This module has been developped to use fact vmwaretools in your puppet manifest.
Working for linux and windows operating system.


With this custom fact we can obtain : 

 - Vmware tools is installed or not installed
 - VMware tools version
 - The VMware tools home directory
 - Parameter timesync status (recommended to be disable if you have an ntp server configured)
