import { LightningElement, api } from 'lwc';

export default class Mc_Spinner extends LightningElement {
    @api size = 'medium'; // small, medium, large
    @api variant = 'base'; // base, brand, inverse
    @api displayText;
    @api showCancelButton = false;

    handleCancel(e) {
        this.dispatchEvent(new CustomEvent('cancel'));
    }
    
}