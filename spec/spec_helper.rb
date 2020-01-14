ENV["LD_LIBRARY_PATH"] ||= File.expand_path("ext", __dir__)

require 'ffi-vix_disk_lib'

RSpec.configure do |config|
end
