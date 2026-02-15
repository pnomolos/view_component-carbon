import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['input', 'calendar', 'rangeInput'];
  static values = {
    type: { type: String, default: 'single' },
    dateFormat: { type: String, default: 'm/d/Y' },
    minDate: String,
    maxDate: String,
  };

  connect() {
    this.isOpen = false;
    this.currentMonth = new Date();
    this.selectedDate = null;
    this.selectedEndDate = null;
    this._handleClickOutside = this.handleClickOutside.bind(this);
    document.addEventListener('click', this._handleClickOutside);
  }

  disconnect() {
    document.removeEventListener('click', this._handleClickOutside);
    this.removeCalendar();
  }

  openCalendar() {
    if (this.isOpen) return;
    this.isOpen = true;
    this.renderCalendar();
  }

  closeCalendar() {
    if (!this.isOpen) return;
    this.isOpen = false;
    this.removeCalendar();
  }

  toggleCalendar() {
    if (this.isOpen) {
      this.closeCalendar();
    } else {
      this.openCalendar();
    }
  }

  handleInputFocus() {
    this.openCalendar();
  }

  handleInputKeydown(event) {
    switch (event.key) {
      case 'Escape':
        event.preventDefault();
        this.closeCalendar();
        this.inputTarget.focus();
        break;
      case 'ArrowDown':
        event.preventDefault();
        this.openCalendar();
        this.focusCalendarDay();
        break;
      case 'Enter':
        if (this.isOpen) {
          event.preventDefault();
        }
        break;
      default:
        break;
    }
  }

  handleCalendarKeydown(event) {
    const focused = this.calendarElement?.querySelector('.cds--date-picker__day--focused');
    if (!focused) return;

    const date = new Date(parseInt(focused.dataset.timestamp, 10));

    switch (event.key) {
      case 'ArrowRight':
        event.preventDefault();
        this.moveFocus(date, 1);
        break;
      case 'ArrowLeft':
        event.preventDefault();
        this.moveFocus(date, -1);
        break;
      case 'ArrowDown':
        event.preventDefault();
        this.moveFocus(date, 7);
        break;
      case 'ArrowUp':
        event.preventDefault();
        this.moveFocus(date, -7);
        break;
      case 'Enter':
        event.preventDefault();
        this.selectDate(date);
        break;
      case 'Escape':
        event.preventDefault();
        this.closeCalendar();
        this.inputTarget.focus();
        break;
      default:
        break;
    }
  }

  moveFocus(currentDate, days) {
    const newDate = new Date(currentDate);
    newDate.setDate(newDate.getDate() + days);

    if (newDate.getMonth() !== this.currentMonth.getMonth() ||
        newDate.getFullYear() !== this.currentMonth.getFullYear()) {
      this.currentMonth = new Date(newDate.getFullYear(), newDate.getMonth(), 1);
      this.renderCalendar();
    }

    requestAnimationFrame(() => {
      const dayEl = this.calendarElement?.querySelector(
        `[data-timestamp="${newDate.getTime()}"]`
      );
      if (dayEl) {
        this.clearFocusedDay();
        dayEl.classList.add('cds--date-picker__day--focused');
        dayEl.focus();
      }
    });
  }

  focusCalendarDay() {
    requestAnimationFrame(() => {
      const selected = this.calendarElement?.querySelector('.cds--date-picker__day--selected');
      const today = this.calendarElement?.querySelector('.cds--date-picker__day--today');
      const first = this.calendarElement?.querySelector('.cds--date-picker__day');
      const target = selected || today || first;
      if (target) {
        this.clearFocusedDay();
        target.classList.add('cds--date-picker__day--focused');
        target.focus();
      }
    });
  }

  clearFocusedDay() {
    this.calendarElement?.querySelectorAll('.cds--date-picker__day--focused').forEach((el) => {
      el.classList.remove('cds--date-picker__day--focused');
    });
  }

  selectDate(date) {
    if (this.isDateDisabled(date)) return;

    if (this.typeValue === 'range') {
      this.handleRangeSelect(date);
    } else {
      this.selectedDate = date;
      this.inputTarget.value = this.formatDate(date);
      this.closeCalendar();
      this.inputTarget.focus();
      this.dispatch('change', { detail: { date: date.toISOString() } });
    }
  }

  handleRangeSelect(date) {
    if (!this.selectedDate || this.selectedEndDate) {
      this.selectedDate = date;
      this.selectedEndDate = null;
      this.inputTarget.value = this.formatDate(date);
      if (this.hasRangeInputTarget) {
        this.rangeInputTarget.value = '';
      }
      this.renderCalendar();
    } else {
      if (date < this.selectedDate) {
        this.selectedEndDate = this.selectedDate;
        this.selectedDate = date;
      } else {
        this.selectedEndDate = date;
      }
      this.inputTarget.value = this.formatDate(this.selectedDate);
      if (this.hasRangeInputTarget) {
        this.rangeInputTarget.value = this.formatDate(this.selectedEndDate);
      }
      this.closeCalendar();
      this.dispatch('change', {
        detail: {
          startDate: this.selectedDate.toISOString(),
          endDate: this.selectedEndDate.toISOString(),
        },
      });
    }
  }

  handleDayClick(event) {
    const timestamp = parseInt(event.currentTarget.dataset.timestamp, 10);
    const date = new Date(timestamp);
    this.selectDate(date);
  }

  prevMonth() {
    this.currentMonth.setMonth(this.currentMonth.getMonth() - 1);
    this.renderCalendar();
  }

  nextMonth() {
    this.currentMonth.setMonth(this.currentMonth.getMonth() + 1);
    this.renderCalendar();
  }

  handleClickOutside(event) {
    if (this.isOpen && !this.element.contains(event.target)) {
      this.closeCalendar();
    }
  }

  isDateDisabled(date) {
    if (this.hasMinDateValue) {
      const min = new Date(this.minDateValue);
      if (date < min) return true;
    }
    if (this.hasMaxDateValue) {
      const max = new Date(this.maxDateValue);
      if (date > max) return true;
    }
    return false;
  }

  formatDate(date) {
    const format = this.dateFormatValue;
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const year = date.getFullYear();

    return format
      .replace('m', month)
      .replace('d', day)
      .replace('Y', year);
  }

  renderCalendar() {
    this.removeCalendar();

    const calendar = document.createElement('div');
    calendar.classList.add('cds--date-picker__calendar');
    calendar.setAttribute('role', 'dialog');
    calendar.setAttribute('aria-label', 'Calendar');
    calendar.setAttribute('tabindex', '-1');
    calendar.addEventListener('keydown', this.handleCalendarKeydown.bind(this));
    this.calendarElement = calendar;

    // Header with month/year and navigation
    const header = document.createElement('div');
    header.classList.add('cds--date-picker__calendar-header');

    const prevBtn = document.createElement('button');
    prevBtn.type = 'button';
    prevBtn.classList.add('cds--date-picker__calendar-nav', 'cds--date-picker__calendar-nav--prev');
    prevBtn.setAttribute('aria-label', 'Previous month');
    prevBtn.innerHTML = '&#8249;';
    prevBtn.addEventListener('click', (e) => { e.stopPropagation(); this.prevMonth(); });

    const monthLabel = document.createElement('span');
    monthLabel.classList.add('cds--date-picker__calendar-month');
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    monthLabel.textContent = `${monthNames[this.currentMonth.getMonth()]} ${this.currentMonth.getFullYear()}`;

    const nextBtn = document.createElement('button');
    nextBtn.type = 'button';
    nextBtn.classList.add('cds--date-picker__calendar-nav', 'cds--date-picker__calendar-nav--next');
    nextBtn.setAttribute('aria-label', 'Next month');
    nextBtn.innerHTML = '&#8250;';
    nextBtn.addEventListener('click', (e) => { e.stopPropagation(); this.nextMonth(); });

    header.appendChild(prevBtn);
    header.appendChild(monthLabel);
    header.appendChild(nextBtn);
    calendar.appendChild(header);

    // Day names
    const dayNames = document.createElement('div');
    dayNames.classList.add('cds--date-picker__calendar-weekdays');
    ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'].forEach((d) => {
      const span = document.createElement('span');
      span.classList.add('cds--date-picker__calendar-weekday');
      span.textContent = d;
      dayNames.appendChild(span);
    });
    calendar.appendChild(dayNames);

    // Days grid
    const grid = document.createElement('div');
    grid.classList.add('cds--date-picker__calendar-grid');
    grid.setAttribute('role', 'grid');

    const year = this.currentMonth.getFullYear();
    const month = this.currentMonth.getMonth();
    const firstDay = new Date(year, month, 1).getDay();
    const daysInMonth = new Date(year, month + 1, 0).getDate();
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    // Empty cells for days before start
    for (let i = 0; i < firstDay; i++) {
      const empty = document.createElement('span');
      empty.classList.add('cds--date-picker__day', 'cds--date-picker__day--empty');
      grid.appendChild(empty);
    }

    for (let d = 1; d <= daysInMonth; d++) {
      const date = new Date(year, month, d);
      date.setHours(0, 0, 0, 0);
      const dayEl = document.createElement('button');
      dayEl.type = 'button';
      dayEl.classList.add('cds--date-picker__day');
      dayEl.textContent = d;
      dayEl.dataset.timestamp = date.getTime();
      dayEl.setAttribute('tabindex', '-1');
      dayEl.setAttribute('role', 'gridcell');

      if (date.getTime() === today.getTime()) {
        dayEl.classList.add('cds--date-picker__day--today');
      }

      if (this.selectedDate && date.getTime() === this.selectedDate.getTime()) {
        dayEl.classList.add('cds--date-picker__day--selected');
      }

      if (this.selectedEndDate && date.getTime() === this.selectedEndDate.getTime()) {
        dayEl.classList.add('cds--date-picker__day--selected');
      }

      if (this.selectedDate && this.selectedEndDate &&
          date > this.selectedDate && date < this.selectedEndDate) {
        dayEl.classList.add('cds--date-picker__day--in-range');
      }

      if (this.isDateDisabled(date)) {
        dayEl.classList.add('cds--date-picker__day--disabled');
        dayEl.disabled = true;
      }

      dayEl.addEventListener('click', (e) => {
        e.stopPropagation();
        this.handleDayClick(e);
      });

      grid.appendChild(dayEl);
    }

    calendar.appendChild(grid);
    this.element.appendChild(calendar);
  }

  removeCalendar() {
    if (this.calendarElement) {
      this.calendarElement.remove();
      this.calendarElement = null;
    }
  }
}
