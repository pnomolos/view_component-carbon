import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  toggle(event) {
    event.stopPropagation()
    const isOpen = this.element.classList.contains('cds--popover--open')
    if (isOpen) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    this.element.classList.add('cds--popover--open')
  }

  close() {
    this.element.classList.remove('cds--popover--open')
  }

  connect() {
    this.boundClickOutside = this.clickOutside.bind(this)
    this.boundEscape = this.escape.bind(this)
    document.addEventListener('click', this.boundClickOutside)
    document.addEventListener('keydown', this.boundEscape)
  }

  disconnect() {
    document.removeEventListener('click', this.boundClickOutside)
    document.removeEventListener('keydown', this.boundEscape)
  }

  clickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }

  escape(event) {
    if (event.key === 'Escape') {
      this.close()
    }
  }
}
