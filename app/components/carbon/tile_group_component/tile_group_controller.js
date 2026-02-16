import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  select(event) {
    const clickedLabel = event.currentTarget;
    const clickedInput = clickedLabel.previousElementSibling;

    if (clickedInput && clickedInput.disabled) return;

    // Uncheck all radios and remove selected class
    const allInputs = this.element.querySelectorAll('input[type="radio"]');
    const allLabels = this.element.querySelectorAll('.cds--tile--selectable');

    allInputs.forEach((input) => {
      input.checked = false;
    });

    allLabels.forEach((label) => {
      label.classList.remove('cds--tile--is-selected');
    });

    // Check the clicked one
    if (clickedInput) {
      clickedInput.checked = true;
      clickedLabel.classList.add('cds--tile--is-selected');
    }
  }

  handleKeydown(event) {
    const tiles = Array.from(
      this.element.querySelectorAll('.cds--tile--selectable:not(.cds--tile--disabled)')
    );
    const currentIndex = tiles.indexOf(event.currentTarget);

    let nextIndex;

    switch (event.key) {
      case 'ArrowDown':
      case 'ArrowRight':
        event.preventDefault();
        nextIndex = (currentIndex + 1) % tiles.length;
        tiles[nextIndex].focus();
        tiles[nextIndex].click();
        break;
      case 'ArrowUp':
      case 'ArrowLeft':
        event.preventDefault();
        nextIndex = (currentIndex - 1 + tiles.length) % tiles.length;
        tiles[nextIndex].focus();
        tiles[nextIndex].click();
        break;
    }
  }
}
