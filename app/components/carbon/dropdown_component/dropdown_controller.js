import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['trigger', 'menu', 'item', 'label'];

  connect() {
    this.isOpen = false;
    this.highlightedIndex = -1;
    this._handleClickOutside = this.handleClickOutside.bind(this);
    document.addEventListener('click', this._handleClickOutside);
  }

  disconnect() {
    document.removeEventListener('click', this._handleClickOutside);
  }

  toggle(event) {
    event.preventDefault();
    if (this.element.classList.contains('cds--dropdown--disabled')) return;

    if (this.isOpen) {
      this.close();
    } else {
      this.open();
    }
  }

  open() {
    this.isOpen = true;
    this.element.classList.add('cds--dropdown--open');
    this.element.classList.add('cds--list-box--expanded');
    this.triggerTarget.setAttribute('aria-expanded', 'true');

    // Highlight the currently selected item, or first item
    const selectedIndex = this.enabledItems.findIndex(
      (item) => item.getAttribute('aria-selected') === 'true'
    );
    this.setHighlighted(selectedIndex >= 0 ? selectedIndex : 0);
  }

  close() {
    this.isOpen = false;
    this.element.classList.remove('cds--dropdown--open');
    this.element.classList.remove('cds--list-box--expanded');
    this.triggerTarget.setAttribute('aria-expanded', 'false');
    this.clearHighlighted();
    this.highlightedIndex = -1;
  }

  select(event) {
    const item = event.currentTarget;
    if (item.getAttribute('aria-disabled') === 'true') return;

    // Deselect all items
    this.itemTargets.forEach((i) => {
      i.classList.remove('cds--list-box__menu-item--active');
      i.setAttribute('aria-selected', 'false');
      // Remove checkmark icon
      const icon = i.querySelector('.cds--list-box__menu-item__selected-icon');
      if (icon) icon.remove();
    });

    // Select clicked item
    item.classList.add('cds--list-box__menu-item--active');
    item.setAttribute('aria-selected', 'true');

    // Add checkmark icon
    const optionDiv = item.querySelector('.cds--list-box__menu-item__option');
    if (optionDiv && !optionDiv.querySelector('.cds--list-box__menu-item__selected-icon')) {
      const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
      svg.setAttribute('focusable', 'false');
      svg.setAttribute('preserveAspectRatio', 'xMidYMid meet');
      svg.setAttribute('fill', 'currentColor');
      svg.setAttribute('width', '16');
      svg.setAttribute('height', '16');
      svg.setAttribute('viewBox', '0 0 32 32');
      svg.setAttribute('aria-hidden', 'true');
      svg.classList.add('cds--list-box__menu-item__selected-icon');
      const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
      path.setAttribute('d', 'M13 24L4 15 5.414 13.586 13 21.171 26.586 7.586 28 9 13 24z');
      svg.appendChild(path);
      optionDiv.appendChild(svg);
    }

    // Update label text
    const text = optionDiv ? optionDiv.textContent.trim() : item.textContent.trim();
    this.labelTarget.textContent = text;

    this.close();
    this.triggerTarget.focus();

    // Dispatch custom event
    this.dispatch('change', { detail: { value: item.dataset.value, text } });
  }

  handleTriggerKeydown(event) {
    switch (event.key) {
      case 'Enter':
      case ' ':
        event.preventDefault();
        this.toggle(event);
        break;
      case 'ArrowDown':
        event.preventDefault();
        if (!this.isOpen) {
          this.open();
        } else {
          this.moveHighlight(1);
        }
        break;
      case 'ArrowUp':
        event.preventDefault();
        if (!this.isOpen) {
          this.open();
        } else {
          this.moveHighlight(-1);
        }
        break;
      case 'Home':
        event.preventDefault();
        if (this.isOpen) this.setHighlighted(0);
        break;
      case 'End':
        event.preventDefault();
        if (this.isOpen) this.setHighlighted(this.enabledItems.length - 1);
        break;
      case 'Escape':
        event.preventDefault();
        if (this.isOpen) {
          this.close();
          this.triggerTarget.focus();
        }
        break;
      default:
        break;
    }
  }

  handleClickOutside(event) {
    if (this.isOpen && !this.element.contains(event.target)) {
      this.close();
    }
  }

  get enabledItems() {
    return this.itemTargets.filter(
      (item) => item.getAttribute('aria-disabled') !== 'true'
    );
  }

  moveHighlight(direction) {
    const items = this.enabledItems;
    if (items.length === 0) return;

    let nextIndex = this.highlightedIndex + direction;
    if (nextIndex < 0) nextIndex = items.length - 1;
    if (nextIndex >= items.length) nextIndex = 0;

    this.setHighlighted(nextIndex);
  }

  setHighlighted(index) {
    this.clearHighlighted();
    const items = this.enabledItems;
    if (index >= 0 && index < items.length) {
      this.highlightedIndex = index;
      items[index].classList.add('cds--list-box__menu-item--highlighted');
      items[index].scrollIntoView({ block: 'nearest' });
    }
  }

  clearHighlighted() {
    this.itemTargets.forEach((item) => {
      item.classList.remove('cds--list-box__menu-item--highlighted');
    });
  }
}
