package rtmfpdata {
import aspire.util.Log;
import aspire.util.Preconditions;
import aspire.util.StringUtil;

import flash.events.NetStatusEvent;
import flash.net.GroupSpecifier;
import flash.net.NetConnection;
import flash.net.NetGroup;

import org.osflash.signals.Signal;

public class RTMFPConnection {
    private const log:Log = Log.getLog(RTMFPConnection);

    private var _conn:NetConnection;
    private var _group:NetGroup;

    private var _connectedToRTMFP:Boolean;
    private var _connectedToGroup:Boolean;

    private var _groupSpec:GroupSpecifier;

    private var _neighborPeerIds:Vector.<String> = new Vector.<String>();

    public const connectedToGroup:Signal = new Signal();

    public const connectedToNeighbor:Signal = new Signal(String);

    public const received:Signal = new Signal(String);

    private function createNetConnection():void {
        _conn = new NetConnection();
        _conn.addEventListener(NetStatusEvent.NET_STATUS, function (event:NetStatusEvent):void {
            switch (event.info.code) {
                case "NetConnection.Connect.Success":
                    _connectedToRTMFP = true;
                    if (_groupSpec != null) {
                        createNetGroup();
                    }
                    break;
                case "NetGroup.Connect.Success":
                    _connectedToGroup = true;
                    connectedToGroup.dispatch();
                    break;
                default:
                    log.info("Unhandled netconn event", "event", StringUtil.toString(event.info));
                    break;
            }

        });
        _conn.connect("rtmfp:");
    }

    private function createNetGroup():void {
        Preconditions.checkNotNull(_conn, "_conn must be set!");
        Preconditions.checkNotNull(_groupSpec, "_groupSpec must be set!");
        Preconditions.checkState(_group == null, "_group must not already exist!");
        _group = new NetGroup(_conn, _groupSpec.groupspecWithAuthorizations());
        _group.addEventListener(NetStatusEvent.NET_STATUS, function (event:NetStatusEvent):void {
            switch (event.info.code) {
                case "NetGroup.Neighbor.Connect":
                    _neighborPeerIds.push(event.info.peerID);
                    connectedToNeighbor.dispatch(event.info.peerID);
                    break;
                case "NetGroup.SendTo.Notify":
                    received.dispatch(event.info.message);
                    break;
                default:
                    log.info("Unhandled netgroup event", "event", StringUtil.toString(event.info));
                    break;
            }
        });
    }

    public function connect(groupId:String, multicastAddress:String, port:int):void {
        Preconditions.checkState(_groupSpec == null, "Only one connection at a time!");
        if (_conn == null) {
            createNetConnection();
        }

        _groupSpec = new GroupSpecifier(groupId);
        _groupSpec.ipMulticastMemberUpdatesEnabled = true;
        _groupSpec.routingEnabled = true;
        _groupSpec.addIPMulticastAddress(multicastAddress, port);

        if (_connectedToRTMFP) {
            createNetGroup();
        }
    }

    public function send(neighborPeerId :String, msg:String) :void {
        _group.sendToNearest(msg, _group.convertPeerIDToGroupAddress(neighborPeerId));
    }
}
}
