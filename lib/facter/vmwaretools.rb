## vmwaretools custom fact by meries
#

require 'facter'

# Global Variables
app_informations = {}
installpath = nil
version = nil
vmtoolsboxbinary = nil

# Functions list
def vmwaretools_version(vmtoolsboxbinary)
  Facter::Core::Execution.execute(vmtoolsboxbinary+' -v')
end

def timesync(vmtoolsboxbinary)
  Facter::Core::Execution.execute(vmtoolsboxbinary+' timesync status')
end

def timesync_exitcode(app_informations)
  returncode = $?.exitstatus

  if returncode == 69
    app_informations['timesync'] = 'disabled'
  else returncode == 0
    app_informations['timesync'] = 'enabled'
  end
end

Facter.add('vmwaretools') do
  confine :is_virtual => true
  confine :virtual => :vmware
  confine :kernel => :linux

  setcode do
    vmtoolsbinary = Facter::Core::Execution.execute('which vmtoolsd 2> /dev/null')
    vmtoolsboxbinary = Facter::Core::Execution.execute('which vmware-toolbox-cmd 2> /dev/null')

    if vmtoolsbinary == ''
      app_informations['status'] = 'uninstalled'
    else
      app_informations['status'] = 'installed'
      app_informations['version'] = vmwaretools_version(vmtoolsboxbinary)
      app_informations['location'] = vmtoolsbinary
      timesync(vmtoolsboxbinary)
      timesync_exitcode(app_informations)
    end	
    vmwaretools = app_informations
    vmwaretools
  end
end

Facter.add('vmwaretools') do
  confine :is_virtual => true
  confine :virtual => :vmware
  confine :kernel => :windows

  setcode do  
    require 'win32/registry'

    # Registry Variables Win32 
    access_type = Win32::Registry::KEY_READ | 0x100
    hklm = Win32::Registry::HKEY_LOCAL_MACHINE
    reg_path = 'SOFTWARE\\VMware, Inc.\\VMware Tools'
    reg_key_path = 'InstallPath'
    vmwaretoolsboxfile = nil
    
    # Get VMwareTools informations
    begin
      hklm.open(reg_path, access_type) do |reg|
      installpath = reg[reg_key_path]
    end 
    rescue
      installpath = nil
    end
    
    if installpath.nil?
      app_informations['status'] = "Uninstalled"
    else
      vmwaretoolsboxfile = installpath+'VMwareToolboxCmd.exe'
      vmtoolsboxbinary = '"'+installpath+'VMwareToolboxCmd.exe'+'"'
          
      if File.exist?(vmwaretoolsboxfile)
        app_informations['status'] = "installed"
        app_informations['location'] = installpath
        app_informations['version'] = vmwaretools_version(vmtoolsboxbinary)
        timesync(vmtoolsboxbinary)
        timesync_exitcode(app_informations)	  
      else
        # Nothing
      end  
    end
    vmwaretools = app_informations
    vmwaretools
  end
end
