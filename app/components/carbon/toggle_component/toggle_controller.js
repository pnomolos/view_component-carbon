import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['input'];

  change(event) {
    const input = event.currentTarget;
    const isChecked = input.checked;
    input.setAttribute('aria-checked', isChecked);
  }
}
