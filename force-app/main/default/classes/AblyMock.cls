/**
 * mock api callout responses for AblyRestResourceTest class
 * @name AblyRestResourceMock 
 */
@isTest
global class AblyMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        Map<String,Object> requestMap = (Map<String,Object>) JSON.deserializeUntyped(req.getBody()); // parse request

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Connection', 'keep-alive');

        String reqEndpoint = req.getEndpoint(); // reqEndpoint format: https://rest.ably.io/channels/channel-name/messages
        String channel = reqEndpoint.split('/')[4];
        String resBody;

        if (channel == '') {
            resBody = getErrorResponseBody(channel);
            res.setHeader('Content-Length', '309');
            res.setStatus('Not Found');
            res.setStatusCode(404);
        } else {
            resBody = getResponseBody(channel);
            res.setHeader('Content-Length', '63');
            res.setStatusCode(201);
            res.setStatus('Created');
        }

        res.setBody(resBody);

        return res;
    }

    private String getErrorResponseBody(String channelName) {
        Map<String,Object> resBody = new Map<String,Object>();
        Map<String,Object> errorBody = new Map<String,Object>();
        errorBody.put('message', 'Could not find path: channels/' + channelName + '/messages. (See https://help.ably.io/error/40400 for help.)');
        errorBody.put('code', 40400);
        errorBody.put('statusCode', 404);
        errorBody.put('nonfatal', false);
        errorBody.put('href', 'https://help.ably.io/error/40400');
        errorBody.put('serverId', 'frontend.dc5d.5.us-east-2-A.i-0f1ee2d7bed5f5c61.86f7T8R7wBQchz');
        resBody.put('error', errorBody);

        return JSON.serialize(resBody);
    }
    
    private String getResponseBody(String channelName) {
        Map<String,Object> resBody = new Map<String,Object>();
        resBody.put('messageId', 'avt6ieY_T7:0');
        resBody.put('channel', channelName);

        return JSON.serialize(resBody);
    }
}