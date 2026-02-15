# frozen_string_literal: true

module Carbon
  class UIShellComponent < Carbon::BaseComponent
    renders_one :skip_to_content, lambda { |href: '#main-content', text: 'Skip to main content', **system_arguments|
      SkipToContentComponent.new(href: href, text: text, **system_arguments)
    }
    renders_one :header, lambda { |aria_label: nil, **system_arguments|
      HeaderComponent.new(aria_label: aria_label, **system_arguments)
    }
    renders_one :side_nav, lambda { |expanded: false, fixed: false, rail: false,
                                     aria_label: 'Side navigation', **system_arguments|
      SideNavComponent.new(
        expanded: expanded, fixed: fixed, rail: rail,
        aria_label: aria_label, **system_arguments
      )
    }

    def initialize(**system_arguments)
      @system_arguments = system_arguments
    end

    # -- SkipToContentComponent --

    class SkipToContentComponent < Carbon::BaseComponent
      def initialize(href: '#main-content', text: 'Skip to main content', **system_arguments)
        @href = href
        @text = text
        @system_arguments = system_arguments
      end

      def call
        content_tag(:a, @text, href: @href, class: css_classes, tabindex: '0', **filtered_arguments)
      end

      private

      def css_classes
        classes = ['cds--skip-to-content']
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def filtered_arguments
        @system_arguments.except(:class)
      end
    end

    # -- HeaderComponent --

    class HeaderComponent < Carbon::BaseComponent
      renders_one :name, lambda { |href:, prefix: 'IBM', **system_arguments|
        HeaderNameComponent.new(href: href, prefix: prefix, **system_arguments)
      }
      renders_one :nav, lambda { |aria_label: 'Header navigation', **system_arguments|
        HeaderNavComponent.new(aria_label: aria_label, **system_arguments)
      }
      renders_one :global_bar, lambda { |**system_arguments|
        HeaderGlobalBarComponent.new(**system_arguments)
      }
      renders_many :panels, lambda { |expanded: false, panel_id: nil, **system_arguments|
        HeaderPanelComponent.new(expanded: expanded, panel_id: panel_id, **system_arguments)
      }

      def initialize(aria_label: nil, **system_arguments)
        @aria_label = aria_label
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = ['cds--header']
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.except(:class)
        attrs[:class] = css_classes
        attrs[:'aria-label'] = @aria_label if @aria_label
        attrs[:data] ||= {}
        attrs[:data][:controller] = 'carbon--ui-shell--ui-shell'
        attrs
      end
    end

    # -- HeaderNameComponent --

    class HeaderNameComponent < Carbon::BaseComponent
      def initialize(href:, prefix: 'IBM', **system_arguments)
        @href = href
        @prefix = prefix
        @system_arguments = system_arguments
      end

      def call
        content_tag(:a, href: @href, class: css_classes, **filtered_arguments) do
          parts = []
          parts << content_tag(:span, "#{@prefix}\u00a0", class: 'cds--header__name--prefix') if @prefix.present?
          parts << content
          safe_join(parts)
        end
      end

      private

      def css_classes
        classes = ['cds--header__name']
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def filtered_arguments
        @system_arguments.except(:class)
      end
    end

    # -- HeaderNavComponent --

    class HeaderNavComponent < Carbon::BaseComponent
      renders_many :items, types: {
        item: {
          renders: lambda { |label:, href:, active: false, **system_arguments|
            HeaderMenuItemComponent.new(label: label, href: href, active: active, **system_arguments)
          },
          as: :item
        },
        menu: {
          renders: lambda { |label:, **system_arguments|
            HeaderMenuComponent.new(label: label, **system_arguments)
          },
          as: :menu
        }
      }

      def initialize(aria_label: 'Header navigation', **system_arguments)
        @aria_label = aria_label
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = ['cds--header__nav']
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.except(:class)
        attrs[:class] = css_classes
        attrs[:'aria-label'] = @aria_label
        attrs
      end
    end

    # -- HeaderMenuItemComponent --

    class HeaderMenuItemComponent < Carbon::BaseComponent
      def initialize(label:, href:, active: false, **system_arguments)
        @label = label
        @href = href
        @active = active
        @system_arguments = system_arguments
      end

      def call
        content_tag(:li, role: 'none') do
          link_attrs = { class: css_classes, href: @href }
          link_attrs[:'aria-current'] = 'page' if @active
          link_attrs.merge!(filtered_arguments)
          content_tag(:a, **link_attrs) do
            content_tag(:span, @label, class: 'cds--text-truncate--end')
          end
        end
      end

      private

      def css_classes
        classes = ['cds--header__menu-item']
        classes << 'cds--header__menu-item--current' if @active
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def filtered_arguments
        @system_arguments.except(:class)
      end
    end

    # -- HeaderMenuComponent --

    class HeaderMenuComponent < Carbon::BaseComponent
      renders_many :items, lambda { |label:, href:, active: false, **system_arguments|
        HeaderMenuItemComponent.new(label: label, href: href, active: active, **system_arguments)
      }

      def initialize(label:, **system_arguments)
        @label = label
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = ['cds--header__submenu']
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.except(:class)
        attrs[:class] = css_classes
        attrs[:data] ||= {}
        attrs[:data][:controller] = 'carbon--ui-shell--header-menu'
        attrs
      end
    end

    # -- HeaderGlobalBarComponent --

    class HeaderGlobalBarComponent < Carbon::BaseComponent
      renders_many :actions, lambda { |aria_label:, active: false, panel_id: nil, **system_arguments|
        HeaderGlobalActionComponent.new(
          aria_label: aria_label, active: active, panel_id: panel_id, **system_arguments
        )
      }

      def initialize(**system_arguments)
        @system_arguments = system_arguments
      end

      def call
        content_tag(:div, class: css_classes, **filtered_arguments) do
          safe_join(actions)
        end
      end

      private

      def css_classes
        classes = ['cds--header__global']
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def filtered_arguments
        @system_arguments.except(:class)
      end
    end

    # -- HeaderGlobalActionComponent --

    class HeaderGlobalActionComponent < Carbon::BaseComponent
      def initialize(aria_label:, active: false, panel_id: nil, **system_arguments)
        @aria_label = aria_label
        @active = active
        @panel_id = panel_id
        @system_arguments = system_arguments
      end

      def call
        btn_attrs = {
          class: css_classes,
          type: 'button',
          'aria-label': @aria_label,
          'data-action': 'carbon--ui-shell--ui-shell#togglePanel'
        }
        btn_attrs[:'aria-expanded'] = @active.to_s
        btn_attrs[:'aria-controls'] = @panel_id if @panel_id
        btn_attrs.merge!(filtered_arguments)

        content_tag(:button, **btn_attrs) { content }
      end

      private

      def css_classes
        classes = ['cds--header__action']
        classes << 'cds--header__action--active' if @active
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def filtered_arguments
        @system_arguments.except(:class)
      end
    end

    # -- HeaderPanelComponent --

    class HeaderPanelComponent < Carbon::BaseComponent
      renders_one :switcher, lambda { |aria_label:, **system_arguments|
        SwitcherComponent.new(aria_label: aria_label, **system_arguments)
      }

      def initialize(expanded: false, panel_id: nil, **system_arguments)
        @expanded = expanded
        @panel_id = panel_id
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = ['cds--header-panel']
        classes << 'cds--header-panel--expanded' if @expanded
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.except(:class)
        attrs[:class] = css_classes
        attrs[:id] = @panel_id if @panel_id
        attrs
      end
    end

    # -- SwitcherComponent --

    class SwitcherComponent < Carbon::BaseComponent
      renders_many :items, lambda { |href:, selected: false, **system_arguments|
        SwitcherItemComponent.new(href: href, selected: selected, **system_arguments)
      }

      def initialize(aria_label:, **system_arguments)
        @aria_label = aria_label
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = ['cds--switcher']
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.except(:class)
        attrs[:class] = css_classes
        attrs[:'aria-label'] = @aria_label
        attrs
      end
    end

    # -- SwitcherItemComponent --

    class SwitcherItemComponent < Carbon::BaseComponent
      def initialize(href:, selected: false, **system_arguments)
        @href = href
        @selected = selected
        @system_arguments = system_arguments
      end

      def call
        content_tag(:li, class: 'cds--switcher__item') do
          link_classes = ['cds--switcher__item-link']
          link_classes << 'cds--switcher__item-link--selected' if @selected
          link_classes << @system_arguments[:class] if @system_arguments[:class]
          link_attrs = filtered_arguments.merge(href: @href, class: class_names(link_classes))
          link_attrs[:'aria-current'] = 'page' if @selected
          content_tag(:a, **link_attrs) { content }
        end
      end

      private

      def filtered_arguments
        @system_arguments.except(:class)
      end
    end

    # -- SideNavComponent --

    class SideNavComponent < Carbon::BaseComponent
      renders_many :items, types: {
        link: {
          renders: lambda { |label:, href:, active: false, **system_arguments|
            SideNavLinkComponent.new(label: label, href: href, active: active, **system_arguments)
          },
          as: :link
        },
        menu: {
          renders: lambda { |title:, active: false, expanded: false, **system_arguments|
            SideNavMenuComponent.new(title: title, active: active, expanded: expanded, **system_arguments)
          },
          as: :menu
        }
      }

      def initialize(expanded: false, fixed: false, rail: false, aria_label: 'Side navigation',
                     **system_arguments)
        @expanded = expanded
        @fixed = fixed
        @rail = rail
        @aria_label = aria_label
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = ['cds--side-nav', 'cds--side-nav--ux']
        classes << 'cds--side-nav--expanded' if @expanded
        classes << 'cds--side-nav--rail' if @rail
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes # rubocop:disable Metrics/AbcSize
        attrs = @system_arguments.except(:class)
        attrs[:class] = css_classes
        attrs[:'aria-label'] = @aria_label
        attrs[:data] ||= {}
        attrs[:data][:controller] = 'carbon--ui-shell--side-nav'
        attrs[:data][:'carbon--ui-shell--side-nav-expanded-value'] = @expanded.to_s
        attrs[:data][:'carbon--ui-shell--side-nav-rail-value'] = @rail.to_s
        attrs[:data][:'carbon--ui-shell--ui-shell-target'] = 'sideNav'
        attrs
      end

      def overlay_classes
        classes = ['cds--side-nav__overlay']
        classes << 'cds--side-nav__overlay-active' if @expanded
        class_names(classes)
      end
    end

    # -- SideNavLinkComponent --

    class SideNavLinkComponent < Carbon::BaseComponent
      def initialize(label:, href:, active: false, **system_arguments)
        @label = label
        @href = href
        @active = active
        @system_arguments = system_arguments
      end

      def call
        content_tag(:li, class: 'cds--side-nav__item') do
          link_classes = ['cds--side-nav__link']
          link_classes << 'cds--side-nav__link--current' if @active
          link_attrs = { class: class_names(link_classes), href: @href }
          link_attrs[:'aria-current'] = 'page' if @active
          link_attrs.merge!(filtered_arguments)
          content_tag(:a, **link_attrs) do
            content_tag(:span, @label, class: 'cds--side-nav__link-text')
          end
        end
      end

      private

      def filtered_arguments
        @system_arguments.except(:class)
      end
    end

    # -- SideNavMenuComponent --

    class SideNavMenuComponent < Carbon::BaseComponent
      renders_many :items, lambda { |label:, href:, active: false, **system_arguments|
        SideNavMenuItemComponent.new(label: label, href: href, active: active, **system_arguments)
      }

      def initialize(title:, active: false, expanded: false, **system_arguments)
        @title = title
        @active = active
        @expanded = expanded
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = ['cds--side-nav__item']
        classes << 'cds--side-nav__item--active' if @active
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.except(:class)
        attrs[:class] = css_classes
        attrs[:data] ||= {}
        attrs[:data][:controller] = 'carbon--ui-shell--side-nav-menu'
        attrs
      end

      def button_attributes
        {
          class: 'cds--side-nav__submenu',
          type: 'button',
          'aria-expanded': @expanded.to_s,
          'data-action': 'carbon--ui-shell--side-nav-menu#toggle',
          'data-carbon--ui-shell--side-nav-menu-target': 'button'
        }
      end

      attr_reader :title, :expanded
    end

    # -- SideNavMenuItemComponent --

    class SideNavMenuItemComponent < Carbon::BaseComponent
      def initialize(label:, href:, active: false, **system_arguments)
        @label = label
        @href = href
        @active = active
        @system_arguments = system_arguments
      end

      def call
        content_tag(:li, class: 'cds--side-nav__menu-item') do
          link_classes = ['cds--side-nav__link']
          link_classes << 'cds--side-nav__link--current' if @active
          link_attrs = { class: class_names(link_classes), href: @href }
          link_attrs[:'aria-current'] = 'page' if @active
          link_attrs.merge!(filtered_arguments)
          content_tag(:a, **link_attrs) do
            content_tag(:span, @label, class: 'cds--side-nav__link-text')
          end
        end
      end

      private

      def filtered_arguments
        @system_arguments.except(:class)
      end
    end
  end
end
