import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['chevron', 'belowFold'];

  static values = {
    expanded: { type: Boolean, default: false },
    collapsedText: { type: String, default: 'Interact to expand tile' },
    expandedText: { type: String, default: 'Interact to collapse tile' }
  };

  toggle() {
    this.expandedValue = !this.expandedValue;

    if (this.expandedValue) {
      this.element.classList.add('cds--tile--is-expanded');
    } else {
      this.element.classList.remove('cds--tile--is-expanded');
    }

    if (this.hasChevronTarget) {
      this.chevronTarget.setAttribute('aria-expanded', this.expandedValue.toString());
      this.chevronTarget.setAttribute(
        'aria-label',
        this.expandedValue ? this.expandedTextValue : this.collapsedTextValue
      );
    }
  }
}
