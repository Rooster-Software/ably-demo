import { LightningElement, wire } from 'lwc';
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled } from 'lightning/empApi';

export default class Subscriber extends LightningElement {
    ablyStreamingEndpoint = 'https://realtime.ably.io/sse';
    
    empApiSubscription = {}; // represents subscription to event stream
    subscribed = false; // indicates if subscriber is subscribed to a channel or not
    channel; // this is the channel the subscriber is subscribed to

    message; // this is the event message of the most recent event
    time; // this is the time of the most recent event

    connectedCallback() {
        this.subscribe();
        this.registerErrorListener();
    }

    // handles click of subscription button to subscribe to Ably channel
    // this method actually invokes the subscription to the Ably_Event__e platform event via the lightning-emp-api
    handleSubscribe(event) {
        console.log('subscribe button clicked');
        // validate channel input
        let inputField = this.template.querySelector('lightning-input');
        if (!inputField.checkValidity()) {
            inputField.reportValidity();
            console.log('invalid field');
        } else { // updated selected/subscribed to channel
            this.message = null;
            this.time = null;
            this.channel = this.template.querySelector('lightning-input').value;
            this.subscribed = true;
        }
    }

    // Handles unsubscribe from platform event bus
    handleUnsubscribe() {
        // Invoke unsubscribe method of empApi
        unsubscribe(this.empApiSubscription, response => {
            console.log('unsubscribe response: ', JSON.stringify(response));
            // Response is true for successful unsubscribe

            if (response) {
                // clear events on screen
                this.time = null;
                this.message = null;
            }
        });
    }

    //listener for empAPI errors
    registerErrorListener() {
        // Invoke onError empApi method
        onError(error => {
            console.log('Received error from server: ', JSON.stringify(error));
            // Error contains the server-side error
        });
    }

    // subscribe to specified ably channel
    subscribe() {
        // callback invoked whenever a new event message is received by listener
        const messageCallback = (response) => {
            console.log('New message received: ', JSON.stringify(response));
            
            let payload = response.data.payload;

            let ablyEventChannel = payload.Channel_Name__c;
            let ablyEventMessage = payload.Data__c;
            let ablyEventTime = payload.CreatedDate;

            // only respond to events where ablyEventChannel is the subscribed to channel
            if (this.channel == ablyEventChannel) {
                this.message = ablyEventMessage;
                this.time = ablyEventTime;
            }
        }

        // subscribe to event channel using subscribe method of empApi
        subscribe('/event/Ably_Event__e', -1, messageCallback).then(response => {
            // actions to take place after successful subscription to event channel
            console.log('Subscription request sent to: ', JSON.stringify(response.channel));
            this.empApiSubscription = response;
        }).catch(error => {
            // actions to take place if there is an error subscribing
            console.log('Subscription error');
            console.log(error);
        });
    }
}