/**
 * @name AblyRestResource
 * @description class for receiving and reacting to outgoing webhook events from Ably
 */
@RestResource(urlMapping='/Ably/*')
global class AblyRestResource {
    
    /**
     * @name doPost
     * @description handle posting of webhook event from Ably indicating a new event being created
     */
    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        RestResponse response = RestContext.response;
        String requestBody = req.requestBody.toString();

        System.debug('Request body');
        System.debug(requestBody);

        try {
            // extract contents from body
            Map<String,Object> bodyMap = (Map<String,Object>) JSON.deserializeUntyped(requestBody);
            String channel = (String) bodyMap.get('channel');
            List<Object> messages = (List<Object>) bodyMap.get('messages');

            List<Ably_Event__e> ablyEvents = new List<Ably_Event__e>();
            // create platform event for each message on channel
            for (Object m : messages) {
                Map<String,Object> message = (Map<String,Object>) m;
                Ably_Event__e ablyEvent = new Ably_Event__e();
                ablyEvent.Channel_Name__c = channel;
                String data = (String) message.get('data');
                if (data.length() > 255) {
                    ablyEvent.Data__c = data.substring(0, 255);
                } else {
                    ablyEvent.Data__c = data;
                }
                ablyEvent.Message_Id__c = (String) message.get('id');
                ablyEvents.add(ablyEvent);
            }

            List<Database.SaveResult> results = Eventbus.publish(ablyEvents);

            // Inspect publishing result for each event
            for (Database.SaveResult sr : results) {
                if (sr.isSuccess()) {
                    System.debug('Successfully published event.');
                } else {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('Error returned: ' +
                                    err.getStatusCode() +
                                    ' - ' +
                                    err.getMessage());
                    }
                }       
            }

            response.statusCode = 201; // indicate successful creation of platform events
            response.responseBody = Blob.valueOf('success');

            //return 'success';
        } catch (Exception e) {
            // handle error scenario
            Map<String,String> errorResponse = new Map<String,String>();
            errorResponse.put('message', e.getMessage());
            String errorResponseJson = JSON.serialize(errorResponse);

            response.statusCode = 500;
            response.responseBody = Blob.valueOf(errorResponseJson);
            
            //return 'error';
        }
    }
}