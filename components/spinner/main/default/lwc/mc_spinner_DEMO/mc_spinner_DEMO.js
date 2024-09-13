import { LightningElement } from 'lwc';

export default class Mc_spinner_DEMO extends LightningElement {

    cancellableText = "Doing something fancy...";

    handleCancel(e) {
        this.cancellableText = "Why did you cancel the fanciness?? :(";
    }
}