# frozen_string_literal: true

require 'test_helper'

module Carbon
  class DataTableComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default data table container' do
      render_inline(Carbon::DataTableComponent.new) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'div.cds--data-table-container'
    end

    test 'renders table element' do
      render_inline(Carbon::DataTableComponent.new) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'table.cds--data-table'
    end

    test 'renders thead and tbody' do
      render_inline(Carbon::DataTableComponent.new) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'table thead tr th'
      assert_selector 'table tbody tr td'
    end

    test 'renders data table content wrapper' do
      render_inline(Carbon::DataTableComponent.new) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'div.cds--data-table-content table'
    end

    # -- Title and description --

    test 'renders title' do
      render_inline(Carbon::DataTableComponent.new(title: 'My Table')) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector '.cds--data-table-header .cds--data-table-header__title', text: 'My Table'
    end

    test 'renders description' do
      render_inline(Carbon::DataTableComponent.new(title: 'Table', description: 'A description')) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector '.cds--data-table-header .cds--data-table-header__description', text: 'A description'
    end

    test 'does not render header when no title or description' do
      render_inline(Carbon::DataTableComponent.new) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_no_selector '.cds--data-table-header'
    end

    # -- Size variants --

    test 'renders lg size by default' do
      render_inline(Carbon::DataTableComponent.new) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'table.cds--data-table.cds--data-table--lg'
    end

    test 'renders xs size' do
      render_inline(Carbon::DataTableComponent.new(size: :xs)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'table.cds--data-table--xs'
    end

    test 'renders sm size' do
      render_inline(Carbon::DataTableComponent.new(size: :sm)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'table.cds--data-table--sm'
    end

    test 'renders md size' do
      render_inline(Carbon::DataTableComponent.new(size: :md)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'table.cds--data-table--md'
    end

    test 'renders xl size' do
      render_inline(Carbon::DataTableComponent.new(size: :xl)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'table.cds--data-table--xl'
    end

    test 'raises ArgumentError for invalid size' do
      assert_raises(ArgumentError) do
        Carbon::DataTableComponent.new(size: :invalid)
      end
    end

    # -- Zebra striping --

    test 'renders without zebra class by default' do
      render_inline(Carbon::DataTableComponent.new) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_no_selector 'table.cds--data-table--zebra'
    end

    test 'renders zebra striping' do
      render_inline(Carbon::DataTableComponent.new(zebra: true)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'table.cds--data-table--zebra'
    end

    # -- Sticky header --

    test 'renders without sticky header by default' do
      render_inline(Carbon::DataTableComponent.new) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_no_selector 'table.cds--data-table--sticky-header'
    end

    test 'renders sticky header' do
      render_inline(Carbon::DataTableComponent.new(sticky_header: true)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'table.cds--data-table--sticky-header'
    end

    # -- Static width --

    test 'renders static width classes' do
      render_inline(Carbon::DataTableComponent.new(static_width: true)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'div.cds--data-table-container--static'
      assert_selector 'table.cds--data-table--static'
    end

    # -- Sortable headers --

    test 'renders sort class on table when sortable' do
      render_inline(Carbon::DataTableComponent.new(sortable: true)) do |c|
        c.with_head do |head|
          head.with_cell(sortable: true, key: 'name') { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'table.cds--data-table--sort'
    end

    test 'renders sort button in sortable header cell' do
      render_inline(Carbon::DataTableComponent.new(sortable: true)) do |c|
        c.with_head do |head|
          head.with_cell(sortable: true, key: 'name') { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'th button.cds--table-sort'
    end

    test 'renders aria-sort on sortable header cell' do
      render_inline(Carbon::DataTableComponent.new(sortable: true)) do |c|
        c.with_head do |head|
          head.with_cell(sortable: true, key: 'name') { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'th[aria-sort="none"]'
    end

    test 'renders ascending sort direction' do
      render_inline(Carbon::DataTableComponent.new(sortable: true)) do |c|
        c.with_head do |head|
          head.with_cell(sortable: true, key: 'name', sort_direction: :ascending) { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'th[aria-sort="ascending"]'
      assert_selector 'button.cds--table-sort.cds--table-sort--active'
    end

    test 'renders descending sort direction' do
      render_inline(Carbon::DataTableComponent.new(sortable: true)) do |c|
        c.with_head do |head|
          head.with_cell(sortable: true, key: 'name', sort_direction: :descending) { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'th[aria-sort="descending"]'
      assert_selector 'button.cds--table-sort.cds--table-sort--active.cds--table-sort--descending'
    end

    test 'renders sort icons in sortable header' do
      render_inline(Carbon::DataTableComponent.new(sortable: true)) do |c|
        c.with_head do |head|
          head.with_cell(sortable: true, key: 'name') { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'button.cds--table-sort svg'
    end

    test 'renders header label in sortable header' do
      render_inline(Carbon::DataTableComponent.new(sortable: true)) do |c|
        c.with_head do |head|
          head.with_cell(sortable: true, key: 'name') { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'button.cds--table-sort .cds--table-header-label', text: 'Name'
    end

    test 'renders non-sortable header cell without button' do
      render_inline(Carbon::DataTableComponent.new) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_no_selector 'th button'
      assert_selector 'th .cds--table-header-label', text: 'Name'
    end

    test 'sort header has data-action for stimulus' do
      render_inline(Carbon::DataTableComponent.new(sortable: true)) do |c|
        c.with_head do |head|
          head.with_cell(sortable: true, key: 'name') { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'button[data-action="click->carbon--data-table#handleSort"]'
    end

    test 'sort header has sortHeader target' do
      render_inline(Carbon::DataTableComponent.new(sortable: true)) do |c|
        c.with_head do |head|
          head.with_cell(sortable: true, key: 'name') { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'button[data-carbon--data-table-target="sortHeader"]'
    end

    # -- Selectable rows --

    test 'renders checkboxes when selectable' do
      render_inline(Carbon::DataTableComponent.new(selectable: true)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'td.cds--table-column-checkbox input[type="checkbox"]'
    end

    test 'renders aria-selected on selectable rows' do
      render_inline(Carbon::DataTableComponent.new(selectable: true)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'tr[aria-selected="false"]'
    end

    test 'renders selected row' do
      render_inline(Carbon::DataTableComponent.new(selectable: true)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row(selected: true) do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'tr.cds--data-table--selected[aria-selected="true"]'
      assert_selector 'input[type="checkbox"][checked]'
    end

    test 'renders checkbox with stimulus action' do
      render_inline(Carbon::DataTableComponent.new(selectable: true)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'input[data-action="change->carbon--data-table#selectRow"]'
    end

    test 'renders rowSelect target on checkbox' do
      render_inline(Carbon::DataTableComponent.new(selectable: true)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'input[data-carbon--data-table-target="rowSelect"]'
    end

    test 'renders disabled checkbox when row is disabled' do
      render_inline(Carbon::DataTableComponent.new(selectable: true)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row(disabled: true) do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'input[type="checkbox"][disabled]'
    end

    # -- Radio selection --

    test 'renders radio buttons when radio mode' do
      render_inline(Carbon::DataTableComponent.new(selectable: true, radio: true)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'td.cds--table-column-checkbox input[type="radio"]'
    end

    test 'radio inputs share the same name attribute' do
      render_inline(Carbon::DataTableComponent.new(selectable: true, radio: true)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
        c.with_row do |row|
          row.with_cell { 'Bob' }
        end
      end

      radios = page.all('input[type="radio"]')

      assert_equal 2, radios.length
      assert_equal radios[0][:name], radios[1][:name]
    end

    # -- Expandable rows --

    test 'renders expand button when expandable' do
      render_inline(Carbon::DataTableComponent.new(expandable: true)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
          row.with_expanded_content { 'Expanded content here' }
        end
      end

      assert_selector 'td.cds--table-expand button.cds--table-expand__button'
    end

    test 'renders aria-expanded on expand button' do
      render_inline(Carbon::DataTableComponent.new(expandable: true)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
          row.with_expanded_content { 'Expanded content here' }
        end
      end

      assert_selector 'button.cds--table-expand__button[aria-expanded="false"]'
    end

    test 'renders aria-controls linking to expanded row' do
      render_inline(Carbon::DataTableComponent.new(expandable: true)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row(row_id: 'test-row') do |row|
          row.with_cell { 'Alice' }
          row.with_expanded_content { 'Expanded content here' }
        end
      end

      assert_selector 'button[aria-controls="test-row-expanded"]'
      assert_selector 'tr#test-row-expanded', visible: :all
    end

    test 'renders expanded row content' do
      render_inline(Carbon::DataTableComponent.new(expandable: true)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
          row.with_expanded_content { 'Expanded content here' }
        end
      end

      assert_selector '.cds--child-row-inner-container', text: 'Expanded content here', visible: :all
    end

    test 'expanded row is hidden by default' do
      render_inline(Carbon::DataTableComponent.new(expandable: true)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
          row.with_expanded_content { 'Expanded content here' }
        end
      end

      assert_selector 'tr.cds--expandable-row--hover-area[hidden]', visible: :all
    end

    test 'renders expanded row when expanded is true' do
      render_inline(Carbon::DataTableComponent.new(expandable: true)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row(expanded: true) do |row|
          row.with_cell { 'Alice' }
          row.with_expanded_content { 'Expanded content here' }
        end
      end

      assert_selector 'button.cds--table-expand__button[aria-expanded="true"]'
      assert_no_selector 'tr.cds--expandable-row--hover-area[hidden]'
    end

    test 'renders expandable-row class on expandable row' do
      render_inline(Carbon::DataTableComponent.new(expandable: true)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
          row.with_expanded_content { 'Expanded content' }
        end
      end

      assert_selector 'tr.cds--expandable-row'
    end

    test 'expand button has stimulus action' do
      render_inline(Carbon::DataTableComponent.new(expandable: true)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
          row.with_expanded_content { 'Content' }
        end
      end

      assert_selector 'button[data-action="click->carbon--data-table#toggleExpand"]'
    end

    test 'expand button has expandButton target' do
      render_inline(Carbon::DataTableComponent.new(expandable: true)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
          row.with_expanded_content { 'Content' }
        end
      end

      assert_selector 'button[data-carbon--data-table-target="expandButton"]'
    end

    # -- Toolbar --

    test 'renders toolbar' do
      render_inline(Carbon::DataTableComponent.new) do |c|
        c.with_toolbar
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'section.cds--table-toolbar'
    end

    test 'renders toolbar content area' do
      render_inline(Carbon::DataTableComponent.new) do |c|
        c.with_toolbar { 'Toolbar buttons' }
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector '.cds--toolbar-content', text: 'Toolbar buttons'
    end

    # -- Batch actions --

    test 'renders batch actions bar' do
      render_inline(Carbon::DataTableComponent.new(selectable: true)) do |c|
        c.with_toolbar do |toolbar|
          toolbar.with_batch_actions do |batch|
            batch.with_action(label: 'Delete')
          end
        end
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector '.cds--batch-actions'
    end

    test 'renders batch action buttons' do
      render_inline(Carbon::DataTableComponent.new(selectable: true)) do |c|
        c.with_toolbar do |toolbar|
          toolbar.with_batch_actions do |batch|
            batch.with_action(label: 'Delete')
            batch.with_action(label: 'Export')
          end
        end
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector '.cds--action-list button.cds--btn', text: 'Delete'
      assert_selector '.cds--action-list button.cds--btn', text: 'Export'
    end

    test 'renders batch actions cancel button' do
      render_inline(Carbon::DataTableComponent.new(selectable: true)) do |c|
        c.with_toolbar do |toolbar|
          toolbar.with_batch_actions do |batch|
            batch.with_action(label: 'Delete')
          end
        end
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector '.cds--batch-summary__cancel[data-action="carbon--data-table#cancelBatchActions"]'
    end

    test 'renders selected count target' do
      render_inline(Carbon::DataTableComponent.new(selectable: true)) do |c|
        c.with_toolbar do |toolbar|
          toolbar.with_batch_actions do |batch|
            batch.with_action(label: 'Delete')
          end
        end
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector '[data-carbon--data-table-target="selectedCount"]'
    end

    test 'renders batch actions target' do
      render_inline(Carbon::DataTableComponent.new(selectable: true)) do |c|
        c.with_toolbar do |toolbar|
          toolbar.with_batch_actions do |batch|
            batch.with_action(label: 'Delete')
          end
        end
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector '[data-carbon--data-table-target="batchActions"]'
    end

    # -- Toolbar search --

    test 'renders toolbar search' do
      render_inline(Carbon::DataTableComponent.new) do |c|
        c.with_toolbar(&:with_search)
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector '.cds--toolbar-search-container-persistent'
      assert_selector 'input.cds--search-input[data-carbon--data-table-target="searchInput"]'
    end

    test 'renders toolbar search with custom placeholder' do
      render_inline(Carbon::DataTableComponent.new) do |c|
        c.with_toolbar do |toolbar|
          toolbar.with_search(placeholder: 'Search names')
        end
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'input[placeholder="Search names"]'
    end

    test 'renders toolbar search filter action' do
      render_inline(Carbon::DataTableComponent.new) do |c|
        c.with_toolbar(&:with_search)
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'input[data-action="input->carbon--data-table#filterRows"]'
    end

    test 'renders toolbar search clear button' do
      render_inline(Carbon::DataTableComponent.new) do |c|
        c.with_toolbar(&:with_search)
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'button[data-action="click->carbon--data-table#clearSearch"]'
    end

    # -- Stimulus controller --

    test 'renders stimulus controller on container' do
      render_inline(Carbon::DataTableComponent.new) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'div[data-controller="carbon--data-table"]'
    end

    test 'renders selectable value when selectable' do
      render_inline(Carbon::DataTableComponent.new(selectable: true)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'div[data-carbon--data-table-selectable-value="true"]'
    end

    test 'renders expandable value when expandable' do
      render_inline(Carbon::DataTableComponent.new(expandable: true)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
          row.with_expanded_content { 'Content' }
        end
      end

      assert_selector 'div[data-carbon--data-table-expandable-value="true"]'
    end

    test 'renders radio value when radio mode' do
      render_inline(Carbon::DataTableComponent.new(selectable: true, radio: true)) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'div[data-carbon--data-table-radio-value="true"]'
    end

    test 'renders body target on tbody' do
      render_inline(Carbon::DataTableComponent.new) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'tbody[data-carbon--data-table-target="body"]'
    end

    test 'renders row target on tr' do
      render_inline(Carbon::DataTableComponent.new) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'tr[data-carbon--data-table-target="row"]'
    end

    # -- System arguments --

    test 'passes through system arguments on container' do
      render_inline(Carbon::DataTableComponent.new(id: 'my-table')) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'div.cds--data-table-container#my-table'
    end

    test 'merges custom class on container' do
      render_inline(Carbon::DataTableComponent.new(class: 'custom-class')) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
        end
      end

      assert_selector 'div.cds--data-table-container.custom-class'
    end

    # -- Multiple rows --

    test 'renders multiple rows' do
      render_inline(Carbon::DataTableComponent.new) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
          head.with_cell { 'Age' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
          row.with_cell { '30' }
        end
        c.with_row do |row|
          row.with_cell { 'Bob' }
          row.with_cell { '25' }
        end
      end

      assert_selector 'thead th', count: 2
      assert_selector 'tbody tr[data-carbon--data-table-target="row"]', count: 2
      assert_selector 'td', text: 'Alice'
      assert_selector 'td', text: 'Bob'
    end

    # -- Complete data table --

    test 'renders complete data table with all features' do # rubocop:disable Metrics/BlockLength,Minitest/MultipleAssertions
      render_inline(Carbon::DataTableComponent.new(
                      title: 'Users',
                      description: 'A list of users',
                      sortable: true,
                      selectable: true,
                      size: :md,
                      zebra: true
                    )) do |c|
        c.with_toolbar do |toolbar|
          toolbar.with_batch_actions do |batch|
            batch.with_action(label: 'Delete')
          end
          toolbar.with_search(placeholder: 'Find user')
        end
        c.with_head do |head|
          head.with_cell(sortable: true, key: 'name') { 'Name' }
          head.with_cell(sortable: true, key: 'email') { 'Email' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice' }
          row.with_cell { 'alice@example.com' }
        end
        c.with_row do |row|
          row.with_cell { 'Bob' }
          row.with_cell { 'bob@example.com' }
        end
      end

      assert_selector 'div.cds--data-table-container[data-controller="carbon--data-table"]'
      assert_selector '.cds--data-table-header__title', text: 'Users'
      assert_selector '.cds--data-table-header__description', text: 'A list of users'
      assert_selector 'section.cds--table-toolbar'
      assert_selector '.cds--batch-actions'
      assert_selector 'input.cds--search-input[placeholder="Find user"]'
      assert_selector 'table.cds--data-table.cds--data-table--md.cds--data-table--sort.cds--data-table--zebra'
      assert_selector 'th button.cds--table-sort', count: 2
      assert_selector 'td.cds--table-column-checkbox', count: 2
      assert_selector 'td', text: 'Alice'
      assert_selector 'td', text: 'bob@example.com'
    end
  end
end
