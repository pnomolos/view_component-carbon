import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['pageSizeSelect', 'itemRange', 'pageDisplay']
  static values = {
    totalItems: Number,
    page: Number,
    pageSize: Number
  }

  prevPage() {
    if (this.pageValue > 1) {
      this.pageValue--
      this.updateDisplay()
    }
  }

  nextPage() {
    if (this.pageValue < this.totalPages) {
      this.pageValue++
      this.updateDisplay()
    }
  }

  changePageSize(event) {
    this.pageSizeValue = parseInt(event.target.value)
    this.pageValue = 1
    this.updateDisplay()
  }

  get totalPages() {
    return Math.ceil(this.totalItemsValue / this.pageSizeValue)
  }

  get startItem() {
    if (this.totalItemsValue === 0) return 0
    return ((this.pageValue - 1) * this.pageSizeValue) + 1
  }

  get endItem() {
    const ending = this.pageValue * this.pageSizeValue
    return ending > this.totalItemsValue ? this.totalItemsValue : ending
  }

  updateDisplay() {
    this.itemRangeTarget.textContent =
      `${this.startItem}-${this.endItem} of ${this.totalItemsValue} items`
    this.pageDisplayTarget.textContent =
      `Page ${this.pageValue} of ${this.totalPages}`

    // Update button states
    const prevButton = this.element.querySelector('.cds--pagination__button--backward')
    const nextButton = this.element.querySelector('.cds--pagination__button--forward')

    if (prevButton) {
      prevButton.disabled = this.pageValue <= 1
    }
    if (nextButton) {
      nextButton.disabled = this.pageValue >= this.totalPages
    }
  }
}
