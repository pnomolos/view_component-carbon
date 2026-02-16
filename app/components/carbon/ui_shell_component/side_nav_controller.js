import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static values = {
    expanded: { type: Boolean, default: false },
    rail: { type: Boolean, default: false },
  };

  connect() {
    if (this.railValue) {
      this.element.addEventListener('mouseenter', this.expand.bind(this));
      this.element.addEventListener('mouseleave', this.collapse.bind(this));
    }
  }

  expand() {
    this.element.classList.add('cds--side-nav--expanded');
    this.expandedValue = true;
  }

  collapse() {
    this.element.classList.remove('cds--side-nav--expanded');
    this.expandedValue = false;
  }
}
