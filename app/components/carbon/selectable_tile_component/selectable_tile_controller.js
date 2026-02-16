import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static values = {
    selected: Boolean,
    name: String,
    value: String
  };

  toggle() {
    // Check if disabled by looking at the element's disabled state
    if (this.element.hasAttribute('disabled')) return;

    // Toggle the selected state
    this.selectedValue = !this.selectedValue;

    // Update CSS classes
    if (this.selectedValue) {
      this.element.classList.add('cds--tile--is-selected');
    } else {
      this.element.classList.remove('cds--tile--is-selected');
    }

    // Update aria-checked
    this.element.setAttribute('aria-checked', this.selectedValue.toString());

    // Dispatch custom event
    const event = new CustomEvent('cds-selectable-tile-changed', {
      bubbles: true,
      composed: true,
      detail: {
        selected: this.selectedValue,
        name: this.nameValue,
        value: this.valueValue
      }
    });
    this.element.dispatchEvent(event);

    // Dispatch a native change event for form compatibility
    // Create a synthetic checkbox change event
    const changeEvent = new Event('change', {
      bubbles: true,
      cancelable: true
    });
    this.element.dispatchEvent(changeEvent);
  }

  handleKeydown(event) {
    if (event.key === 'Enter' || event.key === ' ') {
      event.preventDefault();
      this.toggle();
    }
  }
}
