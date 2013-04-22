module TestDescriptions

  # COMPOUND_PACKET
  # Export Record: version=2, type=1 (RTCP Compound Packet), length=188 octets
  #   Compound Packet: version=2, stream-type=1 (Primary Multicast),
  #                    stream-dest-port=49310, stream-dest-addr=239.186.54.142,
  #                    packet-dest-addr=195.186.197.248,
  #                    original-send-time="2013-04-19T18:50:57Z",
  #                    sender_role=2 (VQE Server),
  #                    packet_source_addr=178.238.170.142
  COMPOUND_PACKET = to_binary %q{
    20:01:00:bc:20:01:c0:9e:ef:ba:36:8e:c3:ba:c5:f8:d5:1c:10:91:6c:d4:aa:10:02:
    ee:aa:3a:b2:ee:aa:8e:c0:9f:99:f6:81:c9:00:07:3d:43:3b:b7:82:7a:ac:3d:00:00:
    00:00:00:cb:34:3c:00:00:00:06:10:91:6c:d3:00:00:00:00:81:ca:00:06:3d:43:3b:
    b7:01:10:7a:68:2d:76:71:2d:31:2e:77:69:6e:67:6f:2e:63:68:00:00:80:d0:00:06:
    3d:43:3b:b7:3d:43:3b:b7:d5:1c:10:91:6c:d4:02:4b:0c:02:00:b2:00:00:00:02:81:
    cf:00:0f:3d:43:3b:b7:06:e0:00:09:82:7a:ac:3d:1e:6f:34:3d:00:00:00:00:00:00:
    00:00:00:00:00:00:00:00:00:15:00:00:00:06:00:00:00:05:00:00:00:00:01:00:00:
    03:82:7a:ac:3d:1e:6f:34:3d:55:cc:e0:00
  }


end
