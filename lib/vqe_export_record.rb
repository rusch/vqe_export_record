require_relative 'vqe_export_record/version'
require_relative 'vqe_export_record/parse_error'
require_relative 'vqe_export_record/compound_packet'

class VqeExportRecord

  PACKET_TYPES = {
    1 => :compound_packet,
    2 => :missed_packets_counter,
  }

  attr_reader :version, :type, :length


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

  def decode(data)
    if !data || data.length < 4
      raise ParseError, "Data Truncated"
    end

    version, type_id, @length = data.unpack('CCn')
    if data.length < @length
      raise ParseError, "Data Truncated"
    end

    # "No flags defined yet."
    # flags   = version & 15

    @version = version >> 4
    if ![1, 2].include?(@version)
      raise ParseError, "Unsupported Protocol Version (version = #{@version})"
    end
    @type    = PACKET_TYPES[type_id]
    if !@type
      raise ParseError, "Illegal Payload Type (type = #{type_id})"
    end

    @payload = data.slice(4..(@length-1))
    self
  end

  def compound_packet_data
    return nil if @type != :compound_packet
    @payload
  end

  def compound_packet
    return nil if @type != :compound_packet
    CompoundPacket.parse(@payload)
  end

  # Missed Packets Counter
  def missed_packets_count
    return nil if @type != :missed_packets_counter
    @payload.reverse.unpack('Q').first
  end

end
