import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    this.element.addEventListener('keydown', this.handleKeydown.bind(this));
  }

  disconnect() {
    this.element.removeEventListener('keydown', this.handleKeydown.bind(this));
  }

  handleKeydown(event) {
    const items = this.focusableItems();
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
      case 'Home': {
        event.preventDefault();
        items[0]?.focus();
        break;
      }
      case 'End': {
        event.preventDefault();
        items[items.length - 1]?.focus();
        break;
      }
      case 'Escape': {
        event.preventDefault();
        this.close();
        break;
      }
      case 'Enter':
      case ' ': {
        event.preventDefault();
        if (document.activeElement && !document.activeElement.getAttribute('aria-disabled')) {
          document.activeElement.click();
        }
        break;
      }
    }
  }

  close() {
    this.element.classList.remove('cds--menu--open');
    this.element.dispatchEvent(new CustomEvent('menu:close', { bubbles: true }));
  }

  focusableItems() {
    return Array.from(
      this.element.querySelectorAll('[role="menuitem"]:not([aria-disabled="true"])')
    );
  }
}
