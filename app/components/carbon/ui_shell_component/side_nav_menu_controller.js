import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['button', 'submenu'];

  toggle() {
    if (!this.hasButtonTarget) return;

    const isExpanded = this.buttonTarget.getAttribute('aria-expanded') === 'true';
    this.buttonTarget.setAttribute('aria-expanded', (!isExpanded).toString());

    if (this.hasSubmenuTarget) {
      if (isExpanded) {
        this.submenuTarget.setAttribute('hidden', '');
      } else {
        this.submenuTarget.removeAttribute('hidden');
      }
    }
  }
}
