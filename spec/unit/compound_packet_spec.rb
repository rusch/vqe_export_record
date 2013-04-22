require 'spec_helper'
require 'vqe_export_record'

describe VqeExportRecord::CompoundPacket do

  context "Detect malformed data" do
    let(:rtcp_paket) { VqeExportRecord.parse(COMPOUND_PACKET_V2).payload_data }
    let(:rtcp_paket_v1) { VqeExportRecord.parse(COMPOUND_PACKET_V1).payload_data }

    it "raises exception when V2 packet is shorter than a property header" do
      expect { VqeExportRecord::CompoundPacket.parse(rtcp_paket.slice(0..30)) }
        .to raise_error VqeExportRecord::ParseError
    end

    it "raises exception when V2 packet is shorter than a property header" do
      expect { VqeExportRecord::CompoundPacket.parse(rtcp_paket_v1.slice(0..26)) }
        .to raise_error VqeExportRecord::ParseError
    end

    it "raises an exception when version=3" do
      corrupt_packet = rtcp_paket.clone
      corrupt_packet[0] = (3 << 4).chr
      expect { VqeExportRecord::CompoundPacket.parse(corrupt_packet) }
        .to raise_error(VqeExportRecord::ParseError, /version/)
    end

    it "raises an exception when the stream type is unknown (5)" do
      corrupt_packet = rtcp_paket.clone
      corrupt_packet[1] = 5.chr
      expect { VqeExportRecord::CompoundPacket.parse(corrupt_packet) }
        .to raise_error(VqeExportRecord::ParseError, /stream_type/)
    end

    it "raises an exception when the stream type is unknown (5)" do
      corrupt_packet = rtcp_paket.clone
      corrupt_packet[20] = 5.chr
      expect { VqeExportRecord::CompoundPacket.parse(corrupt_packet) }
        .to raise_error(VqeExportRecord::ParseError, /sender_role/)
    end
  end    

  context "parses a valid RTCP Payload V1." do

    before do
      @rtcp_payload = VqeExportRecord.parse(COMPOUND_PACKET_V1).payload
    end

    it "extracts version=2" do
      @rtcp_payload.version.should == 1
    end

    it "sets packet_source_addr, packet_dest_port and packet_source_port to nil" do
      @rtcp_payload.packet_source_addr.should == nil
      @rtcp_payload.packet_dest_port.should == nil
      @rtcp_payload.packet_source_port.should == nil
    end
  end

  context "parses a valid RTCP Payload V2." do
    before do
      @rtcp_payload = VqeExportRecord.parse(COMPOUND_PACKET_V2).payload
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

    it "extracts the rtcp payload data" do
      @rtcp_payload.payload_data.should be_kind_of(String)
      @rtcp_payload.payload_data.length.should == 152
    end
  end

end
