require_relative './spec_helper'

describe FFI::VixDiskLib::VERSION do
  it "must be defined" do
    FFI::VixDiskLib::VERSION.wont_be_nil
  end
end
