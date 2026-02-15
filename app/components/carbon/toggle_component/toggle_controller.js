import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['button', 'switch', 'text'];

  static values = {
    labelA: { type: String, default: 'Off' },
    labelB: { type: String, default: 'On' }
  };

  toggle() {
    const button = this.buttonTarget;
    const isChecked = button.getAttribute('aria-checked') === 'true';
    const newChecked = !isChecked;

    button.setAttribute('aria-checked', newChecked.toString());

    if (this.hasSwitchTarget) {
      if (newChecked) {
        this.switchTarget.classList.add('cds--toggle__switch--checked');
      } else {
        this.switchTarget.classList.remove('cds--toggle__switch--checked');
      }
    }

    if (this.hasTextTarget) {
      this.textTarget.textContent = newChecked ? this.labelBValue : this.labelAValue;
    }
  }
}
