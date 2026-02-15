# frozen_string_literal: true

module Carbon
  class DataTableComponentPreview < ViewComponent::Preview # rubocop:disable Metrics/ClassLength
    # @param size select { choices: [xs, sm, md, lg, xl] }
    # @param zebra toggle
    # @param sticky_header toggle
    def default(size: :lg, zebra: false, sticky_header: false) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      render Carbon::DataTableComponent.new(
        title: 'Users',
        description: 'A list of all users in the system',
        size: size.to_sym,
        zebra: zebra,
        sticky_header: sticky_header
      ) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
          head.with_cell { 'Email' }
          head.with_cell { 'Role' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice Johnson' }
          row.with_cell { 'alice@example.com' }
          row.with_cell { 'Admin' }
        end
        c.with_row do |row|
          row.with_cell { 'Bob Smith' }
          row.with_cell { 'bob@example.com' }
          row.with_cell { 'User' }
        end
        c.with_row do |row|
          row.with_cell { 'Carol Williams' }
          row.with_cell { 'carol@example.com' }
          row.with_cell { 'Editor' }
        end
      end
    end

    def sortable
      render Carbon::DataTableComponent.new(
        title: 'Sortable Table',
        sortable: true
      ) do |c|
        c.with_head do |head|
          head.with_cell(sortable: true, key: 'name') { 'Name' }
          head.with_cell(sortable: true, key: 'email') { 'Email' }
          head.with_cell(sortable: true, key: 'role') { 'Role' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice Johnson' }
          row.with_cell { 'alice@example.com' }
          row.with_cell { 'Admin' }
        end
        c.with_row do |row|
          row.with_cell { 'Bob Smith' }
          row.with_cell { 'bob@example.com' }
          row.with_cell { 'User' }
        end
      end
    end

    def selectable # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      render Carbon::DataTableComponent.new(
        title: 'Selectable Table',
        selectable: true
      ) do |c|
        c.with_toolbar do |toolbar|
          toolbar.with_batch_actions do |batch|
            batch.with_action(label: 'Delete')
            batch.with_action(label: 'Export')
          end
        end
        c.with_head do |head|
          head.with_cell { 'Name' }
          head.with_cell { 'Email' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice Johnson' }
          row.with_cell { 'alice@example.com' }
        end
        c.with_row do |row|
          row.with_cell { 'Bob Smith' }
          row.with_cell { 'bob@example.com' }
        end
        c.with_row do |row|
          row.with_cell { 'Carol Williams' }
          row.with_cell { 'carol@example.com' }
        end
      end
    end

    def radio_selection
      render Carbon::DataTableComponent.new(
        title: 'Radio Selection',
        selectable: true,
        radio: true
      ) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
          head.with_cell { 'Email' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice Johnson' }
          row.with_cell { 'alice@example.com' }
        end
        c.with_row do |row|
          row.with_cell { 'Bob Smith' }
          row.with_cell { 'bob@example.com' }
        end
      end
    end

    def expandable # rubocop:disable Metrics/MethodLength
      render Carbon::DataTableComponent.new(
        title: 'Expandable Table',
        expandable: true
      ) do |c|
        c.with_head do |head|
          head.with_cell { 'Name' }
          head.with_cell { 'Email' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice Johnson' }
          row.with_cell { 'alice@example.com' }
          row.with_expanded_content do
            '<p>Additional details about Alice Johnson. She has been a member since 2020.</p>'.html_safe
          end
        end
        c.with_row do |row|
          row.with_cell { 'Bob Smith' }
          row.with_cell { 'bob@example.com' }
          row.with_expanded_content do
            '<p>Additional details about Bob Smith. He joined in 2021.</p>'.html_safe
          end
        end
      end
    end

    def with_toolbar_search # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      render Carbon::DataTableComponent.new(
        title: 'Searchable Table'
      ) do |c|
        c.with_toolbar do |toolbar|
          toolbar.with_search(placeholder: 'Search users')
        end
        c.with_head do |head|
          head.with_cell { 'Name' }
          head.with_cell { 'Email' }
          head.with_cell { 'Role' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice Johnson' }
          row.with_cell { 'alice@example.com' }
          row.with_cell { 'Admin' }
        end
        c.with_row do |row|
          row.with_cell { 'Bob Smith' }
          row.with_cell { 'bob@example.com' }
          row.with_cell { 'User' }
        end
        c.with_row do |row|
          row.with_cell { 'Carol Williams' }
          row.with_cell { 'carol@example.com' }
          row.with_cell { 'Editor' }
        end
      end
    end

    def full_featured # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      render Carbon::DataTableComponent.new( # rubocop:disable Metrics/BlockLength
        title: 'Full Featured Table',
        description: 'Demonstrating all DataTable features together',
        sortable: true,
        selectable: true,
        expandable: true,
        zebra: true,
        size: :md
      ) do |c|
        c.with_toolbar do |toolbar|
          toolbar.with_batch_actions do |batch|
            batch.with_action(label: 'Delete')
            batch.with_action(label: 'Export')
          end
          toolbar.with_search(placeholder: 'Search')
        end
        c.with_head do |head|
          head.with_cell(sortable: true, key: 'name') { 'Name' }
          head.with_cell(sortable: true, key: 'email') { 'Email' }
          head.with_cell(sortable: true, key: 'role') { 'Role' }
          head.with_cell { 'Status' }
        end
        c.with_row do |row|
          row.with_cell { 'Alice Johnson' }
          row.with_cell { 'alice@example.com' }
          row.with_cell { 'Admin' }
          row.with_cell { 'Active' }
          row.with_expanded_content { '<p>Full profile details for Alice.</p>'.html_safe }
        end
        c.with_row(selected: true) do |row|
          row.with_cell { 'Bob Smith' }
          row.with_cell { 'bob@example.com' }
          row.with_cell { 'User' }
          row.with_cell { 'Active' }
          row.with_expanded_content { '<p>Full profile details for Bob.</p>'.html_safe }
        end
        c.with_row do |row|
          row.with_cell { 'Carol Williams' }
          row.with_cell { 'carol@example.com' }
          row.with_cell { 'Editor' }
          row.with_cell { 'Inactive' }
          row.with_expanded_content { '<p>Full profile details for Carol.</p>'.html_safe }
        end
      end
    end
  end
end
