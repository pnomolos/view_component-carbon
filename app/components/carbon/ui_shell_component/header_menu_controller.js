import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['trigger', 'menu'];

  connect() {
    this.boundHandleOutsideClick = this.handleOutsideClick.bind(this);
    document.addEventListener('click', this.boundHandleOutsideClick);
  }

  disconnect() {
    document.removeEventListener('click', this.boundHandleOutsideClick);
  }

  toggle(event) {
    event.stopPropagation();
    const isExpanded = this.triggerTarget.getAttribute('aria-expanded') === 'true';

    if (isExpanded) {
      this.close();
    } else {
      this.open();
    }
  }

  open() {
    this.triggerTarget.setAttribute('aria-expanded', 'true');
    this.element.classList.add('cds--header__submenu--open');

    const firstItem = this.menuTarget.querySelector('[role="menuitem"]');
    if (firstItem) {
      requestAnimationFrame(() => firstItem.focus());
    }
  }

  close() {
    this.triggerTarget.setAttribute('aria-expanded', 'false');
    this.element.classList.remove('cds--header__submenu--open');
  }

  handleKeydown(event) {
    const items = Array.from(
      this.menuTarget.querySelectorAll('[role="menuitem"]'),
    );
    const currentIndex = items.indexOf(document.activeElement);

    switch (event.key) {
      case 'ArrowDown': {
        event.preventDefault();
        const nextIndex = currentIndex < items.length - 1 ? currentIndex + 1 : 0;
        items[nextIndex]?.focus();
        break;
      }
      case 'ArrowUp': {
        event.preventDefault();
        const prevIndex = currentIndex > 0 ? currentIndex - 1 : items.length - 1;
        items[prevIndex]?.focus();
        break;
      }
      case 'Escape': {
        event.preventDefault();
        this.close();
        this.triggerTarget.focus();
        break;
      }
      case 'Enter': {
        if (document.activeElement && document.activeElement !== this.triggerTarget) {
          document.activeElement.click();
        }
        break;
      }
    }
  }

  handleOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.close();
    }
  }
}
