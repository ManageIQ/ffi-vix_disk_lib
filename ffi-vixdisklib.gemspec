# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ffi-vixdisklib/version'

Gem::Specification.new do |spec|
  spec.name          = "ffi-vixdisklib"
  spec.version       = FFI::VixDiskLib::VERSION
  spec.authors       = ["Jerry Keselman", "Rich Oliveri", "Jason Frey"]
  spec.email         = ["jerryk@redhat.com", "roliveri@redhat.com", "jfrey@redhat.com"]
  spec.description   = %q(Ruby Binding for VMware's VixDiskLib using FFI)
  spec.summary       = %q(Ruby Binding for VMware's VixDiskLib)
  spec.homepage      = "http://github.com/ManageIQ/vixdisklib"
  spec.license       = "MIT"

  spec.files         = `git ls-files -- lib/*`.split("\n")
  spec.files        += %w(README.md LICENSE.txt)
  spec.executables   = `git ls-files -- bin/*`.split("\n")
  spec.test_files    = `git ls-files -- spec/*`.split("\n")
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
