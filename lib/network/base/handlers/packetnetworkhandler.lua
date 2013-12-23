-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\base\handlers\packetnetworkhandler.luac 

if not PacketNetworkHandler then
  PacketNetworkHandler = class(BaseNetworkHandler)
end
PacketNetworkHandler._set_shared_data = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  l_1_0._shared_data.packet_id = l_1_1
  l_1_0._shared_data.target_peer = l_1_2
  l_1_0._shared_data.sender_peer = l_1_3
  l_1_0._shared_data.cb_id = l_1_4
  l_1_0._shared_data.arb_cb_id = l_1_5
end

PacketNetworkHandler.forward_message_req_ack = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4)
  l_2_0:_set_shared_data(l_2_1, l_2_2, l_2_3, l_2_4, nil)
end

PacketNetworkHandler.message_req_ack = function(l_3_0, l_3_1, l_3_2, l_3_3)
  l_3_0:_set_shared_data(l_3_1, nil, l_3_2, l_3_3, nil)
end

PacketNetworkHandler.forward_message_arb_req_ack = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4, l_4_5)
  l_4_0:_set_shared_data(l_4_1, l_4_2, l_4_3, l_4_4, l_4_5)
end

PacketNetworkHandler.message_arb_req_ack = function(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4)
  l_5_0:_set_shared_data(l_5_1, nil, l_5_2, l_5_3, l_5_4)
end

PacketNetworkHandler.message_arbitrate_answer = function(l_6_0, l_6_1, l_6_2, l_6_3)
  l_6_0:_do_cb(l_6_1, l_6_2)
end

PacketNetworkHandler.message_ack = function(l_7_0, l_7_1, l_7_2, l_7_3)
  l_7_0:_do_cb(l_7_2)
end


