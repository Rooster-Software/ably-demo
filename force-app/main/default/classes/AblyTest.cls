/**
 * @name AblyTest
 * @description test class for Ably apex class
 */
@isTest
private class AblyTest {
    @isTest
    static void publishMessageTest() {
        String channel = 'my-test-channel';
        String message = 'This is a test message';
        
        Test.setMock(HttpCalloutMock.class, new AblyMock()); // set mock

        Test.startTest();
        String messageId = Ably.publishMessage(channel, message);
        Test.stopTest();

        Assert.areEqual('avt6ieY_T7:0', messageId);
    }

    @isTest
    static void publishMessageErrorTest() {
        String channel = '';
        String message = 'This is a test message';
        
        Test.setMock(HttpCalloutMock.class, new AblyMock()); // set mock

        Test.startTest();
        String messageId = Ably.publishMessage(channel, message);
        Test.stopTest();

        Assert.areEqual('error', messageId);
    }
}