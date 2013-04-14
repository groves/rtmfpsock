package rtmfpdata {
import aspire.util.DelayUtil;

import org.flexunit.Assert;

import org.flexunit.async.Async;
import org.flexunit.async.AsyncNativeTestResponder;

public class RTMFPConnectionTest {
    [Test(async)]
    public function testNothing () :void {
        var conn :RTMFPConnection = new RTMFPConnection();
        function onReceive(response:String) :void {
            Assert.assertEquals(response, "YO");
        }
        const responder :AsyncNativeTestResponder = AsyncNativeTestResponder(Async.asyncNativeResponder(this, onReceive, onReceive, 1000));
        conn.connect("groupId", "239.254.254.2", 59273);
        conn.received.add(responder.result);
        var conn2 :RTMFPConnection = new RTMFPConnection();
        conn2.connect("groupId", "239.254.254.2", 59273);
        conn2.connectedToNeighbor.add(function (neighborPeerId:String):void {
            conn2.send(neighborPeerId, "YO");
        });
    }
}
}
