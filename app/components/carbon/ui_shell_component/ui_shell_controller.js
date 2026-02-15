import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['hamburger', 'sideNav', 'overlay'];

  toggleSideNav() {
    if (!this.hasSideNavTarget) return;

    const isExpanded = this.sideNavTarget.classList.contains('cds--side-nav--expanded');

    if (isExpanded) {
      this.closeSideNav();
    } else {
      this.openSideNav();
    }
  }

  openSideNav() {
    if (!this.hasSideNavTarget) return;

    this.sideNavTarget.classList.add('cds--side-nav--expanded');

    if (this.hasHamburgerTarget) {
      this.hamburgerTarget.setAttribute('aria-expanded', 'true');
    }

    if (this.hasOverlayTarget) {
      this.overlayTarget.classList.add('cds--side-nav__overlay-active');
    }
  }

  closeSideNav() {
    if (!this.hasSideNavTarget) return;

    this.sideNavTarget.classList.remove('cds--side-nav--expanded');

    if (this.hasHamburgerTarget) {
      this.hamburgerTarget.setAttribute('aria-expanded', 'false');
    }

    if (this.hasOverlayTarget) {
      this.overlayTarget.classList.remove('cds--side-nav__overlay-active');
    }
  }

  togglePanel(event) {
    const button = event.currentTarget;
    const panelId = button.getAttribute('aria-controls');
    if (!panelId) return;

    const panel = document.getElementById(panelId);
    if (!panel) return;

    const isExpanded = panel.classList.contains('cds--header-panel--expanded');

    // Close all panels first
    this.element.querySelectorAll('.cds--header-panel').forEach((p) => {
      p.classList.remove('cds--header-panel--expanded');
    });

    // Reset all global action buttons
    this.element.querySelectorAll('.cds--header__action').forEach((btn) => {
      btn.setAttribute('aria-expanded', 'false');
      btn.classList.remove('cds--header__action--active');
    });

    if (!isExpanded) {
      panel.classList.add('cds--header-panel--expanded');
      button.setAttribute('aria-expanded', 'true');
      button.classList.add('cds--header__action--active');
    }
  }
}
