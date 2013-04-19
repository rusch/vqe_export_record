class VQEExportRecord
  class RTCPPayload

    attr_reader :flags,
      :original_send_time,
      :original_send_time_hi,
      :original_send_time_lo,
      :packet_dest_addr_bin,
      :packet_dest_port,
      :packet_src_port,
      :sender_role,
      :stream_dest_addr_bin,
      :stream_dest_port,
      :stream_src_addr_bin,
      :stream_type,
      :version

    def initialize(args = {})
      packet = args.delete(:packet)
      if packet
        @data = self.decode(packet)
      end
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
    def stream_src_addr
      return nil if !@stream_src_addr_bin
      @stream_src_addr_bin.unpack('C4').join('.')
    end

    def decode(payload)
      version,                # C
      @stream_type,           # C
      @stream_dest_port,      # n
      @stream_dest_addr_bin,  # a4
      @packet_dest_addr_bin,  # a4
      original_send_time,     # N
      original_send_time_lo,  # N
      @sender_role,           # C / x3
      @stream_src_addr_bin,   # a4
      @packet_dest_port,      # n
      @packet_src_port =      # n
        payload.unpack('C2na4a4N2Cx3a4n2')

      @flags   = version &  15
      @version = version >>  4

      # Overly simplicistc algorithm!
      original_send_time += original_send_time_lo.to_f / 4294967296 # 2**32
      @original_send_time =  Time.at(original_send_time - 2208988800)

      if @version == 2
        @rtcp_payload = payload.slice(32..-1)
      else
        @stream_src_addr_bin = nil
        @packet_dest_port    = nil
        @packet_src_port     = nil
        @rtcp_payload = payload.slice(24..-1)
      end
    end

    def rtcp
      @rtcp ||= RTCPPacket.new(packet: @rtcp_payload)
    end

    def payload
      @rtcp_payload
    end

  end
end
