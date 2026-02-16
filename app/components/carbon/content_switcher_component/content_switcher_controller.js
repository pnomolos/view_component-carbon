import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['option'];

  connect() {
    this.element.addEventListener('keydown', this.handleKeydown.bind(this));
  }

  select(event) {
    const selectedOption = event.currentTarget;

    // Deactivate all options
    this.optionTargets.forEach((option) => {
      option.classList.remove('cds--content-switcher--selected');
      option.setAttribute('aria-selected', 'false');
      option.setAttribute('tabindex', '-1');
    });

    // Activate selected option
    selectedOption.classList.add('cds--content-switcher--selected');
    selectedOption.setAttribute('aria-selected', 'true');
    selectedOption.setAttribute('tabindex', '0');
  }

  handleKeydown(event) {
    const currentOption = event.target;
    if (!currentOption.matches('[role="tab"]')) return;

    const options = this.optionTargets;
    const currentIndex = options.indexOf(currentOption);

    let nextIndex = currentIndex;

    switch (event.key) {
      case 'ArrowLeft':
        event.preventDefault();
        nextIndex = currentIndex - 1;
        if (nextIndex < 0) nextIndex = options.length - 1;
        break;
      case 'ArrowRight':
        event.preventDefault();
        nextIndex = currentIndex + 1;
        if (nextIndex >= options.length) nextIndex = 0;
        break;
      case 'Home':
        event.preventDefault();
        nextIndex = 0;
        break;
      case 'End':
        event.preventDefault();
        nextIndex = options.length - 1;
        break;
      default:
        return;
    }

    if (nextIndex !== currentIndex) {
      options[nextIndex].focus();
      options[nextIndex].click();
    }
  }
}
