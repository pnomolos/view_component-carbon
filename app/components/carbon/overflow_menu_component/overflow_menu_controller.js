import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['menu'];

  connect() {
    this.handleDocumentClick = this.closeOnOutsideClick.bind(this);
    document.addEventListener('click', this.handleDocumentClick);
  }

  disconnect() {
    document.removeEventListener('click', this.handleDocumentClick);
  }

  toggle(event) {
    event.stopPropagation();
    const trigger = this.element.querySelector('.cds--overflow-menu__trigger');
    const isOpen = trigger.getAttribute('aria-expanded') === 'true';

    if (isOpen) {
      this.close();
    } else {
      this.open();
    }
  }

  open() {
    const trigger = this.element.querySelector('.cds--overflow-menu__trigger');
    trigger.setAttribute('aria-expanded', 'true');
    this.element.classList.add('cds--overflow-menu--open');
    this.menuTarget.classList.add('cds--overflow-menu-options--open');

    const firstItem = this.focusableItems()[0];
    if (firstItem) {
      firstItem.focus();
    }
  }

  close() {
    const trigger = this.element.querySelector('.cds--overflow-menu__trigger');
    trigger.setAttribute('aria-expanded', 'false');
    this.element.classList.remove('cds--overflow-menu--open');
    this.menuTarget.classList.remove('cds--overflow-menu-options--open');
  }

  closeOnOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.close();
    }
  }

  triggerKeydown(event) {
    switch (event.key) {
      case 'ArrowDown':
      case 'Enter':
      case ' ': {
        event.preventDefault();
        this.open();
        break;
      }
      case 'Escape': {
        event.preventDefault();
        this.close();
        break;
      }
    }
  }

  menuKeydown(event) {
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
      case 'Escape': {
        event.preventDefault();
        this.close();
        this.element.querySelector('.cds--overflow-menu__trigger')?.focus();
        break;
      }
      case 'Enter':
      case ' ': {
        event.preventDefault();
        if (document.activeElement) {
          document.activeElement.click();
        }
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
    }
  }

  focusableItems() {
    return Array.from(
      this.menuTarget.querySelectorAll('[role="menuitem"]:not([disabled])')
    );
  }
}
