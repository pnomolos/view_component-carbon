import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['container'];
  static values = {
    open: { type: Boolean, default: false },
    preventCloseOnClickOutside: { type: Boolean, default: false },
    preventClose: { type: Boolean, default: false },
    shouldSubmitOnEnter: { type: Boolean, default: false },
    loadingStatus: { type: String, default: 'inactive' },
    loadingDescription: { type: String, default: '' },
    loadingIconDescription: { type: String, default: 'Loading' },
    loadingSuccessDelay: { type: Number, default: 1500 },
  };

  connect() {
    this.previousActiveElement = null;
    this.boundHandleKeydown = this.handleKeydown.bind(this);

    if (this.openValue) {
      this.open();
    }
  }

  disconnect() {
    this.removeEventListeners();
    this.unlockScroll();
  }

  openValueChanged() {
    if (this.openValue) {
      this.showModal();
    } else {
      this.hideModal();
    }
  }

  open() {
    this.openValue = true;
  }

  close() {
    // Dispatch beingclosed event (can be cancelled)
    const beingClosedEvent = this.dispatch('beingclosed', { cancelable: true });
    if (beingClosedEvent.defaultPrevented) {
      return;
    }

    this.openValue = false;
  }

  toggle() {
    this.openValue = !this.openValue;
  }

  // Private

  showModal() {
    this.previousActiveElement = document.activeElement;
    this.element.classList.add('cds--modal--open');
    this.lockScroll();
    this.addEventListeners();

    // Focus the first focusable element in the modal after rendering
    requestAnimationFrame(() => {
      const focusable = this.getFocusableElements();
      if (focusable.length > 0) {
        focusable[0].focus();
      }
    });

    this.dispatch('opened');
  }

  hideModal() {
    this.element.classList.remove('cds--modal--open');
    this.unlockScroll();
    this.removeEventListeners();

    // Restore focus to the element that triggered the modal
    if (this.previousActiveElement) {
      this.previousActiveElement.focus();
      this.previousActiveElement = null;
    }

    this.dispatch('closed');
  }

  handleKeydown(event) {
    if (event.key === 'Escape') {
      if (!this.preventCloseValue) {
        event.preventDefault();
        this.close();
      }
      return;
    }

    if (event.key === 'Tab') {
      this.trapFocus(event);
      return;
    }

    if (event.key === 'Enter' && this.shouldSubmitOnEnterValue) {
      this.handleEnterKey(event);
    }
  }

  handleEnterKey(event) {
    // Find the primary button (look for data-modal-primary-focus or primary button)
    const primaryButton = this.element.querySelector(
      '[data-modal-primary-focus], .cds--btn--primary',
    );

    // Don't trigger if user is already focused on the primary button
    if (primaryButton && document.activeElement !== primaryButton) {
      event.preventDefault();
      primaryButton.click();
    }
  }

  handleBackdropClick(event) {
    if (this.preventCloseOnClickOutsideValue || this.preventCloseValue) {
      return;
    }

    // Only close if clicking directly on the modal overlay (not the container)
    if (this.hasContainerTarget && !this.containerTarget.contains(event.target)) {
      this.close();
    }
  }

  trapFocus(event) {
    const focusable = this.getFocusableElements();
    if (focusable.length === 0) return;

    const firstFocusable = focusable[0];
    const lastFocusable = focusable[focusable.length - 1];

    if (event.shiftKey) {
      // Shift+Tab: if focus is on the first element, wrap to last
      if (document.activeElement === firstFocusable) {
        event.preventDefault();
        lastFocusable.focus();
      }
    } else {
      // Tab: if focus is on the last element, wrap to first
      if (document.activeElement === lastFocusable) {
        event.preventDefault();
        firstFocusable.focus();
      }
    }
  }

  getFocusableElements() {
    if (!this.hasContainerTarget) return [];

    const selector = [
      'a[href]',
      'button:not([disabled])',
      'textarea:not([disabled])',
      'input:not([disabled]):not([type="hidden"])',
      'select:not([disabled])',
      '[tabindex]:not([tabindex="-1"])',
    ].join(', ');

    return Array.from(this.containerTarget.querySelectorAll(selector)).filter(
      (el) => !el.closest('[hidden]') && el.offsetParent !== null,
    );
  }

  lockScroll() {
    document.body.style.overflow = 'hidden';
  }

  unlockScroll() {
    document.body.style.overflow = '';
  }

  addEventListeners() {
    document.addEventListener('keydown', this.boundHandleKeydown);
    this.element.addEventListener('click', this.handleBackdropClick.bind(this));
  }

  removeEventListeners() {
    document.removeEventListener('keydown', this.boundHandleKeydown);
  }
}
