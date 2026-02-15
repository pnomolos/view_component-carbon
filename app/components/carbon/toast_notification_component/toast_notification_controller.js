import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = {
    timeout: Number
  }

  connect() {
    if (this.hasTimeoutValue && this.timeoutValue > 0) {
      this.timeoutId = setTimeout(() => {
        this.close()
      }, this.timeoutValue)
    }
  }

  disconnect() {
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
    }
  }

  close() {
    this.element.remove()
  }
}
