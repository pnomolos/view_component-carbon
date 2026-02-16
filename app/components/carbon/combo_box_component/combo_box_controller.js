import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['field', 'menu', 'item', 'input', 'clearButton'];
  static values = {
    typeahead: Boolean,
    allowCustomValue: Boolean,
    shouldFilterItem: Boolean,
  };

  connect() {
    this.isOpen = false;
    this.highlightedIndex = -1;
    this.selectedValue = null;
    this._handleOutsideClick = this.handleOutsideClick.bind(this);
    document.addEventListener('click', this._handleOutsideClick);
    this.updateInputEmptyClass();
  }

  disconnect() {
    document.removeEventListener('click', this._handleOutsideClick);
  }

  toggle(event) {
    if (event.target.closest('[data-carbon--combo-box-target="clearButton"]')) {
      return;
    }
    if (
      event.target.closest(
        '.cds--list-box__menu-icon'
      )
    ) {
      return;
    }
    if (!this.isOpen) {
      this.open();
    }
    this.inputTarget.focus();
  }

  toggleMenu(event) {
    event.stopPropagation();
    if (this.isOpen) {
      this.close();
    } else {
      this.open();
      this.inputTarget.focus();
    }
  }

  open() {
    if (this.isOpen) return;
    this.isOpen = true;
    this.fieldTarget.setAttribute('aria-expanded', 'true');
    this.inputTarget.setAttribute('aria-expanded', 'true');
    this.menuTarget.classList.add('cds--list-box__menu--expanded');
    this.element.classList.add('cds--list-box--expanded');
    this.highlightedIndex = -1;
    this.updateAriaActivedescendant();
  }

  close() {
    if (!this.isOpen) return;
    this.isOpen = false;
    this.fieldTarget.setAttribute('aria-expanded', 'false');
    this.inputTarget.setAttribute('aria-expanded', 'false');
    this.menuTarget.classList.remove('cds--list-box__menu--expanded');
    this.element.classList.remove('cds--list-box--expanded');
    this.clearHighlight();
    this.updateAriaActivedescendant();

    if (this.selectedValue && !this.allowCustomValueValue) {
      const selectedItem = this.itemTargets.find(
        (item) => item.dataset.value === this.selectedValue
      );
      if (selectedItem) {
        this.inputTarget.value = selectedItem.dataset.text;
      }
    }

    this.showAllItems();
  }

  selectItem(event) {
    event.stopPropagation();
    const item = event.currentTarget;

    if (item.classList.contains('cds--list-box__menu-item--disabled')) return;

    // Deselect previous
    this.itemTargets.forEach((i) => {
      i.setAttribute('aria-selected', 'false');
      i.classList.remove('cds--list-box__menu-item--active');
    });

    // Select new
    item.setAttribute('aria-selected', 'true');
    item.classList.add('cds--list-box__menu-item--active');
    this.selectedValue = item.dataset.value;

    this.inputTarget.value = item.dataset.text;
    this.updateInputEmptyClass();
    this.showClearButton();
    this.close();

    this.dispatch('change', {
      detail: { value: this.selectedValue, text: item.dataset.text },
    });
  }

  clear(event) {
    event.stopPropagation();
    this.itemTargets.forEach((item) => {
      item.setAttribute('aria-selected', 'false');
      item.classList.remove('cds--list-box__menu-item--active');
    });
    this.selectedValue = null;
    this.inputTarget.value = '';
    this.updateInputEmptyClass();
    this.hideClearButton();
    this.showAllItems();
    this.inputTarget.focus();

    this.dispatch('change', { detail: { value: null, text: null } });
  }

  filter() {
    const query = this.inputTarget.value.toLowerCase();

    // Update empty class
    this.updateInputEmptyClass();

    // Only filter if should_filter_item is true
    if (this.shouldFilterItemValue) {
      this.itemTargets.forEach((item) => {
        const text = (item.dataset.text || item.textContent).toLowerCase().trim();
        if (text.includes(query)) {
          item.style.display = '';
        } else {
          item.style.display = 'none';
        }
      });
    }

    this.highlightedIndex = -1;
    this.updateAriaActivedescendant();

    if (!this.isOpen) {
      this.open();
    }

    if (query.length > 0) {
      this.showClearButton();
    } else if (!this.selectedValue) {
      this.hideClearButton();
    }
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
        if (this.isOpen && this.highlightedIndex >= 0) {
          event.preventDefault();
          const item = visibleItems[this.highlightedIndex];
          if (
            item &&
            !item.classList.contains('cds--list-box__menu-item--disabled')
          ) {
            item.click();
          }
        }
        break;

      case 'Escape':
        event.preventDefault();
        if (this.isOpen) {
          this.close();
        } else {
          this.clear(event);
        }
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

  // Private helpers

  handleOutsideClick(event) {
    if (!this.element.contains(event.target) && this.isOpen) {
      this.close();
    }
  }

  visibleItems() {
    return this.itemTargets.filter((item) => item.style.display !== 'none');
  }

  updateHighlight(visibleItems) {
    this.clearHighlight();
    if (this.highlightedIndex >= 0 && visibleItems[this.highlightedIndex]) {
      visibleItems[this.highlightedIndex].classList.add(
        'cds--list-box__menu-item--highlighted'
      );
      visibleItems[this.highlightedIndex].scrollIntoView({ block: 'nearest' });
    }
    this.updateAriaActivedescendant();
  }

  clearHighlight() {
    this.itemTargets.forEach((item) => {
      item.classList.remove('cds--list-box__menu-item--highlighted');
    });
    this.updateAriaActivedescendant();
  }

  showAllItems() {
    this.itemTargets.forEach((item) => {
      item.style.display = '';
    });
  }

  showClearButton() {
    if (this.hasClearButtonTarget) {
      this.clearButtonTarget.style.display = '';
    }
  }

  hideClearButton() {
    if (this.hasClearButtonTarget) {
      this.clearButtonTarget.style.display = 'none';
    }
  }

  updateInputEmptyClass() {
    if (this.inputTarget.value.length === 0) {
      this.inputTarget.classList.add('cds--text-input--empty');
    } else {
      this.inputTarget.classList.remove('cds--text-input--empty');
    }
  }

  updateAriaActivedescendant() {
    const visibleItems = this.visibleItems();
    if (
      this.isOpen &&
      this.highlightedIndex >= 0 &&
      visibleItems[this.highlightedIndex]
    ) {
      this.inputTarget.setAttribute(
        'aria-activedescendant',
        visibleItems[this.highlightedIndex].id
      );
    } else {
      this.inputTarget.removeAttribute('aria-activedescendant');
    }
  }
}
