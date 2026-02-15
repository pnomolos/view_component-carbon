import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['input', 'numberInput']

  onInput(event) {
    const value = event.target.value
    this.numberInputTarget.value = value
  }

  onNumberChange(event) {
    let value = parseFloat(event.target.value)
    const min = parseFloat(this.inputTarget.min)
    const max = parseFloat(this.inputTarget.max)

    // Clamp value to min/max
    if (value < min) value = min
    if (value > max) value = max

    this.inputTarget.value = value
    this.numberInputTarget.value = value
  }
}
