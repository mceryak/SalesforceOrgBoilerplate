import { LightningElement } from 'lwc';

export default class Mc_modal_DEMO extends LightningElement {

    showModal = false;

    curScreenIdx = 0;
    counter = 0

    get counterText() { return `Count: ${this.counter}`; }

    modalProps = [
        { headerText: 'Page 1', rightButtonLabel: 'Next', leftButtonLabel: 'Cancel', maxHeight: '500px' }, // page 1
        { headerText: 'Page 2', rightButtonLabel: 'Done', leftButtonLabel: 'Back', maxHeight: '500px' } // page 2
    ];

    handleClick(e) {
        this.showModal = !this.showModal;
    }

    incrementCounter(e) {
        this.counter++;
    }

    handleNext(e) {
        if (this.curScreenIdx === 1) {
            this.showModal = false
        } else {
            this.curScreenIdx += 1;
        }
    }

    handleBack(e) {
        if (this.curScreenIdx === 0) {
            this.showModal = false;
        } else {
            this.curScreenIdx -= 1;
        }
    }

}