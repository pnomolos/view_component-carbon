# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Data Table with optional sorting, selection, and expansion.
  #
  # @example Basic usage
  #   render Carbon::DataTableComponent.new(title: "Users") do |table|
  #     table.with_head { |head| head.with_cell { "Name" } }
  #     table.with_row { |row| row.with_cell { "Alice" } }
  #   end
  #
  # @see https://carbondesignsystem.com/components/data-table/usage/
  class DataTableComponent < BaseComponent
    SIZES = %i[xs sm md lg xl].freeze
    DEFAULT_SIZE = :lg

    renders_one :toolbar, 'ToolbarComponent'
    renders_one :head, lambda { |**system_arguments|
      HeadComponent.new(
        selectable: @selectable,
        radio: @radio,
        expandable: @expandable,
        table_id: @table_id,
        **system_arguments
      )
    }
    renders_many :rows, lambda { |row_id: nil, selected: false, expanded: false, disabled: false, **sys_args|
      RowComponent.new(
        row_id: row_id,
        selected: selected,
        expanded: expanded,
        disabled: disabled,
        selectable: @selectable,
        radio: @radio,
        expandable: @expandable,
        table_id: @table_id,
        **sys_args
      )
    }

    # @return [Symbol] table row size
    attr_reader :size
    # @return [Boolean] whether columns are sortable
    attr_reader :sortable
    # @return [Boolean] whether rows are selectable via checkbox
    attr_reader :selectable
    # @return [Boolean] whether rows use radio selection
    attr_reader :radio
    # @return [Boolean] whether rows are expandable
    attr_reader :expandable
    # @return [Boolean] whether to show zebra striping
    attr_reader :zebra
    # @return [Boolean] whether the header is sticky
    attr_reader :sticky_header
    # @return [Boolean] whether the table has static width
    attr_reader :static_width
    # @return [String, nil] table title
    attr_reader :title
    # @return [String, nil] table description
    attr_reader :description

    # @param size [Symbol] row size (:xs, :sm, :md, :lg, :xl)
    # @param sortable [Boolean] enables column sorting
    # @param selectable [Boolean] enables row selection via checkbox
    # @param radio [Boolean] enables single row selection via radio
    # @param expandable [Boolean] enables row expansion
    # @param zebra [Boolean] enables zebra striping
    # @param sticky_header [Boolean] makes the header sticky
    # @param static_width [Boolean] uses static column widths
    # @param title [String, nil] table title text
    # @param description [String, nil] table description text
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(
      size: DEFAULT_SIZE,
      sortable: false,
      selectable: false,
      radio: false,
      expandable: false,
      zebra: false,
      sticky_header: false,
      static_width: false,
      title: nil,
      description: nil,
      **system_arguments
    )
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @sortable = sortable
      @selectable = selectable
      @radio = radio
      @expandable = expandable
      @zebra = zebra
      @sticky_header = sticky_header
      @static_width = static_width
      @title = title
      @description = description
      @system_arguments = system_arguments
      @table_id = "data-table-#{SecureRandom.hex(8)}"
    end

    private

    def container_css_classes
      classes = ['cds--data-table-container']
      classes << 'cds--data-table-container--static' if @static_width
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def container_attributes # rubocop:disable Metrics/AbcSize
      attrs = @system_arguments.dup
      attrs[:class] = container_css_classes
      attrs[:data] ||= {}
      attrs[:data][:controller] = 'carbon--data-table'
      attrs[:data][:'carbon--data-table-selectable-value'] = @selectable.to_s if @selectable
      attrs[:data][:'carbon--data-table-expandable-value'] = @expandable.to_s if @expandable
      attrs[:data][:'carbon--data-table-radio-value'] = @radio.to_s if @radio
      attrs
    end

    def table_css_classes
      classes = ['cds--data-table']
      classes << "cds--data-table--#{@size}"
      classes << 'cds--data-table--sort' if @sortable
      classes << 'cds--data-table--zebra' if @zebra
      classes << 'cds--data-table--static' if @static_width
      classes << 'cds--data-table--sticky-header' if @sticky_header
      class_names(classes)
    end

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError,
            "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end

    # -- Sub-components --

    # Toolbar area above the data table for search and batch actions.
    class ToolbarComponent < BaseComponent
      renders_one :batch_actions, 'Carbon::DataTableComponent::BatchActionsComponent'
      renders_one :search, 'Carbon::DataTableComponent::ToolbarSearchComponent'

      # @param system_arguments [Hash] additional HTML attributes
      def initialize(**system_arguments)
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = ['cds--table-toolbar']
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.dup
        attrs[:class] = css_classes
        attrs
      end
    end

    # Container for batch action buttons shown when rows are selected.
    class BatchActionsComponent < BaseComponent
      renders_many :actions, 'Carbon::DataTableComponent::BatchActionButtonComponent'

      # @return [Boolean] whether batch actions are visible
      attr_reader :active

      # @param active [Boolean] whether batch actions are visible
      # @param system_arguments [Hash] additional HTML attributes
      def initialize(active: false, **system_arguments)
        @active = active
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = ['cds--batch-actions']
        classes << 'cds--batch-actions--active' if @active
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.dup
        attrs[:class] = css_classes
        attrs[:'data-carbon--data-table-target'] = 'batchActions'
        attrs
      end
    end

    # A button rendered inside the batch actions bar.
    class BatchActionButtonComponent < BaseComponent
      # @return [String] button label
      attr_reader :label

      # @param label [String] button label text
      # @param system_arguments [Hash] additional HTML attributes
      def initialize(label:, **system_arguments)
        @label = label
        @system_arguments = system_arguments
      end

      def call
        content_tag(:button, @label, class: 'cds--btn cds--btn--primary', type: 'button', **@system_arguments)
      end
    end

    # Search input within the table toolbar.
    class ToolbarSearchComponent < BaseComponent
      # @param placeholder [String] search input placeholder
      # @param system_arguments [Hash] additional HTML attributes
      def initialize(placeholder: 'Filter table', **system_arguments)
        @placeholder = placeholder
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = ['cds--toolbar-search-container-persistent']
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.dup
        attrs[:class] = css_classes
        attrs
      end
    end

    # Table header row containing header cells.
    class HeadComponent < BaseComponent
      renders_many :cells, 'Carbon::DataTableComponent::HeaderCellComponent'

      # @return [Boolean] whether rows are selectable
      attr_reader :selectable
      # @return [Boolean] whether radio selection is used
      attr_reader :radio
      # @return [Boolean] whether rows are expandable
      attr_reader :expandable
      # @return [String, nil] parent table ID
      attr_reader :table_id

      # @param selectable [Boolean] enables select-all checkbox
      # @param radio [Boolean] radio selection mode
      # @param expandable [Boolean] adds expand column
      # @param table_id [String, nil] parent table ID
      # @param system_arguments [Hash] additional HTML attributes
      def initialize(selectable: false, radio: false, expandable: false, table_id: nil, **system_arguments)
        @selectable = selectable
        @radio = radio
        @expandable = expandable
        @table_id = table_id
        @system_arguments = system_arguments
      end
    end

    # A single header cell with optional sorting.
    class HeaderCellComponent < BaseComponent
      SORT_DIRECTIONS = %i[none ascending descending].freeze

      # @return [String, nil] column key for sorting
      attr_reader :key
      # @return [Boolean] whether the column is sortable
      attr_reader :sortable
      # @return [Symbol] current sort direction
      attr_reader :sort_direction

      # @param key [String, nil] column key for sorting
      # @param sortable [Boolean] enables sorting on this column
      # @param sort_direction [Symbol] initial sort (:none, :ascending, :descending)
      # @param system_arguments [Hash] additional HTML attributes
      def initialize(key: nil, sortable: false, sort_direction: :none, **system_arguments)
        @key = key
        @sortable = sortable
        @sort_direction = sort_direction
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = []
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.dup
        attrs[:class] = css_classes unless css_classes.empty?
        attrs[:'aria-sort'] = aria_sort_value if @sortable
        attrs
      end

      def sort_button_classes
        classes = ['cds--table-sort']
        classes << 'cds--table-sort--active' if @sort_direction != :none
        classes << 'cds--table-sort--descending' if @sort_direction == :descending
        class_names(classes)
      end

      def aria_sort_value
        case @sort_direction
        when :ascending then 'ascending'
        when :descending then 'descending'
        else 'none'
        end
      end

      def sort_icon_svg
        if @sort_direction == :none
          arrows_vertical_svg
        else
          arrow_down_svg
        end
      end

      def arrows_vertical_svg
        '<svg focusable="false" preserveAspectRatio="xMidYMid meet" ' \
        'xmlns="http://www.w3.org/2000/svg" fill="currentColor" ' \
        'width="16" height="16" viewBox="0 0 32 32" aria-hidden="true" ' \
        'class="cds--table-sort__icon-unsorted">' \
        '<path d="M27.6 20.6L24 24.2 24 4 22 4 22 24.2 18.4 20.6 17 22 23 28 29 22z"></path>' \
        '<path d="M9 4L3 10 4.4 11.4 8 7.8 8 28 10 28 10 7.8 13.6 11.4 15 10z"></path>' \
        '</svg>'.html_safe
      end

      def arrow_down_svg
        '<svg focusable="false" preserveAspectRatio="xMidYMid meet" ' \
        'xmlns="http://www.w3.org/2000/svg" fill="currentColor" ' \
        'width="16" height="16" viewBox="0 0 32 32" aria-hidden="true" ' \
        'class="cds--table-sort__icon">' \
        '<path d="M24 24.2L20.4 20.6 19 22 25 28 31 22 29.6 20.6 26 24.2 26 4 24 4z"></path>' \
        '</svg>'.html_safe
      end
    end

    # A single data table row with optional selection and expansion.
    class RowComponent < BaseComponent
      renders_many :cells, 'Carbon::DataTableComponent::CellComponent'
      renders_one :expanded_content

      # @return [String] unique row ID
      attr_reader :row_id
      # @return [Boolean] whether the row is selected
      attr_reader :selected
      # @return [Boolean] whether the row is expanded
      attr_reader :expanded
      # @return [Boolean] whether the row is disabled
      attr_reader :disabled
      # @return [Boolean] whether selection is enabled
      attr_reader :selectable
      # @return [Boolean] whether radio selection is used
      attr_reader :radio
      # @return [Boolean] whether the row is expandable
      attr_reader :expandable
      # @return [String, nil] parent table ID
      attr_reader :table_id

      # @param row_id [String, nil] unique row ID
      # @param selected [Boolean] whether the row is selected
      # @param expanded [Boolean] whether the row is expanded
      # @param disabled [Boolean] whether the row is disabled
      # @param selectable [Boolean] enables row selection
      # @param radio [Boolean] radio selection mode
      # @param expandable [Boolean] enables row expansion
      # @param table_id [String, nil] parent table ID
      # @param system_arguments [Hash] additional HTML attributes
      def initialize(
        row_id: nil,
        selected: false,
        expanded: false,
        disabled: false,
        selectable: false,
        radio: false,
        expandable: false,
        table_id: nil,
        **system_arguments
      )
        @row_id = row_id || "row-#{SecureRandom.hex(8)}"
        @selected = selected
        @expanded = expanded
        @disabled = disabled
        @selectable = selectable
        @radio = radio
        @expandable = expandable
        @table_id = table_id
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = []
        classes << 'cds--expandable-row' if @expandable
        classes << 'cds--data-table--selected' if @selected
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.dup
        attrs[:class] = css_classes unless css_classes.empty?
        attrs[:'data-carbon--data-table-target'] = 'row'
        attrs[:'aria-selected'] = @selected.to_s if @selectable || @radio
        attrs
      end

      def expanded_row_id
        "#{@row_id}-expanded"
      end

      def expand_button_svg
        '<svg focusable="false" preserveAspectRatio="xMidYMid meet" ' \
        'xmlns="http://www.w3.org/2000/svg" fill="currentColor" ' \
        'width="16" height="16" viewBox="0 0 16 16" aria-hidden="true" ' \
        'class="cds--table-expand__svg">' \
        '<path d="M11 8L6 13 5.3 12.3 9.6 8 5.3 3.7 6 3z"></path>' \
        '</svg>'.html_safe
      end

      def selection_input_type
        @radio ? 'radio' : 'checkbox'
      end

      def selection_input_name
        @radio ? "#{@table_id}-selection" : "#{@row_id}-select"
      end
    end

    # A single data cell within a table row.
    class CellComponent < BaseComponent
      # @param system_arguments [Hash] additional HTML attributes
      def initialize(**system_arguments)
        @system_arguments = system_arguments
      end

      def call
        content_tag(:td, content, **html_attributes)
      end

      private

      def html_attributes
        @system_arguments.dup
      end
    end
  end
end
