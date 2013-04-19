require_relative 'vqe_export_record/version'
require_relative 'vqe_export_record/parse_error'
require_relative 'vqe_export_record/rtcp_payload'

class VqeExportRecord

  PACKET_TYPES = {
    1 => :compound_packet,
    2 => :missed_packets_counter,
  }

  attr_reader :version, :type, :flags, :payload


  def self.read(socket)
    header = socket.read(4)
    return nil if !header
    len = header.unpack('xxn')[0]
    data = socket.read(len - 4)
    self.parse(header + data)
  end

  def self.parse(data)
    self.new.decode(data)
  end

  def initialize(args = {})
  end

  def decode(packet)
    if !packet || packet.length < 4
      raise ParseError, "Data truncated"
    end

    version, type_id, len = packet.unpack('CCn')
    if packet.length < len
      raise ParseError, "Data truncated"
    end
      
    @flags   = version & 15
    @version = version >> 4
    @type    = PACKET_TYPES[type_id]
    if !@type
      raise ParseError, "Illegal payload type"
    end

    @payload = packet.slice(4..(len-1))
    self
  end

  def rtcp_cp
    return nil if @type != :compound_packet
    @rtcp_cp ||= VQEExportRecordRTCPPayload.new(packet: @payload)
  end

  def count
    @count ||= @payload.unpack('Q>')[0]
  end

end
