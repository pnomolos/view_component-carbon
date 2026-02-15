import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['counter'];
  static values = {
    maxCount: Number
  };

  connect() {
    if (this.hasCounterTarget) {
      const textarea = this.element.querySelector('textarea');
      if (textarea) {
        this.updateCounter(textarea);
        textarea.addEventListener('input', (e) => this.updateCounter(e.target));
      }
    }
  }

  updateCounter(textarea) {
    const currentLength = textarea.value.length;
    this.counterTarget.textContent = `${currentLength} / ${this.maxCountValue}`;
  }
}
