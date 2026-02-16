import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['input', 'label'];

  toggle() {
    if (this.inputTarget.disabled) return;

    const input = this.inputTarget;
    const label = this.labelTarget;
    const isSelected = input.checked;

    input.checked = !isSelected;

    if (input.checked) {
      label.classList.add('cds--tile--is-selected');
    } else {
      label.classList.remove('cds--tile--is-selected');
    }

    label.setAttribute('aria-checked', input.checked.toString());
  }

  handleKeydown(event) {
    if (event.key === 'Enter' || event.key === ' ') {
      event.preventDefault();
      this.toggle();
    }
  }
}
