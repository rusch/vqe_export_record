require 'spec_helper'
require 'vqe_export_record'

describe VqeExportRecord do
  describe "VERSION" do
    specify { VqeExportRecord.const_get('VERSION').should eql '0.1.0' }
  end

  context "Detect malformed data" do
    it "raises an exception when the length field cannot be read" do
      # the packet is shorter than 4 octets
      expect { VqeExportRecord.parse("X") }
        .to raise_error VqeExportRecord::ParseError
    end

    it "raises an exception when there is less data than expected" do
      expect { VqeExportRecord.parse(COMPOUND_PACKET_V2.slice(0..10)) }
        .to raise_error VqeExportRecord::ParseError
    end

    it "raises an exception when version=3" do
      corrupt_packet = COMPOUND_PACKET_V2.clone
      corrupt_packet[0] = (3 << 4).chr
      expect { VqeExportRecord.parse(corrupt_packet) }
        .to raise_error(VqeExportRecord::ParseError, /version/)
    end

    it "raises an exception when the payload type is unknown (3)" do
      corrupt_packet = COMPOUND_PACKET_V2.clone
      corrupt_packet[1] = 3.chr
      expect { VqeExportRecord.parse(corrupt_packet) }
        .to raise_error(VqeExportRecord::ParseError, /type/)
    end
  end

  it "Reads a packet from the supplied Socket" do
    client = double("TCPSocket")
    client.should_receive(:read).with(4).once.and_return(COMPOUND_PACKET_V2[0,4])
    client.should_receive(:read).with(184).and_return(COMPOUND_PACKET_V2[4, 184])

    VqeExportRecord.read(client)
  end

  context "Parses a valid Export Record V2 of type 'RTCP Compound Packet'" do
    before do
      @export_record = VqeExportRecord.parse COMPOUND_PACKET_V2
    end

    it "extracts version number" do
      @export_record.version.should == 2
    end

    it "extracts payload type" do
      @export_record.type.should == :compound_packet
    end

    it "extracts length" do
      @export_record.length.should == 188
    end

    it "has payload data" do
      @export_record.payload_data.should be_kind_of(String)
      @export_record.payload_data.length.should == 184
    end

    it "can return decoded payload" do
      @export_record.payload.should be_kind_of(VqeExportRecord::RtcpPayload)
    end

  end

  context "Parses a valid Export Record of type 'Missed Packets Counter'" do
    before do
      @export_record = VqeExportRecord.parse MISSED_PACKETS_COUNTER
    end

    it "extracts version number" do
      @export_record.version.should == 2
    end

    it "extracts payload type" do
      @export_record.type.should == :missed_packets_counter
    end

    it "extracts length" do
      @export_record.length.should == 12
    end

    it "does not return decoded payload" do
      @export_record.payload.should == nil
    end

    it "extracts missed_packets_counter=1073" do
      @export_record.missed_packets_count.should == 1073
    end
  end
end
