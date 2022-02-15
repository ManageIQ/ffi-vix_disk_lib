if ENV['CI']
  require 'simplecov'
  SimpleCov.start
end

# LD_LIBRARY_PATH/DYLD_LIBRARY_PATH is not passed to child process on a Mac with SIP
# enabled, so build our own rudimentary version based on a different name
ENV["LIBRARY_PATH"] ||= File.expand_path("ext", __dir__) if RbConfig::CONFIG["host_os"] =~ /darwin/

require 'ffi-vix_disk_lib'
puts
puts "\e[93mUsing libvixDiskLib #{FFI::VixDiskLib::API::VERSION}\e[0m"

RSpec.configure do |config|
end
