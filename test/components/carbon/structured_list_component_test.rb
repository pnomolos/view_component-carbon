# frozen_string_literal: true

require 'test_helper'

module Carbon
  class StructuredListComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders structured list with table role' do
      render_inline(Carbon::StructuredListComponent.new) do |c|
        c.with_header do |h|
          h.with_cell { 'Header 1' }
        end
        c.with_row do |r|
          r.with_cell { 'Cell 1' }
        end
      end

      assert_selector 'div.cds--structured-list[role="table"]'
    end

    test 'renders header with rowgroup role' do
      render_inline(Carbon::StructuredListComponent.new) do |c|
        c.with_header do |h|
          h.with_cell { 'Column 1' }
          h.with_cell { 'Column 2' }
        end
      end

      assert_selector 'div.cds--structured-list-thead[role="rowgroup"]'
      assert_selector 'div.cds--structured-list-row--header-row[role="row"]'
    end

    test 'renders header cells with columnheader role' do
      render_inline(Carbon::StructuredListComponent.new) do |c|
        c.with_header do |h|
          h.with_cell { 'Name' }
          h.with_cell { 'Age' }
        end
      end

      assert_selector 'div.cds--structured-list-th[role="columnheader"]', count: 2
      assert_selector 'div.cds--structured-list-th[role="columnheader"]', text: 'Name'
      assert_selector 'div.cds--structured-list-th[role="columnheader"]', text: 'Age'
    end

    test 'renders body with rowgroup role' do
      render_inline(Carbon::StructuredListComponent.new) do |c|
        c.with_row do |r|
          r.with_cell { 'Data' }
        end
      end

      assert_selector 'div.cds--structured-list-tbody[role="rowgroup"]'
    end

    test 'renders rows with row role' do
      render_inline(Carbon::StructuredListComponent.new) do |c|
        c.with_row do |r|
          r.with_cell { 'Cell 1' }
          r.with_cell { 'Cell 2' }
        end
        c.with_row do |r|
          r.with_cell { 'Cell 3' }
          r.with_cell { 'Cell 4' }
        end
      end

      assert_selector 'div.cds--structured-list-row[role="row"]', count: 2
    end

    test 'renders cells with cell role' do
      render_inline(Carbon::StructuredListComponent.new) do |c|
        c.with_row do |r|
          r.with_cell { 'Data 1' }
          r.with_cell { 'Data 2' }
        end
      end

      assert_selector 'div.cds--structured-list-td[role="cell"]', count: 2
      assert_selector 'div.cds--structured-list-td[role="cell"]', text: 'Data 1'
      assert_selector 'div.cds--structured-list-td[role="cell"]', text: 'Data 2'
    end

    # -- Selection variant --

    test 'renders with selection modifier' do
      render_inline(Carbon::StructuredListComponent.new(selection: true)) do |c|
        c.with_row do |r|
          r.with_cell { 'Data' }
        end
      end

      assert_selector 'div.cds--structured-list.cds--structured-list--selection'
    end

    # -- Condensed and flush variants --

    test 'renders with condensed modifier' do
      render_inline(Carbon::StructuredListComponent.new(condensed: true)) do |c|
        c.with_row do |r|
          r.with_cell { 'Data' }
        end
      end

      assert_selector 'div.cds--structured-list.cds--structured-list--condensed'
    end

    test 'renders with flush modifier' do
      render_inline(Carbon::StructuredListComponent.new(flush: true)) do |c|
        c.with_row do |r|
          r.with_cell { 'Data' }
        end
      end

      assert_selector 'div.cds--structured-list.cds--structured-list--flush'
    end

    test 'renders with both selection and condensed modifiers' do
      render_inline(Carbon::StructuredListComponent.new(selection: true, condensed: true)) do |c|
        c.with_row do |r|
          r.with_cell { 'Data' }
        end
      end

      assert_selector 'div.cds--structured-list.cds--structured-list--selection.cds--structured-list--condensed'
    end

    test 'renders with both selection and flush modifiers' do
      render_inline(Carbon::StructuredListComponent.new(selection: true, flush: true)) do |c|
        c.with_row do |r|
          r.with_cell { 'Data' }
        end
      end

      assert_selector 'div.cds--structured-list.cds--structured-list--selection.cds--structured-list--flush'
    end

    # -- Complete example --

    test 'renders complete structured list with header and multiple rows' do
      render_inline(Carbon::StructuredListComponent.new) do |c|
        c.with_header do |h|
          h.with_cell { 'Name' }
          h.with_cell { 'Status' }
          h.with_cell { 'Actions' }
        end
        c.with_row do |r|
          r.with_cell { 'John Doe' }
          r.with_cell { 'Active' }
          r.with_cell { 'Edit' }
        end
        c.with_row do |r|
          r.with_cell { 'Jane Smith' }
          r.with_cell { 'Inactive' }
          r.with_cell { 'Edit' }
        end
      end

      assert_selector 'div.cds--structured-list'
      assert_selector 'div.cds--structured-list-th', count: 3
      assert_selector 'div.cds--structured-list-tbody div.cds--structured-list-row[role="row"]', count: 2
    end

    test 'renders all cells in complete structured list' do
      render_inline(Carbon::StructuredListComponent.new) do |c|
        c.with_header do |h|
          h.with_cell { 'Name' }
          h.with_cell { 'Status' }
          h.with_cell { 'Actions' }
        end
        c.with_row do |r|
          r.with_cell { 'John Doe' }
          r.with_cell { 'Active' }
          r.with_cell { 'Edit' }
        end
        c.with_row do |r|
          r.with_cell { 'Jane Smith' }
          r.with_cell { 'Inactive' }
          r.with_cell { 'Edit' }
        end
      end

      assert_selector 'div.cds--structured-list-td', count: 6
    end

    # -- System arguments --

    test 'passes through system arguments on structured list' do
      render_inline(Carbon::StructuredListComponent.new(id: 'my-list', data: { testid: 'list-1' })) do |c|
        c.with_row do |r|
          r.with_cell { 'Data' }
        end
      end

      assert_selector 'div#my-list[data-testid="list-1"]'
    end

    test 'merges custom class with component classes on structured list' do
      render_inline(Carbon::StructuredListComponent.new(class: 'my-custom-class')) do |c|
        c.with_row do |r|
          r.with_cell { 'Data' }
        end
      end

      assert_selector 'div.cds--structured-list.my-custom-class'
    end

    test 'passes through system arguments on rows' do
      render_inline(Carbon::StructuredListComponent.new) do |c|
        c.with_row(id: 'row-1', data: { testid: 'row-1' }) do |r|
          r.with_cell { 'Data' }
        end
      end

      assert_selector 'div#row-1[data-testid="row-1"]'
    end

    test 'merges custom class with component classes on rows' do
      render_inline(Carbon::StructuredListComponent.new) do |c|
        c.with_row(class: 'custom-row-class') do |r|
          r.with_cell { 'Data' }
        end
      end

      assert_selector 'div.cds--structured-list-row.custom-row-class'
    end

    # -- Aria label --

    test 'renders default aria-label' do
      render_inline(Carbon::StructuredListComponent.new) do |c|
        c.with_row do |r|
          r.with_cell { 'Data' }
        end
      end

      assert_selector 'div[role="table"][aria-label="Structured list section"]'
    end

    test 'renders custom aria-label' do
      render_inline(Carbon::StructuredListComponent.new(aria_label: 'My custom list')) do |c|
        c.with_row do |r|
          r.with_cell { 'Data' }
        end
      end

      assert_selector 'div[role="table"][aria-label="My custom list"]'
    end
  end
end
