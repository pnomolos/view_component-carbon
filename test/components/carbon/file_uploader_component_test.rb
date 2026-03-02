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

    # -- P0: ARIA live region --

    test 'renders ARIA live region for status announcements' do
      render_inline(Carbon::FileUploaderComponent.new)

      assert_selector(
        '[aria-live="polite"][aria-atomic="true"].cds--visually-hidden[data-carbon--file-uploader-target="liveRegion"]'
      )
    end

    # -- P0: Drag-drop ARIA --

    test 'renders aria-describedby for drop container' do
      render_inline(Carbon::FileUploaderComponent.new(drop_container: true))

      button = page.find('button.cds--file__drop-container')
      instructions_id = button['aria-describedby']

      assert_predicate instructions_id, :present?
      assert_selector "##{instructions_id}.cds--visually-hidden", text: /Drag and drop/
    end

    test 'renders visually hidden instructions for screen readers' do
      render_inline(Carbon::FileUploaderComponent.new(drop_container: true))

      assert_selector '.cds--visually-hidden',
                      text: 'Drag and drop files here or activate to browse and select files to upload'
    end

    test 'does not render drag-drop instructions for button variant' do
      render_inline(Carbon::FileUploaderComponent.new(drop_container: false))

      assert_no_selector '[id$="-instructions"]'
    end

    # -- P1: Button size class logic --

    test 'includes size class for sm size' do
      render_inline(Carbon::FileUploaderComponent.new(size: :sm))

      assert_selector 'label.cds--btn.cds--btn--sm'
    end

    test 'includes size class for md size' do
      render_inline(Carbon::FileUploaderComponent.new(size: :md))

      assert_selector 'label.cds--btn.cds--btn--md'
    end

    test 'includes size class for lg size' do
      render_inline(Carbon::FileUploaderComponent.new(size: :lg))

      assert_selector 'label.cds--btn.cds--btn--lg'
    end

    # -- P1: Name prop --

    test 'does not render name attribute when not provided' do
      render_inline(Carbon::FileUploaderComponent.new)

      assert_no_selector 'input[name]'
    end

    test 'renders name attribute when provided' do
      render_inline(Carbon::FileUploaderComponent.new(name: 'file_upload'))

      assert_selector 'input[name="file_upload"]'
    end

    test 'supports name for form submission with multiple files' do
      render_inline(Carbon::FileUploaderComponent.new(name: 'attachments[]', multiple: true))

      assert_selector 'input[name="attachments[]"][multiple]'
    end

    # -- File uploader items --

    test 'renders a file item with edit state by default' do
      render_inline(Carbon::FileUploaderComponent.new) do |uploader|
        uploader.with_item(name: 'report.pdf')
      end

      assert_selector '.cds--file-container .cds--file__selected-file'
      assert_selector 'p.cds--file-filename', text: 'report.pdf'
      assert_selector 'button.cds--file-close[type="button"]'
    end

    test 'renders a file item with uploading state' do
      render_inline(Carbon::FileUploaderComponent.new) do |uploader|
        uploader.with_item(name: 'uploading.pdf', state: :uploading)
      end

      assert_selector '.cds--file__selected-file[data-file-state="uploading"]'
      assert_selector '.cds--loading.cds--loading--small'
      assert_selector '.cds--loading__svg'
      assert_no_selector 'button.cds--file-close'
      assert_no_selector '.cds--file-complete'
    end

    test 'renders a file item with complete state' do
      render_inline(Carbon::FileUploaderComponent.new) do |uploader|
        uploader.with_item(name: 'done.pdf', state: :complete)
      end

      assert_selector '.cds--file__selected-file[data-file-state="complete"]'
      assert_selector 'svg.cds--file-complete'
      assert_no_selector 'button.cds--file-close'
      assert_no_selector '.cds--loading'
    end

    test 'renders a file item with invalid state and error messages' do
      render_inline(Carbon::FileUploaderComponent.new) do |uploader|
        uploader.with_item(
          name: 'bad.exe',
          invalid: true,
          error_subject: 'Invalid file type',
          error_body: 'Only PDF files are accepted'
        )
      end

      assert_selector '.cds--file__selected-file.cds--file__selected-file--invalid'
      assert_selector '.cds--form-requirement'
      assert_selector '.cds--form-requirement__title', text: 'Invalid file type'
      assert_selector '.cds--form-requirement__supplement', text: 'Only PDF files are accepted'
    end

    test 'renders invalid item without error messages when no subject or body' do
      render_inline(Carbon::FileUploaderComponent.new) do |uploader|
        uploader.with_item(name: 'bad.exe', invalid: true)
      end

      assert_selector '.cds--file__selected-file.cds--file__selected-file--invalid'
      assert_no_selector '.cds--form-requirement'
    end

    test 'renders item size class from parent' do
      render_inline(Carbon::FileUploaderComponent.new(size: :sm)) do |uploader|
        uploader.with_item(name: 'small.pdf')
      end

      assert_selector '.cds--file__selected-file.cds--file__selected-file--sm'
    end

    test 'renders item with md size class' do
      render_inline(Carbon::FileUploaderComponent.new(size: :md)) do |uploader|
        uploader.with_item(name: 'medium.pdf')
      end

      assert_selector '.cds--file__selected-file.cds--file__selected-file--md'
    end

    test 'does not render size class for lg items' do
      render_inline(Carbon::FileUploaderComponent.new(size: :lg)) do |uploader|
        uploader.with_item(name: 'large.pdf')
      end

      assert_selector '.cds--file__selected-file'
      assert_no_selector '.cds--file__selected-file--lg'
    end

    test 'renders remove button with accessible aria-label including file name' do
      render_inline(Carbon::FileUploaderComponent.new) do |uploader|
        uploader.with_item(name: 'doc.pdf', state: :edit)
      end

      assert_selector 'button.cds--file-close[aria-label="Remove file - doc.pdf"]'
    end

    test 'renders remove button with custom icon description including file name' do
      render_inline(Carbon::FileUploaderComponent.new) do |uploader|
        uploader.with_item(name: 'doc.pdf', state: :edit, icon_description: 'Delete')
      end

      assert_selector 'button.cds--file-close[aria-label="Delete - doc.pdf"]'
    end

    test 'renders file name correctly' do
      render_inline(Carbon::FileUploaderComponent.new) do |uploader|
        uploader.with_item(name: 'my-important-document.pdf')
      end

      assert_selector 'p.cds--file-filename', text: 'my-important-document.pdf'
    end

    test 'renders multiple pre-populated items' do
      render_inline(Carbon::FileUploaderComponent.new) do |uploader|
        uploader.with_item(name: 'file1.pdf', state: :complete)
        uploader.with_item(name: 'file2.pdf', state: :edit)
        uploader.with_item(name: 'file3.pdf', state: :uploading)
      end

      assert_selector '.cds--file__selected-file', count: 3
      assert_selector 'p.cds--file-filename', text: 'file1.pdf'
      assert_selector 'p.cds--file-filename', text: 'file2.pdf'
      assert_selector 'p.cds--file-filename', text: 'file3.pdf'
    end

    test 'items render inside the file container' do
      render_inline(Carbon::FileUploaderComponent.new) do |uploader|
        uploader.with_item(name: 'test.pdf')
      end

      assert_selector '.cds--file-container > .cds--file__selected-file'
    end

    test 'renders item with data-file-uuid attribute' do
      render_inline(Carbon::FileUploaderComponent.new) do |uploader|
        uploader.with_item(name: 'test.pdf', uuid: 'custom-uuid-123')
      end

      assert_selector '.cds--file__selected-file[data-file-uuid="custom-uuid-123"]'
    end

    test 'generates uuid when not provided' do
      render_inline(Carbon::FileUploaderComponent.new) do |uploader|
        uploader.with_item(name: 'test.pdf')
      end

      item = page.find('.cds--file__selected-file')

      assert_predicate item['data-file-uuid'], :present?
    end

    test 'raises ArgumentError for invalid item state' do
      assert_raises(ArgumentError) do
        Carbon::FileUploaderComponent::ItemComponent.new(name: 'test.pdf', state: :invalid)
      end
    end

    test 'renders uploading item with loading label' do
      render_inline(Carbon::FileUploaderComponent.new) do |uploader|
        uploader.with_item(name: 'test.pdf', state: :uploading)
      end

      assert_selector '.cds--loading .cds--visually-hidden', text: 'Loading'
    end

    test 'renders uploading item with custom icon description' do
      render_inline(Carbon::FileUploaderComponent.new) do |uploader|
        uploader.with_item(name: 'test.pdf', state: :uploading, icon_description: 'Uploading test.pdf')
      end

      assert_selector '.cds--loading .cds--visually-hidden', text: 'Uploading test.pdf'
    end

    test 'renders remove button with stimulus action for server items' do
      render_inline(Carbon::FileUploaderComponent.new) do |uploader|
        uploader.with_item(name: 'test.pdf', state: :edit)
      end

      assert_selector 'button.cds--file-close[data-action="click->carbon--file-uploader#removeServerItem"]'
    end

    # -- P1: Warning icon for invalid edit state --

    test 'renders warning icon when item is invalid in edit state' do
      render_inline(Carbon::FileUploaderComponent.new) do |uploader|
        uploader.with_item(name: 'bad.exe', state: :edit, invalid: true, error_subject: 'Error')
      end

      assert_selector 'svg.cds--file-invalid[aria-hidden="true"]'
    end

    test 'does not render warning icon when item is valid in edit state' do
      render_inline(Carbon::FileUploaderComponent.new) do |uploader|
        uploader.with_item(name: 'good.pdf', state: :edit)
      end

      assert_no_selector 'svg.cds--file-invalid'
    end

    # -- P1: Error container role="alert" --

    test 'error container has role alert' do
      render_inline(Carbon::FileUploaderComponent.new) do |uploader|
        uploader.with_item(name: 'bad.exe', invalid: true, error_subject: 'Error')
      end

      assert_selector '.cds--form-requirement[role="alert"]'
    end

    test 'error container has matching id for aria-describedby' do
      render_inline(Carbon::FileUploaderComponent.new) do |uploader|
        uploader.with_item(name: 'bad.exe', invalid: true, error_subject: 'Error')
      end

      item = page.find('.cds--file__selected-file')
      uuid = item['data-file-uuid']

      assert_selector ".cds--form-requirement##{uuid}-error"
      assert_selector "button.cds--file-close[aria-describedby='#{uuid}-error']"
    end

    # -- P2: cds--file-loading class --

    test 'uploading state includes cds--file-loading class' do
      render_inline(Carbon::FileUploaderComponent.new) do |uploader|
        uploader.with_item(name: 'test.pdf', state: :uploading)
      end

      assert_selector '.cds--loading.cds--file-loading'
    end

    # -- P2: Drop container hidden label --

    test 'drop container has visually hidden label for input' do
      render_inline(Carbon::FileUploaderComponent.new(drop_container: true))

      input = page.find('input[type="file"]')

      assert_selector "label.cds--visually-hidden[for='#{input[:id]}']"
    end

    # -- P2: Expanded button kinds --

    test 'renders secondary kind' do
      render_inline(Carbon::FileUploaderComponent.new(kind: :secondary))

      assert_selector 'label.cds--btn--secondary'
    end

    test 'renders ghost kind' do
      render_inline(Carbon::FileUploaderComponent.new(kind: :ghost))

      assert_selector 'label.cds--btn--ghost'
    end

    # -- P2: max_file_size prop --

    test 'renders max_file_size as stimulus data value' do
      render_inline(Carbon::FileUploaderComponent.new(max_file_size: 500_000))

      assert_selector '[data-carbon--file-uploader-max-file-size-value="500000"]'
    end

    test 'does not render max_file_size when not provided' do
      render_inline(Carbon::FileUploaderComponent.new)

      assert_no_selector '[data-carbon--file-uploader-max-file-size-value]'
    end

    # -- P3: Complete checkmark tabindex --

    test 'complete state checkmark has tabindex -1' do
      render_inline(Carbon::FileUploaderComponent.new) do |uploader|
        uploader.with_item(name: 'done.pdf', state: :complete)
      end

      assert_selector 'svg.cds--file-complete[tabindex="-1"]'
    end
  end
end
