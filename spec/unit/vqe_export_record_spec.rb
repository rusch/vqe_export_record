require 'spec_helper'
require 'vqe_export_record'

describe VqeExportRecord do
  describe "VERSION" do
    specify { VqeExportRecord.const_get('VERSION').should eql '0.1.0' }
  end

  it "raises exception when parsing malformed data" do
    expect { VqeExportRecord.parse("blah") }
      .to raise_error VqeExportRecord::ParseError
  end

  context "parses VQE Export Record data into a Hash" do
    before do
      @export_record = VqeExportRecord.parse COMPOUND_PACKET
    end

    it "has a version number" do
      @export_record.version.should == 2
    end

    it "has a payload type" do
      @export_record.type.should == :compound_packet
    end

    it "has a length" do
      @export_record.length.should == 188
    end

    it "has payload data" do
      @export_record.payload_data.should be_kind_of(String)
      @export_record.payload_data.length.should == 184
    end

    # it "can return decoded payload" do
    #   @export_record.payload.should be_kind_of(VQEExportRecord::RTCPPayload)
    # end

  end

end
