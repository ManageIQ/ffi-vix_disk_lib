describe FFI::VixDiskLib::API do
  let(:log)     { lambda { |_string, _pointer| } }
  let(:lib_dir) { nil }
  let(:version) { ENV.fetch("VDDK_VERSION", "6.7.0") }

  it "VERSION" do
    expect(described_class::VERSION).to eq version
  end

  it "VERSION_MAJOR" do
    expect(described_class::VERSION_MAJOR).to eq Gem::Version.new(version).segments[0]
  end

  it "VERSION_MINOR" do
    expect(described_class::VERSION_MINOR).to eq Gem::Version.new(version).segments[1]
  end

  describe ".init" do
    it "initializes successfully" do
      err = described_class.init(described_class::VERSION_MAJOR, described_class::VERSION_MINOR, log, log, log, lib_dir)
      expect(err).to eq(described_class::VixErrorType[:VIX_OK])
    end
  end

  describe "ConnectParams" do
    context "with #{described_class::VERSION}" do
      if Gem::Version.new(described_class::VERSION) >= Gem::Version.new("6.5.0")
        it "has vimApiVer" do
          expect(described_class::ConnectParams.members).to include(:vimApiVer)
        end
      else
        it "doesn't have vimApiVer" do
          expect(described_class::ConnectParams.members).to_not include(:vimApiVer)
        end
      end
    end
  end
end
