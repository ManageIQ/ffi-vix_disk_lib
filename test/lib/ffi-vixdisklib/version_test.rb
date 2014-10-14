require_relative '../../test_helper'

describe FFI::VixDiskLib do

  it "must be defined" do
    FFI::VixDiskLib::VERSION.wont_be_nil
  end

end
