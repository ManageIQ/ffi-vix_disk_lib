require 'ffi'

module FFI
  module Vixdisklib
    require File.expand_path("../ffi-vixdisklib/version", __FILE__)
    require File.expand_path("../ffi-vixdisklib/const", __FILE__)
    require File.expand_path("../ffi-vixdisklib/enum", __FILE__)
    require File.expand_path("../ffi-vixdisklib/struct", __FILE__)
    require File.expand_path("../ffi-vixdisklib/api", __FILE__)
    require File.expand_path("../ffi-vixdisklib/libc", __FILE__)
  end
end
