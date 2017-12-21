require 'ffi-vix_disk_lib/api_wrapper'

describe FFI::VixDiskLib::ApiWrapper do
  context "connect" do
    before do
      described_class.init
    end

    it "returns a connection" do
      connect_params = {}
      connection = described_class.connect(connect_params)
      expect(connection).not_to be_nil
    end
  end
end
