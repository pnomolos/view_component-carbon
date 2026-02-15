import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['content']

  show() {
    this.element.classList.add('cds--popover--open')
    if (this.hasContentTarget) {
      this.contentTarget.setAttribute('aria-hidden', 'false')
    }
  }

  hide() {
    this.element.classList.remove('cds--popover--open')
    if (this.hasContentTarget) {
      this.contentTarget.setAttribute('aria-hidden', 'true')
    }
  }

  connect() {
    this.boundHideOnEscape = this.hideOnEscape.bind(this)
    document.addEventListener('keydown', this.boundHideOnEscape)
  }

  disconnect() {
    document.removeEventListener('keydown', this.boundHideOnEscape)
  }

  hideOnEscape(event) {
    if (event.key === 'Escape') {
      this.hide()
    }
  }
}
