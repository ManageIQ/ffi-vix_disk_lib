require 'ffi-vix_disk_lib'

unless FFI::VixDiskLib::API.available?
  STDERR.puts <<-EOMSG

The VMware VDDK must be installed in order to run specs.

The VMware VDDK is not redistributable, and not available on MacOSX.
See https://www.vmware.com/support/developer/vddk/ for more information.

EOMSG
  exit 1
end

RSpec.configure do |config|
end
