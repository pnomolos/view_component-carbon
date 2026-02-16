# frozen_string_literal: true

module Carbon
  class StructuredListComponentPreview < ViewComponent::Preview
    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    # @param selection toggle
    def default(selection: false)
      render_default_list(selection: selection)
    end

    def simple
      render Carbon::StructuredListComponent.new do |c|
        c.with_header do |h|
          h.with_cell { 'Column 1' }
          h.with_cell { 'Column 2' }
        end
        c.with_row do |r|
          r.with_cell { 'Row 1, Cell 1' }
          r.with_cell { 'Row 1, Cell 2' }
        end
        c.with_row do |r|
          r.with_cell { 'Row 2, Cell 1' }
          r.with_cell { 'Row 2, Cell 2' }
        end
      end
    end

    def with_selection
      render Carbon::StructuredListComponent.new(selection: true) do |c|
        c.with_header do |h|
          h.with_cell { 'Product' }
          h.with_cell { 'Price' }
          h.with_cell { 'Quantity' }
        end
        c.with_row do |r|
          r.with_cell { 'Widget A' }
          r.with_cell { '$10.00' }
          r.with_cell { '5' }
        end
        c.with_row do |r|
          r.with_cell { 'Widget B' }
          r.with_cell { '$15.00' }
          r.with_cell { '3' }
        end
      end
    end

    def many_columns
      render_many_column_list
    end

    private

    def render_default_list(selection: false)
      render Carbon::StructuredListComponent.new(selection: selection) do |c|
        c.with_header do |h|
          h.with_cell { 'Name' }
          h.with_cell { 'Email' }
          h.with_cell { 'Status' }
        end
        c.with_row do |r|
          r.with_cell { 'John Doe' }
          r.with_cell { 'john@example.com' }
          r.with_cell { 'Active' }
        end
        c.with_row do |r|
          r.with_cell { 'Jane Smith' }
          r.with_cell { 'jane@example.com' }
          r.with_cell { 'Inactive' }
        end
        c.with_row do |r|
          r.with_cell { 'Bob Johnson' }
          r.with_cell { 'bob@example.com' }
          r.with_cell { 'Active' }
        end
      end
    end

    def render_many_column_list
      render Carbon::StructuredListComponent.new do |c|
        c.with_header do |h|
          h.with_cell { 'ID' }
          h.with_cell { 'Name' }
          h.with_cell { 'Department' }
          h.with_cell { 'Location' }
          h.with_cell { 'Status' }
        end
        c.with_row do |r|
          r.with_cell { '001' }
          r.with_cell { 'Alice Brown' }
          r.with_cell { 'Engineering' }
          r.with_cell { 'New York' }
          r.with_cell { 'Active' }
        end
        c.with_row do |r|
          r.with_cell { '002' }
          r.with_cell { 'Charlie Davis' }
          r.with_cell { 'Marketing' }
          r.with_cell { 'San Francisco' }
          r.with_cell { 'Active' }
        end
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
  end
end
