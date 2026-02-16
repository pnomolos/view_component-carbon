import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['counter', 'announcer'];
  static values = {
    maxCount: Number
  };

  connect() {
    if (this.hasCounterTarget) {
      const textarea = this.element.querySelector('textarea');
      if (textarea) {
        this.updateCounter(textarea);
        textarea.addEventListener('input', (e) => this.updateCounter(e.target));
      }
    }
    this.previousLength = 0;
    this.announcementTimeout = null;
  }

  updateCounter(textarea) {
    const currentLength = textarea.value.length;
    this.counterTarget.textContent = `${currentLength} / ${this.maxCountValue}`;

    // Announce counter updates to screen readers
    if (this.hasAnnouncerTarget) {
      this.announceCounterUpdate(currentLength);
    }

    this.previousLength = currentLength;
  }

  announceCounterUpdate(currentLength) {
    // Clear any pending announcement
    if (this.announcementTimeout) {
      clearTimeout(this.announcementTimeout);
    }

    // Only announce if the value actually changed
    if (currentLength === this.previousLength) {
      return;
    }

    const remaining = this.maxCountValue - currentLength;
    let announcement = '';

    if (remaining === 0) {
      announcement = 'At character limit';
    } else if (remaining < 0) {
      announcement = `${Math.abs(remaining)} characters over limit`;
    } else if (remaining <= 10) {
      announcement = `${remaining} ${remaining === 1 ? 'character' : 'characters'} left`;
    } else if (remaining <= 50) {
      // Announce every 10 characters when between 50 and 10
      if (remaining % 10 === 0) {
        announcement = `${remaining} characters left`;
      }
    }

    // Debounce announcements to prevent spam (1 second for character mode)
    if (announcement) {
      this.announcementTimeout = setTimeout(() => {
        this.announcerTarget.textContent = announcement;
        // Clear announcement after it's been read to prevent re-announcing on re-focus
        setTimeout(() => {
          this.announcerTarget.textContent = '';
        }, 1000);
      }, 1000);
    }
  }

  disconnect() {
    if (this.announcementTimeout) {
      clearTimeout(this.announcementTimeout);
    }
  }
}
