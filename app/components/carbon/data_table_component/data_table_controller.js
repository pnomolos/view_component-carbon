import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = [
    'body',
    'row',
    'expandedRow',
    'expandButton',
    'rowSelect',
    'selectAll',
    'sortHeader',
    'batchActions',
    'selectedCount',
    'searchInput',
  ];

  static values = {
    selectable: { type: Boolean, default: false },
    expandable: { type: Boolean, default: false },
    radio: { type: Boolean, default: false },
  };

  // -- Sort --

  handleSort(event) {
    const button = event.currentTarget;
    const currentDirection = button.dataset.sortDirection;
    let newDirection;

    if (currentDirection === 'none') {
      newDirection = 'ascending';
    } else if (currentDirection === 'ascending') {
      newDirection = 'descending';
    } else {
      newDirection = 'none';
    }

    // Reset all sort headers
    this.sortHeaderTargets.forEach((header) => {
      header.dataset.sortDirection = 'none';
      header.classList.remove('cds--table-sort--active', 'cds--table-sort--descending');
      const th = header.closest('th');
      if (th) th.setAttribute('aria-sort', 'none');
    });

    // Apply new sort direction
    button.dataset.sortDirection = newDirection;
    if (newDirection !== 'none') {
      button.classList.add('cds--table-sort--active');
      if (newDirection === 'descending') {
        button.classList.add('cds--table-sort--descending');
      }
    }

    const th = button.closest('th');
    if (th) th.setAttribute('aria-sort', newDirection);

    this.dispatch('sort', {
      detail: { key: button.dataset.sortKey, direction: newDirection },
    });
  }

  // -- Selection --

  toggleSelectAll(event) {
    const checked = event.currentTarget.checked;

    this.rowSelectTargets.forEach((input) => {
      input.checked = checked;
      const row = input.closest('tr');
      if (row) {
        if (checked) {
          row.classList.add('cds--data-table--selected');
          row.setAttribute('aria-selected', 'true');
        } else {
          row.classList.remove('cds--data-table--selected');
          row.setAttribute('aria-selected', 'false');
        }
      }
    });

    this.updateBatchActions();
  }

  selectRow(event) {
    const input = event.currentTarget;
    const row = input.closest('tr');

    if (this.radioValue) {
      // Deselect all other rows first
      this.rowSelectTargets.forEach((otherInput) => {
        if (otherInput !== input) {
          otherInput.checked = false;
          const otherRow = otherInput.closest('tr');
          if (otherRow) {
            otherRow.classList.remove('cds--data-table--selected');
            otherRow.setAttribute('aria-selected', 'false');
          }
        }
      });
    }

    if (row) {
      if (input.checked) {
        row.classList.add('cds--data-table--selected');
        row.setAttribute('aria-selected', 'true');
      } else {
        row.classList.remove('cds--data-table--selected');
        row.setAttribute('aria-selected', 'false');
      }
    }

    this.updateSelectAllState();
    this.updateBatchActions();
  }

  updateSelectAllState() {
    if (!this.hasSelectAllTarget) return;

    const total = this.rowSelectTargets.length;
    const checked = this.rowSelectTargets.filter((i) => i.checked).length;

    if (checked === 0) {
      this.selectAllTarget.checked = false;
      this.selectAllTarget.indeterminate = false;
    } else if (checked === total) {
      this.selectAllTarget.checked = true;
      this.selectAllTarget.indeterminate = false;
    } else {
      this.selectAllTarget.checked = false;
      this.selectAllTarget.indeterminate = true;
    }
  }

  updateBatchActions() {
    const selectedCount = this.rowSelectTargets.filter((i) => i.checked).length;

    if (this.hasSelectedCountTarget) {
      this.selectedCountTarget.textContent = selectedCount;
    }

    if (this.hasBatchActionsTarget) {
      if (selectedCount > 0) {
        this.batchActionsTarget.classList.add('cds--batch-actions--active');
      } else {
        this.batchActionsTarget.classList.remove('cds--batch-actions--active');
      }
    }
  }

  cancelBatchActions() {
    this.rowSelectTargets.forEach((input) => {
      input.checked = false;
      const row = input.closest('tr');
      if (row) {
        row.classList.remove('cds--data-table--selected');
        row.setAttribute('aria-selected', 'false');
      }
    });

    if (this.hasSelectAllTarget) {
      this.selectAllTarget.checked = false;
      this.selectAllTarget.indeterminate = false;
    }

    this.updateBatchActions();
  }

  // -- Expansion --

  toggleExpand(event) {
    const button = event.currentTarget;
    const row = button.closest('tr');
    const isExpanded = button.getAttribute('aria-expanded') === 'true';
    const targetId = button.getAttribute('aria-controls');
    const expandedRow = document.getElementById(targetId);

    button.setAttribute('aria-expanded', (!isExpanded).toString());

    if (expandedRow) {
      if (isExpanded) {
        expandedRow.setAttribute('hidden', '');
      } else {
        expandedRow.removeAttribute('hidden');
      }
    }

    if (row) {
      const expandCell = row.querySelector('.cds--table-expand');
      if (expandCell) {
        expandCell.dataset.previousValue = isExpanded ? 'collapsed' : 'expanded';
      }
    }
  }

  toggleExpandAll() {
    const allExpanded = this.expandButtonTargets.every(
      (btn) => btn.getAttribute('aria-expanded') === 'true',
    );

    this.expandButtonTargets.forEach((button) => {
      button.setAttribute('aria-expanded', (!allExpanded).toString());
      const targetId = button.getAttribute('aria-controls');
      const expandedRow = document.getElementById(targetId);
      if (expandedRow) {
        if (allExpanded) {
          expandedRow.setAttribute('hidden', '');
        } else {
          expandedRow.removeAttribute('hidden');
        }
      }
    });
  }

  // -- Search / Filter --

  filterRows() {
    if (!this.hasSearchInputTarget) return;

    const query = this.searchInputTarget.value.toLowerCase().trim();

    this.rowTargets.forEach((row) => {
      const text = row.textContent.toLowerCase();
      const matches = query === '' || text.includes(query);
      row.style.display = matches ? '' : 'none';

      // Also hide associated expanded rows
      const nextRow = row.nextElementSibling;
      if (nextRow && nextRow.classList.contains('cds--expandable-row--hover-area')) {
        nextRow.style.display = matches ? '' : 'none';
      }
    });
  }

  clearSearch() {
    if (!this.hasSearchInputTarget) return;
    this.searchInputTarget.value = '';
    this.filterRows();
  }
}
