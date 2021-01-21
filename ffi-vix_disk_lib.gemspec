# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ffi-vix_disk_lib/version'

Gem::Specification.new do |spec|
  spec.name          = "ffi-vix_disk_lib"
  spec.version       = FFI::VixDiskLib::VERSION
  spec.authors       = ["Jerry Keselman", "Rich Oliveri", "Jason Frey"]
  spec.email         = ["jerryk@redhat.com", "roliveri@redhat.com", "jfrey@redhat.com"]
  spec.description   = %q(Ruby FFI Binding to VMware VixDiskLib.)
  spec.summary       = %q(Ruby FFI Binding to VMware VixDiskLib.)
  spec.homepage      = "http://github.com/ManageIQ/ffi-vix_disk_lib"
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files -- lib/*`.split("\n")
  spec.files        += %w(README.md LICENSE.txt)
  spec.executables   = `git ls-files -- bin/*`.split("\n")
  spec.test_files    = `git ls-files -- spec/*`.split("\n")
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "manageiq-style"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_dependency "ffi"
end
