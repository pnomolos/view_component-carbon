import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['input', 'fileList', 'liveRegion'];
  static values = {
    size: { type: String, default: 'md' },
    dropContainer: { type: Boolean, default: false }
  };

  handleChange(event) {
    const files = Array.from(event.target.files);
    files.forEach((file) => this.addFileItem(file));
    this.announceFileAddition(files.length);
  }

  openFileDialog() {
    this.inputTarget.click();
  }

  handleLabelKeydown(event) {
    if (event.key === 'Enter' || event.key === ' ') {
      event.preventDefault();
      this.inputTarget.click();
    }
  }

  handleDragOver(event) {
    event.preventDefault();
    event.stopPropagation();
    const target = event.currentTarget;
    if (!target.classList.contains('cds--file__drop-container--drag-over')) {
      target.classList.add('cds--file__drop-container--drag-over');
      this.announceDragState('Drop zone active');
    }
  }

  handleDragLeave(event) {
    event.preventDefault();
    event.stopPropagation();
    event.currentTarget.classList.remove('cds--file__drop-container--drag-over');
  }

  handleDrop(event) {
    event.preventDefault();
    event.stopPropagation();
    event.currentTarget.classList.remove('cds--file__drop-container--drag-over');

    const files = Array.from(event.dataTransfer.files);
    files.forEach((file) => this.addFileItem(file));
    this.announceFileAddition(files.length);
  }

  addFileItem(file) {
    const uuid = `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
    const sizeClass = this.sizeValue !== 'lg' ? ` cds--file__selected-file--${this.sizeValue}` : '';

    const item = document.createElement('span');
    item.className = `cds--file__selected-file${sizeClass}`;
    item.dataset.fileUuid = uuid;

    const filenameContainer = document.createElement('p');
    filenameContainer.className = 'cds--file-filename';
    filenameContainer.textContent = file.name;

    const stateContainer = document.createElement('span');
    stateContainer.className = 'cds--file__state-container';

    const removeButton = document.createElement('button');
    removeButton.className = 'cds--file-close';
    removeButton.type = 'button';
    removeButton.setAttribute('aria-label', `Remove file - ${file.name}`);
    removeButton.innerHTML = this.closeIconSvg;
    removeButton.addEventListener('click', () => this.removeFileItem(uuid));

    stateContainer.appendChild(removeButton);
    item.appendChild(filenameContainer);
    item.appendChild(stateContainer);

    this.fileListTarget.appendChild(item);
  }

  removeFileItem(uuid) {
    const item = this.fileListTarget.querySelector(`[data-file-uuid="${uuid}"]`);
    if (item) {
      const filename = item.querySelector('.cds--file-filename')?.textContent || 'File';
      item.remove();
      this.announceFileRemoval(filename);
    }
  }

  announceFileAddition(count) {
    if (!this.hasLiveRegionTarget) return;

    const message = count === 1
      ? '1 file added'
      : `${count} files added`;
    this.announce(message);
  }

  announceFileRemoval(filename) {
    if (!this.hasLiveRegionTarget) return;
    this.announce(`${filename} removed`);
  }

  announceDragState(message) {
    if (!this.hasLiveRegionTarget) return;
    this.announce(message);
  }

  announce(message) {
    if (!this.hasLiveRegionTarget) return;

    // Clear and set message to ensure it's announced
    this.liveRegionTarget.textContent = '';
    setTimeout(() => {
      this.liveRegionTarget.textContent = message;
    }, 100);
  }

  get closeIconSvg() {
    return '<svg focusable="false" preserveAspectRatio="xMidYMid meet" xmlns="http://www.w3.org/2000/svg" ' +
      'fill="currentColor" width="16" height="16" viewBox="0 0 32 32" aria-hidden="true">' +
      '<path d="M24 9.4L22.6 8 16 14.6 9.4 8 8 9.4 14.6 16 8 22.6 9.4 24 16 17.4 22.6 24 24 22.6 ' +
      '17.4 16 24 9.4z"></path></svg>';
  }
}
