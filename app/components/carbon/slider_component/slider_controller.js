import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['slider', 'thumb', 'thumbWrapper', 'filledTrack', 'numberInput'];

  static values = {
    min: Number,
    max: Number,
    step: Number,
    stepMultiplier: Number,
    value: Number
  };

  connect() {
    this._onMouseMove = this.onMouseMove.bind(this);
    this._onMouseUp = this.onMouseUp.bind(this);
  }

  disconnect() {
    document.removeEventListener('mousemove', this._onMouseMove);
    document.removeEventListener('mouseup', this._onMouseUp);
  }

  onTrackMouseDown(event) {
    if (this.thumbTarget.getAttribute('aria-disabled') === 'true') return;
    event.preventDefault();
    this._dragging = true;
    this._updateFromMouseEvent(event);
    document.addEventListener('mousemove', this._onMouseMove);
    document.addEventListener('mouseup', this._onMouseUp);
  }

  onMouseMove(event) {
    if (!this._dragging) return;
    event.preventDefault();
    this._updateFromMouseEvent(event);
  }

  onMouseUp() {
    this._dragging = false;
    document.removeEventListener('mousemove', this._onMouseMove);
    document.removeEventListener('mouseup', this._onMouseUp);
  }

  onKeyDown(event) {
    if (this.thumbTarget.getAttribute('aria-disabled') === 'true') return;
    if (this.thumbTarget.getAttribute('tabindex') === '-1') return;

    const step = this.stepValue || 1;
    const range = this.maxValue - this.minValue;
    const stepMultiplier = this.stepMultiplierValue || 4;
    const largeStep = range / stepMultiplier;
    let newValue = this.valueValue;

    switch (event.key) {
      case 'ArrowRight':
      case 'ArrowUp':
        event.preventDefault();
        if (event.shiftKey) {
          newValue = Math.min(this.valueValue + largeStep, this.maxValue);
        } else {
          newValue = Math.min(this.valueValue + step, this.maxValue);
        }
        break;
      case 'ArrowLeft':
      case 'ArrowDown':
        event.preventDefault();
        if (event.shiftKey) {
          newValue = Math.max(this.valueValue - largeStep, this.minValue);
        } else {
          newValue = Math.max(this.valueValue - step, this.minValue);
        }
        break;
      case 'Home':
        event.preventDefault();
        newValue = this.minValue;
        break;
      case 'End':
        event.preventDefault();
        newValue = this.maxValue;
        break;
      default:
        return;
    }

    this._setValue(newValue);
  }

  onNumberChange(event) {
    let value = parseFloat(event.target.value);
    if (isNaN(value)) return;

    value = Math.max(this.minValue, Math.min(this.maxValue, value));
    this._setValue(value);
  }

  _updateFromMouseEvent(event) {
    const sliderRect = this.sliderTarget.getBoundingClientRect();
    const offsetX = event.clientX - sliderRect.left;
    const fraction = Math.max(0, Math.min(1, offsetX / sliderRect.width));
    const range = this.maxValue - this.minValue;
    const step = this.stepValue || 1;

    let rawValue = this.minValue + fraction * range;
    // Snap to step
    rawValue = Math.round((rawValue - this.minValue) / step) * step + this.minValue;
    rawValue = Math.max(this.minValue, Math.min(this.maxValue, rawValue));

    this._setValue(rawValue);
  }

  _setValue(value) {
    // Round to avoid floating point issues
    const step = this.stepValue || 1;
    const decimals = (step.toString().split('.')[1] || '').length;
    value = parseFloat(value.toFixed(decimals));

    this.valueValue = value;

    const range = this.maxValue - this.minValue;
    const percent = range === 0 ? 0 : ((value - this.minValue) / range) * 100;
    const fraction = range === 0 ? 0 : (value - this.minValue) / range;

    this.thumbTarget.setAttribute('aria-valuenow', value);
    this.thumbTarget.setAttribute('aria-valuetext', value.toString());
    this.thumbWrapperTarget.style.insetInlineStart = `${percent}%`;
    this.filledTrackTarget.style.transform = `translate(0%, -50%) scaleX(${fraction})`;
    if (this.hasNumberInputTarget) {
      this.numberInputTarget.value = value;
    }
  }
}
