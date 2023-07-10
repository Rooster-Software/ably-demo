/**
 * @name AblyRestResourceTest
 * @description test class for AblyRestResource apex class
 */
@isTest
private class AblyRestResourceTest {
    @isTest
    static void doPostTest() {
        // set up a test request
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();

        request.requestURI = 'https://resourceful-panda-jhqzt0-dev-ed.my.salesforce-sites.com/ably/services/apexrest/Ably/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        
        // set Ably request body
        String reqBody = '{"source":"channel.message","appId":"MTlutQ","channel":"test-channel-223","site":"us-east-1-A","ruleId":"zC9j2w","messages":[{"id":"y6hQgOYrTD:0:0","timestamp":1689022740331,"data":"hello again"}]}';
        request.requestBody = Blob.valueOf(reqBody);

        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        AblyRestResource.doPost();
        Test.stopTest();

        response = RestContext.response;

        Assert.areEqual('success', response.responseBody.toString());
    }

    @isTest
    static void doPostLongMessageTest() {
        // set up a test request
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();

        request.requestURI = 'https://resourceful-panda-jhqzt0-dev-ed.my.salesforce-sites.com/ably/services/apexrest/Ably/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        
        // set Ably request body
        String reqBody = '{"source":"channel.message","appId":"MTlutQ","channel":"test-channel-223","site":"us-east-1-A","ruleId":"zC9j2w","messages":[{"id":"y6hQgOYrTD:0:0","timestamp":1689022740331,"data":"Cupcake ipsum dolor sit amet. Jelly beans muffin liquorice bonbon dragée macaroon soufflé jelly beans. Chocolate cake gummi bears marshmallow sugar plum danish lemon drops. Shortbread topping sesame snaps fruitcake shortbread jelly-o jelly chupa chups. Jujubes bonbon soufflé cake cupcake wafer. Tootsie roll marzipan cake sweet gummi bears danish cotton candy. Lemon drops caramels cake sweet icing. Gummies candy tiramisu caramels pastry cake marshmallow. Ice cream apple pie carrot cake soufflé pudding. Donut jelly-o topping croissant donut jelly-o halvah wafer. Pudding danish bonbon caramels biscuit chocolate bar. Dessert bear claw candy canes cake cupcake bear claw brownie. Oat cake tiramisu cheesecake jelly candy lemon drops cookie candy canes. Biscuit cake gummies lollipop cupcake."}]}';
        request.requestBody = Blob.valueOf(reqBody);

        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        AblyRestResource.doPost();
        Test.stopTest();

        response = RestContext.response;

        Assert.areEqual('success', response.responseBody.toString());
    }

    @isTest
    static void doPostErrorTest() {
        // set up a test request
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();

        request.requestURI = 'https://resourceful-panda-jhqzt0-dev-ed.my.salesforce-sites.com/ably/services/apexrest/Ably/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        
        // set Ably request body without a 'channel' property
        String reqBody = '{"source":"channel.message","appId":"MTlutQ","site":"us-east-1-A","ruleId":"zC9j2w","messages":[{"id":"y6hQgOYrTD:0:0","timestamp":1689022740331,"data":"hello again"}]}';
        request.requestBody = Blob.valueOf(reqBody);

        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        AblyRestResource.doPost();
        Test.stopTest();

        response = RestContext.response;

        // Platform Event save errors are currently being caught and debugged to the console
        // the expected response is a 201
        // this, however, can be changed to meet different requirements
        Assert.areEqual(201, response.statusCode); 
    }
}