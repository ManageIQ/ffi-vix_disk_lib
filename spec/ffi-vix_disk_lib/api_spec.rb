describe FFI::VixDiskLib::API do
  let(:log)     { lambda { |_string, _pointer| } }
  let(:lib_dir) { nil }

  it "VERSION" do
    expect(described_class::VERSION).to eq "6.7.0"
  end

  it "VERSION_MAJOR" do
    expect(described_class::VERSION_MAJOR).to eq 6
  end

  it "VERSION_MINOR" do
    expect(described_class::VERSION_MINOR).to eq 7
  end

  describe ".init" do
    it "initializes successfully" do
      err = described_class.init(described_class::VERSION_MAJOR, described_class::VERSION_MINOR, log, log, log, lib_dir)
      expect(err).to eq(described_class::VixErrorType[:VIX_OK])
    end
  end

  describe "ConnectParams" do
    it "has vimApiVer" do
      expect(described_class::ConnectParams.members).to include(:vimApiVer)
    end
  end
end
