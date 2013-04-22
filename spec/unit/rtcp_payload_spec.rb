require 'spec_helper'
require 'vqe_export_record'

describe VqeExportRecord::RtcpPayload do

  it "raises exception when parsing malformed data" do
    expect { VqeExportRecord::RtcpPayload.parse("blah") }
      .to raise_error VqeExportRecord::ParseError
  end

  context "parses a valid RTCP Payload." do
    before do
      @rtcp_payload = VqeExportRecord.parse(COMPOUND_PACKET).payload
    end

    it "extracts version=2" do
      @rtcp_payload.version.should == 2
    end

    it "extracts stream_type=:primary_multicast" do
      @rtcp_payload.stream_type.should == :primary_multicast
    end

    it "extracts stream_dest_port=49310" do
      @rtcp_payload.stream_dest_port.should == 49310
    end

    it "extracts stream_dest_addr=239.186.54.142" do
      @rtcp_payload.stream_dest_addr.should == "239.186.54.142"
    end

    it "extracts packet_dest_addr=195.186.197.248" do
      @rtcp_payload.packet_dest_addr.should == "195.186.197.248"
    end

    it "extracts original_send_time=2013-04-19T18:50:57Z" do
      @rtcp_payload.original_send_time.should be_kind_of(Time)
      @rtcp_payload.original_send_time.to_i.should == 1366397457
    end

    it "extracts sender_role=:vqe_server" do
      @rtcp_payload.sender_role.should == :vqe_server
    end

    it "extracts packet_source_addr=178.238.170.142" do
      @rtcp_payload.packet_source_addr.should == "178.238.170.142"
    end

    it "extracts packet_dest_port=49311" do
      @rtcp_payload.packet_dest_port.should == 49311
    end

    it "extracts packet_source_port=39414" do
      @rtcp_payload.packet_source_port.should == 39414
    end

  end

end
