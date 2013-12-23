-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\base\handlers\defaultnetworkhandler.luac 

if not DefaultNetworkHandler then
  DefaultNetworkHandler = class()
end
DefaultNetworkHandler.init = function(l_1_0)
end

DefaultNetworkHandler.lost_peer = function(l_2_0)
  cat_print("multiplayer_base", "Lost Peer (DefaultNetworkHandler)")
  if managers.network:session() then
    local peer = managers.network:session():peer_by_ip(l_2_0:ip_at_index(0))
    if peer then
      managers.network:session():on_peer_lost(peer, peer:id())
    end
  end
end

DefaultNetworkHandler.lost_client = function(l_3_0)
  Application:error("[DefaultNetworkHandler] Lost client", l_3_0)
  if managers.network:session() then
    local peer = managers.network:session():peer_by_ip(l_3_0:ip_at_index(0))
    if peer then
      managers.network:session():on_peer_lost(peer, peer:id())
    end
  end
end

DefaultNetworkHandler.lost_server = function(l_4_0)
  Application:error("[DefaultNetworkHandler] Lost server", l_4_0)
  if managers.network:session() then
    local peer = managers.network:session():peer_by_ip(l_4_0:ip_at_index(0))
    if peer then
      managers.network:session():on_peer_lost(peer, peer:id())
    end
  end
end


