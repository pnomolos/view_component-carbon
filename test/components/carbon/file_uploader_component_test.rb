# frozen_string_literal: true

require 'test_helper'

module Carbon
  class FileUploaderComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default file uploader' do
      render_inline(Carbon::FileUploaderComponent.new)

      assert_selector '.cds--form-item'
      assert_selector 'p.cds--file--label', text: 'Upload files'
      assert_selector '.cds--file[data-controller="carbon--file-uploader"]'
      assert_selector 'label.cds--btn.cds--btn--primary', text: 'Add file'
      assert_selector 'input[type="file"].cds--visually-hidden'
      assert_selector '.cds--file-container[data-carbon--file-uploader-target="fileList"]'
    end

    test 'input has generated id and label for attribute matches' do
      render_inline(Carbon::FileUploaderComponent.new)

      input = page.find('input[type="file"]')
      label = page.find('label.cds--btn')

      assert_predicate input[:id], :present?
      assert_equal input[:id], label[:for]
    end

    # -- Label title and description --

    test 'renders label title' do
      render_inline(Carbon::FileUploaderComponent.new(label_title: 'Upload images'))

      assert_selector 'p.cds--file--label', text: 'Upload images'
    end

    test 'renders label description' do
      render_inline(Carbon::FileUploaderComponent.new(label_description: 'Max file size is 500mb.'))

      assert_selector 'p.cds--label-description', text: 'Max file size is 500mb.'
    end

    test 'does not render label description when not provided' do
      render_inline(Carbon::FileUploaderComponent.new)

      assert_no_selector 'p.cds--label-description'
    end

    # -- Button label --

    test 'renders custom button label' do
      render_inline(Carbon::FileUploaderComponent.new(button_label: 'Choose file'))

      assert_selector 'label.cds--btn', text: 'Choose file'
    end

    # -- Accept --

    test 'renders accept attribute from array' do
      render_inline(Carbon::FileUploaderComponent.new(accept: ['.jpg', '.png']))

      assert_selector 'input[accept=".jpg,.png"]'
    end

    test 'does not render accept when not provided' do
      render_inline(Carbon::FileUploaderComponent.new)

      assert_no_selector 'input[accept]'
    end

    # -- Multiple --

    test 'renders without multiple by default' do
      render_inline(Carbon::FileUploaderComponent.new)

      assert_no_selector 'input[multiple]'
    end

    test 'renders with multiple when enabled' do
      render_inline(Carbon::FileUploaderComponent.new(multiple: true))

      assert_selector 'input[multiple]'
    end

    # -- Disabled --

    test 'renders enabled by default' do
      render_inline(Carbon::FileUploaderComponent.new)

      assert_no_selector 'input[disabled]'
    end

    test 'renders disabled when disabled is true' do
      render_inline(Carbon::FileUploaderComponent.new(disabled: true))

      assert_selector 'input[disabled]'
    end

    test 'renders disabled description class when disabled' do
      render_inline(Carbon::FileUploaderComponent.new(disabled: true, label_description: 'Description'))

      assert_selector 'p.cds--label-description.cds--label-description--disabled'
    end

    # -- Sizes --

    test 'renders md size by default' do
      render_inline(Carbon::FileUploaderComponent.new)

      assert_selector '[data-carbon--file-uploader-size-value="md"]'
    end

    test 'renders sm size' do
      render_inline(Carbon::FileUploaderComponent.new(size: :sm))

      assert_selector '[data-carbon--file-uploader-size-value="sm"]'
    end

    # -- Kind --

    test 'renders primary kind by default' do
      render_inline(Carbon::FileUploaderComponent.new)

      assert_selector 'label.cds--btn--primary'
    end

    test 'renders tertiary kind' do
      render_inline(Carbon::FileUploaderComponent.new(kind: :tertiary))

      assert_selector 'label.cds--btn--tertiary'
    end

    # -- Drop container --

    test 'renders button variant by default' do
      render_inline(Carbon::FileUploaderComponent.new)

      assert_selector 'label.cds--btn'
      assert_no_selector 'button.cds--file__drop-container'
    end

    test 'renders drop container variant' do
      render_inline(Carbon::FileUploaderComponent.new(drop_container: true))

      assert_no_selector 'label.cds--btn'
      assert_selector 'button.cds--file__drop-container.cds--file-browse-btn'
    end

    test 'renders drop container disabled class when disabled' do
      render_inline(Carbon::FileUploaderComponent.new(drop_container: true, disabled: true))

      assert_selector 'button.cds--file-browse-btn--disabled[disabled]'
    end

    # -- Stimulus controller --

    test 'renders stimulus controller data attributes' do
      render_inline(Carbon::FileUploaderComponent.new)

      assert_selector '.cds--file[data-controller="carbon--file-uploader"]'
      assert_selector 'input[data-action="change->carbon--file-uploader#handleChange"]'
      assert_selector 'input[data-carbon--file-uploader-target="input"]'
    end

    # -- Custom ID --

    test 'uses custom id when provided' do
      render_inline(Carbon::FileUploaderComponent.new(id: 'my-uploader'))

      assert_selector 'input#my-uploader'
      assert_selector 'label[for="my-uploader"]'
    end

    # -- Validation --

    test 'raises ArgumentError for invalid size' do
      assert_raises(ArgumentError) do
        Carbon::FileUploaderComponent.new(size: :invalid)
      end
    end

    test 'raises ArgumentError for invalid kind' do
      assert_raises(ArgumentError) do
        Carbon::FileUploaderComponent.new(kind: :invalid)
      end
    end

    test 'accepts string values for size' do
      render_inline(Carbon::FileUploaderComponent.new(size: 'sm'))

      assert_selector '[data-carbon--file-uploader-size-value="sm"]'
    end

    test 'accepts string values for kind' do
      render_inline(Carbon::FileUploaderComponent.new(kind: 'tertiary'))

      assert_selector 'label.cds--btn--tertiary'
    end

    # -- System arguments --

    test 'merges custom class with component classes' do
      render_inline(Carbon::FileUploaderComponent.new(class: 'my-custom-class'))

      assert_selector '.cds--form-item.my-custom-class'
    end
  end
end
