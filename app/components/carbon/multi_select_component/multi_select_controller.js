import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['field', 'menu', 'item', 'label', 'input', 'clearButton'];
  static values = {
    titleText: { type: String, default: 'Choose items' },
    filterable: { type: Boolean, default: false },
  };

  connect() {
    this.isOpen = false;
    this.highlightedIndex = -1;
    this._handleOutsideClick = this.handleOutsideClick.bind(this);
    document.addEventListener('click', this._handleOutsideClick);
  }

  disconnect() {
    document.removeEventListener('click', this._handleOutsideClick);
  }

  toggle(event) {
    event.stopPropagation();
    if (this.isOpen) {
      this.close();
    } else {
      this.open();
    }
  }

  open() {
    if (this.isOpen) return;
    this.isOpen = true;
    this.fieldTarget.setAttribute('aria-expanded', 'true');
    this.menuTarget.classList.add('cds--list-box__menu--expanded');
    this.element.classList.add('cds--list-box--expanded');
    this.highlightedIndex = -1;

    if (this.filterableValue && this.hasInputTarget) {
      this.inputTarget.focus();
    }
  }

  close() {
    if (!this.isOpen) return;
    this.isOpen = false;
    this.fieldTarget.setAttribute('aria-expanded', 'false');
    this.menuTarget.classList.remove('cds--list-box__menu--expanded');
    this.element.classList.remove('cds--list-box--expanded');
    this.clearHighlight();

    if (this.filterableValue && this.hasInputTarget) {
      this.inputTarget.value = '';
      this.showAllItems();
    }
  }

  selectItem(event) {
    event.stopPropagation();
    const item = event.currentTarget;

    if (item.classList.contains('cds--list-box__menu-item--disabled')) return;

    const isSelected = item.getAttribute('aria-selected') === 'true';

    if (isSelected) {
      item.setAttribute('aria-selected', 'false');
      item.classList.remove('cds--list-box__menu-item--active');
    } else {
      item.setAttribute('aria-selected', 'true');
      item.classList.add('cds--list-box__menu-item--active');
    }

    this.updateLabel();
    this.dispatch('change', {
      detail: { selectedValues: this.selectedValues() },
    });
  }

  clearAll(event) {
    event.stopPropagation();
    this.itemTargets.forEach((item) => {
      item.setAttribute('aria-selected', 'false');
      item.classList.remove('cds--list-box__menu-item--active');
    });
    this.updateLabel();
    this.updateClearButton();
    this.dispatch('change', { detail: { selectedValues: [] } });
  }

  handleKeydown(event) {
    const visibleItems = this.visibleItems();

    switch (event.key) {
      case 'ArrowDown':
        event.preventDefault();
        if (!this.isOpen) {
          this.open();
        }
        this.highlightedIndex = Math.min(
          this.highlightedIndex + 1,
          visibleItems.length - 1
        );
        this.updateHighlight(visibleItems);
        break;

      case 'ArrowUp':
        event.preventDefault();
        if (!this.isOpen) {
          this.open();
        }
        this.highlightedIndex = Math.max(this.highlightedIndex - 1, 0);
        this.updateHighlight(visibleItems);
        break;

      case 'Enter':
      case ' ':
        if (this.isOpen && this.highlightedIndex >= 0) {
          event.preventDefault();
          const item = visibleItems[this.highlightedIndex];
          if (
            item &&
            !item.classList.contains('cds--list-box__menu-item--disabled')
          ) {
            item.click();
          }
        } else if (!this.isOpen && event.key === ' ') {
          event.preventDefault();
          this.open();
        }
        break;

      case 'Escape':
        event.preventDefault();
        this.close();
        break;

      case 'Home':
        if (this.isOpen) {
          event.preventDefault();
          this.highlightedIndex = 0;
          this.updateHighlight(visibleItems);
        }
        break;

      case 'End':
        if (this.isOpen) {
          event.preventDefault();
          this.highlightedIndex = visibleItems.length - 1;
          this.updateHighlight(visibleItems);
        }
        break;
    }
  }

  filter() {
    if (!this.hasInputTarget) return;

    const query = this.inputTarget.value.toLowerCase();
    this.itemTargets.forEach((item) => {
      const text = item.textContent.toLowerCase().trim();
      if (text.includes(query)) {
        item.style.display = '';
      } else {
        item.style.display = 'none';
      }
    });

    this.highlightedIndex = -1;
    if (!this.isOpen) {
      this.open();
    }
  }

  // Private helpers

  handleOutsideClick(event) {
    if (!this.element.contains(event.target) && this.isOpen) {
      this.close();
    }
  }

  visibleItems() {
    return this.itemTargets.filter((item) => item.style.display !== 'none');
  }

  updateLabel() {
    const count = this.selectedCount();

    if (this.hasLabelTarget) {
      if (count === 0) {
        this.labelTarget.textContent = this.titleTextValue;
      } else {
        this.labelTarget.textContent = `${count} ${count === 1 ? 'item' : 'items'} selected`;
      }
    }

    this.updateClearButton();
  }

  updateClearButton() {
    if (this.hasClearButtonTarget) {
      const count = this.selectedCount();
      if (count === 0) {
        this.clearButtonTarget.style.display = 'none';
      } else {
        this.clearButtonTarget.style.display = '';
        const tagLabel = this.clearButtonTarget.querySelector('.cds--tag__label');
        if (tagLabel) {
          tagLabel.textContent = count;
        }
      }
    }
  }

  selectedCount() {
    return this.itemTargets.filter(
      (item) => item.getAttribute('aria-selected') === 'true'
    ).length;
  }

  selectedValues() {
    return this.itemTargets
      .filter((item) => item.getAttribute('aria-selected') === 'true')
      .map((item) => item.dataset.value);
  }

  updateHighlight(visibleItems) {
    this.clearHighlight();
    if (this.highlightedIndex >= 0 && visibleItems[this.highlightedIndex]) {
      visibleItems[this.highlightedIndex].classList.add(
        'cds--list-box__menu-item--highlighted'
      );
      visibleItems[this.highlightedIndex].scrollIntoView({ block: 'nearest' });
    }
  }

  clearHighlight() {
    this.itemTargets.forEach((item) => {
      item.classList.remove('cds--list-box__menu-item--highlighted');
    });
  }

  showAllItems() {
    this.itemTargets.forEach((item) => {
      item.style.display = '';
    });
  }
}
