import { LightningElement } from 'lwc';
import publishMessage from '@salesforce/apex/Ably.publishMessage';

export default class Publisher extends LightningElement {
    
    channel;
    message;

    // component initialization
    connectedCallback() {
        // create channel
    }

    handleChannelChange(event) {
        this.channel = event.target.value;
    }

    // handle button click to publish event to Ably
    handleClick(event) {
        // validate inputs
        let isValid = true;
        let inputFields = this.template.querySelectorAll('.validate');
        inputFields.forEach(inputField => {
            if (!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
            }
        });

        if (isValid) { // publish message
            this.publish(this.channel, this.message);
        }
    }

    handleMessageChange(event) {
        this.message = event.target.value;
    }

    // send message to Ably for publication on specified channel
    publish(channel, message) {
        publishMessage({ channel : channel, message : message }).then(response => {
            var messageId = response;

            if (messageId != 'error') {
                console.log('messageId:', messageId);
            } else { // handle error response
                console.log('publish error... check logs');
            }
        }).catch(error => {
            console.log('publish error...');
            console.log(error);
        });
    }
}