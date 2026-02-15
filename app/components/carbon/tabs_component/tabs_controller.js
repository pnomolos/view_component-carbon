import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['tab', 'panel'];

  connect() {
    this.element.addEventListener('keydown', this.handleKeydown.bind(this));
  }

  select(event) {
    const selectedTab = event.currentTarget;
    const panelId = selectedTab.dataset.panelId;

    // Deactivate all tabs
    this.tabTargets.forEach((tab) => {
      tab.setAttribute('aria-selected', 'false');
      tab.setAttribute('tabindex', '-1');
    });

    // Hide all panels
    this.panelTargets.forEach((panel) => {
      panel.setAttribute('hidden', '');
    });

    // Activate selected tab
    selectedTab.setAttribute('aria-selected', 'true');
    selectedTab.setAttribute('tabindex', '0');

    // Show corresponding panel
    const selectedPanel = this.panelTargets.find(
      (panel) => panel.dataset.panelId === panelId
    );
    if (selectedPanel) {
      selectedPanel.removeAttribute('hidden');
    }
  }

  handleKeydown(event) {
    const currentTab = event.target;
    if (!currentTab.matches('[role="tab"]')) return;

    const tabs = this.tabTargets.filter(tab => !tab.disabled);
    const currentIndex = tabs.indexOf(currentTab);

    let nextIndex = currentIndex;

    switch (event.key) {
      case 'ArrowLeft':
        event.preventDefault();
        nextIndex = currentIndex - 1;
        if (nextIndex < 0) nextIndex = tabs.length - 1;
        break;
      case 'ArrowRight':
        event.preventDefault();
        nextIndex = currentIndex + 1;
        if (nextIndex >= tabs.length) nextIndex = 0;
        break;
      case 'Home':
        event.preventDefault();
        nextIndex = 0;
        break;
      case 'End':
        event.preventDefault();
        nextIndex = tabs.length - 1;
        break;
      default:
        return;
    }

    if (nextIndex !== currentIndex) {
      tabs[nextIndex].focus();
      tabs[nextIndex].click();
    }
  }
}
