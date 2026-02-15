import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  show() {
    this.element.classList.add('cds--popover--open')
  }

  hide() {
    this.element.classList.remove('cds--popover--open')
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
