# frozen_string_literal: true

module Carbon
  class ModalComponentPreview < ViewComponent::Preview
    # @param open toggle
    # @param size select { choices: [xs, sm, md, lg] }
    # @param danger toggle
    def default(open: true, size: :md, danger: false)
      render Carbon::ModalComponent.new(open: open, size: size.to_sym, danger: danger) do |c|
        c.with_header(title: 'Modal heading', subtitle: 'Optional subtitle')
        c.with_body do
          '<p>Modal body content. This is a description of the modal content.</p>'.html_safe
        end
        c.with_footer do
          safe_join(
            [
              '<button class="cds--btn cds--btn--secondary" type="button">Cancel</button>'.html_safe,
              '<button class="cds--btn cds--btn--primary" type="button">Save</button>'.html_safe
            ]
          )
        end
      end
    end

    def danger_modal
      render Carbon::ModalComponent.new(open: true, danger: true) do |c|
        c.with_header(title: 'Delete resource', label: 'Account')
        c.with_body do
          '<p>Are you sure you want to delete this resource? This action cannot be undone.</p>'.html_safe
        end
        c.with_footer do
          safe_join(
            [
              '<button class="cds--btn cds--btn--secondary" type="button">Cancel</button>'.html_safe,
              '<button class="cds--btn cds--btn--danger" type="button">Delete</button>'.html_safe
            ]
          )
        end
      end
    end

    def small_modal
      render Carbon::ModalComponent.new(open: true, size: :sm) do |c|
        c.with_header(title: 'Small modal')
        c.with_body do
          '<p>This is a small modal with less content.</p>'.html_safe
        end
        c.with_footer do
          safe_join(
            [
              '<button class="cds--btn cds--btn--secondary" type="button">Cancel</button>'.html_safe,
              '<button class="cds--btn cds--btn--primary" type="button">OK</button>'.html_safe
            ]
          )
        end
      end
    end

    def large_modal
      render Carbon::ModalComponent.new(open: true, size: :lg) do |c|
        c.with_header(title: 'Large modal', subtitle: 'This modal has more room for content')
        c.with_body do
          '<p>This large modal can accommodate more content. ' \
          'Use it when you need to display forms, tables, or other complex content.</p>' \
          '<p>You can include multiple paragraphs and other HTML elements.</p>'.html_safe
        end
        c.with_footer do
          safe_join(
            [
              '<button class="cds--btn cds--btn--secondary" type="button">Cancel</button>'.html_safe,
              '<button class="cds--btn cds--btn--primary" type="button">Save</button>'.html_safe
            ]
          )
        end
      end
    end

    def with_label
      render Carbon::ModalComponent.new(open: true) do |c|
        c.with_header(title: 'Modal heading', label: 'Account resources')
        c.with_body do
          '<p>Modal content with a label above the title.</p>'.html_safe
        end
        c.with_footer do
          '<button class="cds--btn cds--btn--primary" type="button">Done</button>'.html_safe
        end
      end
    end

    def passive_modal
      render Carbon::ModalComponent.new(open: true) do |c|
        c.with_header(title: 'Passive modal')
        c.with_body do
          '<p>This modal has no footer actions. It is a passive, informational modal.</p>'.html_safe
        end
      end
    end

    def prevent_close_on_click_outside
      render Carbon::ModalComponent.new(open: true, prevent_close_on_click_outside: true) do |c|
        c.with_header(title: 'Persistent modal')
        c.with_body do
          '<p>Clicking outside this modal will not close it.</p>'.html_safe
        end
        c.with_footer do
          '<button class="cds--btn cds--btn--primary" type="button">Acknowledge</button>'.html_safe
        end
      end
    end
  end
end
