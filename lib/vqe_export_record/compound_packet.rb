class VqeExportRecord
  class CompoundPacket

    attr_reader :flags,
      :original_send_time,
      :original_send_time_hi,
      :original_send_time_lo,
      :packet_dest_addr_bin,
      :packet_dest_port,
      :packet_source_port,
      :sender_role,
      :stream_dest_addr_bin,
      :stream_dest_port,
      :stream_source_addr_bin,
      :stream_type,
      :version

    STREAM_TYPES = {
      1 => :primary_multicast,
      2 => :re_sourced_multicast,
      3 => :retransmission,
      4 => :primary_unicast,
    }

    SENDER_ROLES = {
      1 => :vqe_client,
      2 => :vqe_server,
      3 => :vqe_server_headend,
      4 => :cds_tv_server,
    }

    def self.parse(data)
      self.new.decode(data)
    end

    def decode(data)
      @version = (data.unpack('C')[0] >> 4)

      case @version
      when 1
        pattern = 'xCna4a4N2Cx3'
        raise ParseError, "Data Truncated" if data.length < 28
      when 2
        pattern = 'xCna4a4N2Cx3a4n2'
        raise ParseError, "Data Truncated" if data.length < 32
      else
        raise ParseError, "Unsupported Protocol Version (version = #{@version})"
      end

      stream_type,              # C
        @stream_dest_port,      # n
        @stream_dest_addr_bin,  # a4
        @packet_dest_addr_bin,  # a4
        original_send_time,     # N
        original_send_time_lo,  # N
        sender_role,            # C / x3
        @packet_source_addr_bin,# a4
        @packet_dest_port,      # n
        @packet_source_port =   # n
          data.unpack(pattern)

      @stream_type = STREAM_TYPES[stream_type]
      if !@stream_type
        raise ParseError, "Illegal Stream Type (stream_type = #{stream_type}"
      end

      # "No flags defined yet. Must be zero on transmit, and ignored
      # in receipt."
      # flags   = version &  15

      # Overly simplicistc algorithm!
      original_send_time += original_send_time_lo.to_f / 4294967296 # 2**32
      @original_send_time =  Time.at(original_send_time - 2208988800)

      @sender_role = SENDER_ROLES[sender_role]
      if !@sender_role
        raise ParseError, "Illegal Sender Role (sender_role = #{sender_role})"
      end

      if @version == 2
        @payload_data = data.slice(32..-1)
      else
        @stream_source_addr_bin = nil
        @packet_dest_port    = nil
        @packet_source_port     = nil
        @payload_data = data.slice(24..-1)
      end
      self
    end

    def stream_dest_addr
      return nil if !@stream_dest_addr_bin
      @stream_dest_addr_bin.unpack('C4').join('.')
    end

    def packet_dest_addr
      return nil if !@packet_dest_addr_bin
      @packet_dest_addr_bin.unpack('C4').join('.')
    end

    # Only Protocol Version 2
    def packet_source_addr
      return nil if !@packet_source_addr_bin
      @packet_source_addr_bin.unpack('C4').join('.')
    end

    def payload_data
      @payload_data
    end

  end
end
