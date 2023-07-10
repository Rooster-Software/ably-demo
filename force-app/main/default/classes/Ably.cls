/**
 * @name Ably
 * @description class for interacting with Ably REST API
 */
public class Ably {

    private static final String PUBLISH_ENDPOINT = 'https://rest.ably.io';
    private static final String ABLY_API_KEY = Ably_Key__mdt.getInstance('Master').Key__c;

    /**
     * @name publishMessage
     * @param String channel
     * @param String message
     * @description publishes a message to a specified channel on Ably
     */
    @AuraEnabled
    public static string publishMessage(String channel, String message){
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(PUBLISH_ENDPOINT + '/channels/' + channel + '/messages'); // original test channel: sfdc-channel-1

            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Accept', 'application/json'); // indicate that the response body should be in applicatin/json format
            request.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(ABLY_API_KEY)));
            
            Map<String,Object> payload = new Map<String,Object>();
            payload.put('data', message);
            String jsonBody = JSON.serialize(payload);
            request.setBody(jsonBody);

            HttpResponse response = http.send(request);

            System.debug('Ably response...........');
            System.debug(response.getStatus());
            System.debug(response.getBody()); // the body is HTML and needs to be parsed

            String messageId;
            
            if (response.getStatus() != 'Created') { // handle unsuccessful response
                messageId = 'error';
            } else {
                Map<String,Object> responseMap = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
                messageId = String.valueOf(responseMap.get('messageId'));
            }

            System.debug('messageId: ' + messageId);
            return messageId;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}