# frozen_string_literal: true

require "test_helper"

module Carbon
  class ButtonComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test "renders default button" do
      render_inline(Carbon::ButtonComponent.new) { "Click me" }

      assert_selector "button.cds--btn.cds--btn--primary.cds--btn--lg", text: "Click me"
      assert_selector "button[type='button']"
    end

    test "renders content inside cds--btn__content span" do
      render_inline(Carbon::ButtonComponent.new) { "Label" }

      assert_selector "button .cds--btn__content", text: "Label"
    end

    # -- Kinds --

    test "renders primary kind" do
      render_inline(Carbon::ButtonComponent.new(kind: :primary)) { "Primary" }

      assert_selector "button.cds--btn--primary"
    end

    test "renders secondary kind" do
      render_inline(Carbon::ButtonComponent.new(kind: :secondary)) { "Secondary" }

      assert_selector "button.cds--btn--secondary"
    end

    test "renders tertiary kind" do
      render_inline(Carbon::ButtonComponent.new(kind: :tertiary)) { "Tertiary" }

      assert_selector "button.cds--btn--tertiary"
    end

    test "renders ghost kind" do
      render_inline(Carbon::ButtonComponent.new(kind: :ghost)) { "Ghost" }

      assert_selector "button.cds--btn--ghost"
    end

    test "renders danger kind" do
      render_inline(Carbon::ButtonComponent.new(kind: :danger)) { "Danger" }

      assert_selector "button.cds--btn--danger"
    end

    test "renders danger_tertiary kind" do
      render_inline(Carbon::ButtonComponent.new(kind: :danger_tertiary)) { "Danger Tertiary" }

      assert_selector "button.cds--btn--danger--tertiary"
    end

    test "renders danger_ghost kind" do
      render_inline(Carbon::ButtonComponent.new(kind: :danger_ghost)) { "Danger Ghost" }

      assert_selector "button.cds--btn--danger--ghost"
    end

    # -- Sizes --

    test "renders sm size" do
      render_inline(Carbon::ButtonComponent.new(size: :sm)) { "Small" }

      assert_selector "button.cds--btn--sm"
    end

    test "renders md size" do
      render_inline(Carbon::ButtonComponent.new(size: :md)) { "Medium" }

      assert_selector "button.cds--btn--md"
    end

    test "renders lg size (default)" do
      render_inline(Carbon::ButtonComponent.new) { "Large" }

      assert_selector "button.cds--btn--lg"
    end

    test "renders xl size" do
      render_inline(Carbon::ButtonComponent.new(size: :xl)) { "XL" }

      assert_selector "button.cds--btn--xl"
    end

    test "renders 2xl size" do
      render_inline(Carbon::ButtonComponent.new(size: :"2xl")) { "2XL" }

      assert_selector "button.cds--btn--2xl"
    end

    # -- Disabled --

    test "renders disabled button with disabled attribute and CSS class" do
      render_inline(Carbon::ButtonComponent.new(disabled: true)) { "Disabled" }

      assert_selector "button.cds--btn--disabled[disabled]"
    end

    test "renders disabled link with aria-disabled instead of disabled attribute" do
      render_inline(Carbon::ButtonComponent.new(href: "/test", disabled: true)) { "Disabled Link" }

      assert_selector "a.cds--btn--disabled[aria-disabled='true']"
      assert_no_selector "a[disabled]"
      assert_selector "a[tabindex='-1']"
    end

    # -- Link variant (href) --

    test "renders as anchor tag when href is provided" do
      render_inline(Carbon::ButtonComponent.new(href: "/some-path")) { "Link Button" }

      assert_selector "a.cds--btn[href='/some-path'][role='button']", text: "Link Button"
      assert_no_selector "a[type]"
    end

    test "renders as button when href is not provided" do
      render_inline(Carbon::ButtonComponent.new) { "Button" }

      assert_selector "button.cds--btn[type='button']"
      assert_no_selector "button[href]"
    end

    # -- Type --

    test "renders submit type" do
      render_inline(Carbon::ButtonComponent.new(type: :submit)) { "Submit" }

      assert_selector "button[type='submit']"
    end

    test "renders reset type" do
      render_inline(Carbon::ButtonComponent.new(type: :reset)) { "Reset" }

      assert_selector "button[type='reset']"
    end

    # -- Icon --

    test "renders with icon slot" do
      render_inline(Carbon::ButtonComponent.new) do |c|
        c.with_icon { "<svg>icon</svg>".html_safe }
        "With Icon"
      end

      assert_selector ".cds--btn__icon svg"
    end

    # -- Icon-only --

    test "renders icon-only button with CSS class" do
      render_inline(Carbon::ButtonComponent.new(icon_only: true, icon_description: "Close")) do |c|
        c.with_icon { "<svg>X</svg>".html_safe }
      end

      assert_selector "button.cds--btn--icon-only[aria-label='Close']"
    end

    test "icon-only button has aria-label from icon_description" do
      render_inline(Carbon::ButtonComponent.new(icon_only: true, icon_description: "Add item")) do |c|
        c.with_icon { "<svg>+</svg>".html_safe }
      end

      assert_selector "button[aria-label='Add item']"
    end

    # -- System arguments --

    test "passes through system arguments as HTML attributes" do
      render_inline(Carbon::ButtonComponent.new(id: "my-btn", data: { testid: "button-1" })) { "Test" }

      assert_selector "button#my-btn[data-testid='button-1']"
    end

    test "merges custom class with component classes" do
      render_inline(Carbon::ButtonComponent.new(class: "my-custom-class")) { "Custom" }

      assert_selector "button.cds--btn.my-custom-class"
    end

    # -- Validation --

    test "raises ArgumentError for invalid kind" do
      assert_raises(ArgumentError) do
        Carbon::ButtonComponent.new(kind: :invalid)
      end
    end

    test "raises ArgumentError for invalid size" do
      assert_raises(ArgumentError) do
        Carbon::ButtonComponent.new(size: :invalid)
      end
    end

    test "raises ArgumentError for invalid type" do
      assert_raises(ArgumentError) do
        Carbon::ButtonComponent.new(type: :invalid)
      end
    end

    # -- String arguments --

    test "accepts string values for kind" do
      render_inline(Carbon::ButtonComponent.new(kind: "secondary")) { "String Kind" }

      assert_selector "button.cds--btn--secondary"
    end

    test "accepts string values for size" do
      render_inline(Carbon::ButtonComponent.new(size: "sm")) { "String Size" }

      assert_selector "button.cds--btn--sm"
    end
  end
end
