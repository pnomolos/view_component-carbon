import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['input'];

  increment() {
    const input = this.inputTarget;
    const currentValue = parseFloat(input.value) || 0;
    const step = parseFloat(input.step) || 1;
    const max = input.max ? parseFloat(input.max) : Infinity;

    const newValue = currentValue + step;
    if (newValue <= max) {
      input.value = newValue;
      input.dispatchEvent(new Event('input', { bubbles: true }));
      input.dispatchEvent(new Event('change', { bubbles: true }));
    }
  }

  decrement() {
    const input = this.inputTarget;
    const currentValue = parseFloat(input.value) || 0;
    const step = parseFloat(input.step) || 1;
    const min = input.min ? parseFloat(input.min) : -Infinity;

    const newValue = currentValue - step;
    if (newValue >= min) {
      input.value = newValue;
      input.dispatchEvent(new Event('input', { bubbles: true }));
      input.dispatchEvent(new Event('change', { bubbles: true }));
    }
  }
}
