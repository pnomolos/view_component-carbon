import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  toggle(event) {
    const button = event.currentTarget;
    const item = this.element;
    const isExpanded = button.getAttribute('aria-expanded') === 'true';

    button.setAttribute('aria-expanded', !isExpanded);

    if (isExpanded) {
      item.classList.remove('cds--accordion__item--active');
    } else {
      item.classList.add('cds--accordion__item--active');
    }
  }
}
