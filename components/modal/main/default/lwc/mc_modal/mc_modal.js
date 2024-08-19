import { LightningElement, api } from 'lwc';

export default class Mc_modal extends LightningElement {

    @api showModal = false;
    @api wider = false; // make the modal wider
    @api screenProps; // e.g. [{ headerText: '', rightButtonLabel: '', leftButtonLabel: '', maxHeight: '500px' }] (maxHeight populated will make y-axis scrollable)
    @api curScreenIdx = 0;
    @api disableButtons; // e.g. if the screen is loading
    @api disableRightButton;
    @api disableLeftButton;
    @api isLoading = false;
    @api error;
    @api showXIcon = false;

    renderedCallback() {
        if (this.curProp?.maxHeight) {
            this.template.querySelector('.body')?.style?.setProperty('--modalBodyMaxHeight', this.curProp.maxHeight);
        }
    }

    get modalContainerClass() { return `${this.wider ? 'wider' : ''} slds-modal__container`; }

    get rightButtonDisabled() { return this.disableButtons || this.disableRightButton; }
    get leftButtonDisabled() { return this.disableButtons || this.disableLeftButton; }

    get curProp() { return this.curScreenIdx ? this.screenProps[this.curScreenIdx] : this.screenProps[0]; }

    get rightButtonLabel() { return this.curProp.rightButtonLabel; }
    get leftButtonLabel() { return this.curProp.leftButtonLabel; }
    get headerText() { return this.curProp.headerText; }

    get showFooter() { return this.screenProps[this.curScreenIdx].rightButtonLabel || this.screenProps[this.curScreenIdx].rightButtonLabel; }

    get showScreen0() { return this.curScreenIdx === 0; }
    get showScreen1() { return this.curScreenIdx === 1; }
    get showScreen2() { return this.curScreenIdx === 2; }

    get bodyClass() { return this.curProp.maxHeight ? 'body' : '' };

    handleClick(e) {
        // possible events: onrightbuttonclick, onleftbuttonclick
        this.dispatchEvent(new CustomEvent(e.target.name + 'click'), { detail: { screenIdx: this.curScreenIdx }});
    }

    handleClose(e) {
        this.dispatchEvent(new CustomEvent('close'));
    }

}