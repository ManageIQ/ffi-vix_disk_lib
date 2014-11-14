require 'minitest'
require 'minitest/autorun'

begin
  require 'ffi-vix_disk_lib'
rescue LoadError
  STDERR.puts <<-EOMSG

The VMware VDDK must be installed in order to run specs.

The VMware VDDK is not redistributable, and not available on MacOSX.
See https://www.vmware.com/support/developer/vddk/ for more information.

EOMSG

  exit 1
end
