import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['code', 'expandButton', 'expandText']

  copy() {
    const codeText = this.codeTarget.textContent
    navigator.clipboard.writeText(codeText).then(() => {
      // Optional: show feedback
    }).catch(err => {
      console.error('Failed to copy:', err)
    })
  }

  toggle() {
    const isExpanded = this.element.classList.contains('cds--snippet--expand')

    if (isExpanded) {
      this.element.classList.remove('cds--snippet--expand')
      this.expandTextTarget.textContent = this.showMoreText
    } else {
      this.element.classList.add('cds--snippet--expand')
      this.expandTextTarget.textContent = this.showLessText
    }
  }

  get showMoreText() {
    return this.element.dataset.showMoreText || 'Show more'
  }

  get showLessText() {
    return this.element.dataset.showLessText || 'Show less'
  }
}
