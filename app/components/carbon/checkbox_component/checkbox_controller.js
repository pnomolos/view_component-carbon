import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static values = {
    indeterminate: Boolean
  };

  connect() {
    if (this.indeterminateValue) {
      const checkbox = this.element.querySelector('input[type="checkbox"]');
      if (checkbox) {
        checkbox.indeterminate = true;
      }
    }
  }
}
