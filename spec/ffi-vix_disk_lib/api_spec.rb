describe FFI::VixDiskLib::API do
  let(:major_version) { described_class::VERSION_MAJOR }
  let(:minor_version) { described_class::VERSION_MINOR }
  let(:log)           { lambda { |_string, _pointer| } }
  let(:lib_dir)       { nil }

  context "init" do
    it "initializes successfully" do
      err = described_class.init(major_version, minor_version, log, log, log, lib_dir)
      expect(err).to eq(described_class::VixErrorType[:VIX_OK])
    end
  end

  context "ConnectParams" do
    case described_class::VERSION
    when "6.5.0"
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
