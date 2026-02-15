import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['counter'];
  static values = {
    maxCount: Number
  };

  connect() {
    if (this.hasCounterTarget) {
      const input = this.element.querySelector('input');
      if (input) {
        this.updateCounter(input);
        input.addEventListener('input', (e) => this.updateCounter(e.target));
      }
    }
  }

  updateCounter(input) {
    const currentLength = input.value.length;
    this.counterTarget.textContent = `${currentLength} / ${this.maxCountValue}`;
  }
}
