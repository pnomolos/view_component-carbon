import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['input', 'closeButton']

  onInput() {
    const hasValue = this.inputTarget.value.length > 0

    if (hasValue) {
      this.closeButtonTarget.classList.remove('cds--search-close--hidden')
    } else {
      this.closeButtonTarget.classList.add('cds--search-close--hidden')
    }

    // Toggle expanded state for expandable search
    if (this.element.classList.contains('cds--search--expandable')) {
      if (hasValue) {
        this.element.classList.add('cds--search--expanded')
      } else {
        this.element.classList.remove('cds--search--expanded')
      }
    }
  }

  clear() {
    this.inputTarget.value = ''
    this.closeButtonTarget.classList.add('cds--search-close--hidden')
    this.inputTarget.focus()

    // Remove expanded state for expandable search
    if (this.element.classList.contains('cds--search--expandable')) {
      this.element.classList.remove('cds--search--expanded')
    }
  }
}
