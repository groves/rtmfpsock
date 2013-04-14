package rtmfpdata {
import flash.events.NetStatusEvent;
import flash.net.NetGroup;
import flash.utils.ByteArray;
import flash.utils.IDataInput;

public class RTMFPDataInput implements IDataInput {
    public function RTMFPDataInput(netGroup :NetGroup) {
        netGroup.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
        
    }

    private function onNetStatus(event:NetStatusEvent) :void {
        switch(event.info.code) {
            case "NetGroup.SendTo.Notify":
                trace("GOT NOTIFY: " + event);
            default:
                trace("GOT OTHER EVENT: " + event.info.code + " " + event);
        }
    }

    public function readBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void {
    }

    public function readBoolean():Boolean {
        return false;
    }

    public function readByte():int {
        return 0;
    }

    public function readUnsignedByte():uint {
        return 0;
    }

    public function readShort():int {
        return 0;
    }

    public function readUnsignedShort():uint {
        return 0;
    }

    public function readInt():int {
        return 0;
    }

    public function readUnsignedInt():uint {
        return 0;
    }

    public function readFloat():Number {
        return 0;
    }

    public function readDouble():Number {
        return 0;
    }

    public function readMultiByte(length:uint, charSet:String):String {
        return "";
    }

    public function readUTF():String {
        return "";
    }

    public function readUTFBytes(length:uint):String {
        return "";
    }

    public function get bytesAvailable():uint {
        return 0;
    }

    public function readObject():* {
        return null;
    }

    public function get objectEncoding():uint {
        return 0;
    }

    public function set objectEncoding(version:uint):void {
    }

    public function get endian():String {
        return "";
    }

    public function set endian(type:String):void {
    }
}
}
