import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['tab', 'panel', 'previousButton', 'nextButton', 'scrollContainer', 'leftSentinel', 'rightSentinel', 'assistiveText', 'tablist'];
  static values = {
    activation: { type: String, default: 'automatic' },
    scrollIntoView: { type: Boolean, default: true }
  };

  connect() {
    this.element.addEventListener('keydown', this.handleKeydown.bind(this));

    if (this.hasScrollContainerTarget) {
      this.setupScrollObserver();
      this.updateScrollButtons();
    }

    if (this.scrollIntoViewValue) {
      this.scrollToSelectedTab();
    }
  }

  disconnect() {
    if (this.resizeObserver) {
      this.resizeObserver.disconnect();
    }
    if (this.leftIntersectionObserver) {
      this.leftIntersectionObserver.disconnect();
    }
    if (this.rightIntersectionObserver) {
      this.rightIntersectionObserver.disconnect();
    }
  }

  select(event) {
    const selectedTab = event.currentTarget;
    this.selectTab(selectedTab);
    this.announceSelection();
  }

  selectTab(selectedTab) {
    const panelId = selectedTab.getAttribute('aria-controls');

    // Deactivate all tabs
    this.tabTargets.forEach((tab) => {
      tab.setAttribute('aria-selected', 'false');
      tab.setAttribute('tabindex', '-1');
      tab.classList.remove('cds--tabs__nav-item--selected');
    });

    // Hide all panels
    this.panelTargets.forEach((panel) => {
      panel.setAttribute('hidden', '');
    });

    // Activate selected tab
    selectedTab.setAttribute('aria-selected', 'true');
    selectedTab.setAttribute('tabindex', '0');
    selectedTab.classList.add('cds--tabs__nav-item--selected');

    // Show corresponding panel
    const selectedPanel = this.panelTargets.find(
      (panel) => panel.id === panelId
    );
    if (selectedPanel) {
      selectedPanel.removeAttribute('hidden');
    }

    if (this.scrollIntoViewValue) {
      selectedTab.scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'center' });
    }
  }

  close(event) {
    event.stopPropagation();
    const tabId = event.params.tabId;
    const tab = this.tabTargets.find(t => t.id === tabId);

    if (!tab) return;

    const panelId = tab.getAttribute('aria-controls');
    const panel = this.panelTargets.find(p => p.id === panelId);

    // Find next tab to select
    const tabs = this.tabTargets.filter(t => !t.disabled);
    const currentIndex = tabs.indexOf(tab);
    let nextTab = tabs[currentIndex + 1] || tabs[currentIndex - 1];

    // Remove tab and panel
    tab.remove();
    if (panel) panel.remove();

    // Select next tab if current was selected
    if (tab.getAttribute('aria-selected') === 'true' && nextTab) {
      this.selectTab(nextTab);
    }

    this.updateScrollButtons();
  }

  handleKeydown(event) {
    const currentTab = event.target;
    if (!currentTab.matches('[role="tab"]')) return;

    const tabs = this.tabTargets.filter(tab => !tab.disabled);
    const currentIndex = tabs.indexOf(currentTab);

    let nextIndex = currentIndex;
    let shouldNavigate = false;

    switch (event.key) {
      case 'ArrowLeft':
        event.preventDefault();
        nextIndex = currentIndex - 1;
        if (nextIndex < 0) nextIndex = tabs.length - 1;
        shouldNavigate = true;
        break;
      case 'ArrowRight':
        event.preventDefault();
        nextIndex = currentIndex + 1;
        if (nextIndex >= tabs.length) nextIndex = 0;
        shouldNavigate = true;
        break;
      case 'Home':
        event.preventDefault();
        nextIndex = 0;
        shouldNavigate = true;
        break;
      case 'End':
        event.preventDefault();
        nextIndex = tabs.length - 1;
        shouldNavigate = true;
        break;
      case 'Enter':
      case ' ':
        if (this.activationValue === 'manual') {
          event.preventDefault();
          this.selectTab(currentTab);
          this.announceSelection();
        }
        return;
      default:
        return;
    }

    if (shouldNavigate && nextIndex !== currentIndex) {
      const nextTab = tabs[nextIndex];
      nextTab.focus();

      if (this.activationValue === 'automatic') {
        this.selectTab(nextTab);
        this.announceSelection();
      } else {
        this.announceNavigating();
      }
    }
  }

  scrollPrevious() {
    if (this.hasScrollContainerTarget) {
      this.scrollContainerTarget.scrollBy({ left: -200, behavior: 'smooth' });
    }
  }

  scrollNext() {
    if (this.hasScrollContainerTarget) {
      this.scrollContainerTarget.scrollBy({ left: 200, behavior: 'smooth' });
    }
  }

  setupScrollObserver() {
    // Watch for size changes to show/hide scroll buttons
    this.resizeObserver = new ResizeObserver(() => {
      this.updateScrollButtons();
    });
    this.resizeObserver.observe(this.tablistTarget);

    // Watch left sentinel to show/hide previous button
    if (this.hasLeftSentinelTarget) {
      this.leftIntersectionObserver = new IntersectionObserver(
        (entries) => {
          entries.forEach((entry) => {
            if (this.hasPreviousButtonTarget) {
              if (entry.isIntersecting) {
                this.previousButtonTarget.classList.add('cds--tab--overflow-nav-button--hidden');
              } else {
                this.previousButtonTarget.classList.remove('cds--tab--overflow-nav-button--hidden');
              }
            }
          });
        },
        { root: this.scrollContainerTarget, threshold: 1.0 }
      );
      this.leftIntersectionObserver.observe(this.leftSentinelTarget);
    }

    // Watch right sentinel to show/hide next button
    if (this.hasRightSentinelTarget) {
      this.rightIntersectionObserver = new IntersectionObserver(
        (entries) => {
          entries.forEach((entry) => {
            if (this.hasNextButtonTarget) {
              if (entry.isIntersecting) {
                this.nextButtonTarget.classList.add('cds--tab--overflow-nav-button--hidden');
              } else {
                this.nextButtonTarget.classList.remove('cds--tab--overflow-nav-button--hidden');
              }
            }
          });
        },
        { root: this.scrollContainerTarget, threshold: 1.0 }
      );
      this.rightIntersectionObserver.observe(this.rightSentinelTarget);
    }

    // Listen to scroll events
    this.scrollContainerTarget.addEventListener('scroll', () => {
      this.updateScrollButtons();
    });
  }

  updateScrollButtons() {
    if (!this.hasScrollContainerTarget || !this.hasTablistTarget) return;

    const container = this.scrollContainerTarget;
    const tablist = this.tablistTarget;

    // Check if scrolling is needed
    const needsScroll = tablist.scrollWidth > container.clientWidth;

    if (!needsScroll) {
      if (this.hasPreviousButtonTarget) {
        this.previousButtonTarget.classList.add('cds--tab--overflow-nav-button--hidden');
      }
      if (this.hasNextButtonTarget) {
        this.nextButtonTarget.classList.add('cds--tab--overflow-nav-button--hidden');
      }
    }
  }

  scrollToSelectedTab() {
    const selectedTab = this.tabTargets.find(tab => tab.getAttribute('aria-selected') === 'true');
    if (selectedTab) {
      selectedTab.scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'center' });
    }
  }

  announceNavigating() {
    if (this.hasAssistiveTextTarget) {
      // Get text from data attribute or use default
      const text = this.element.dataset.selectingItemsText ||
                   'Selecting items. Use left and right arrow keys to navigate.';
      this.assistiveTextTarget.textContent = text;
    }
  }

  announceSelection() {
    if (this.hasAssistiveTextTarget) {
      // Get text from data attribute or use default
      const text = this.element.dataset.selectedItemText ||
                   'Selected an item.';
      this.assistiveTextTarget.textContent = text;

      // Clear after announcement
      setTimeout(() => {
        this.assistiveTextTarget.textContent = '';
      }, 1000);
    }
  }
}
