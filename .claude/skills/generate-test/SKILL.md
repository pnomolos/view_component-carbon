# Generate Test

Generate a Minitest test file for an existing Carbon ViewComponent.

## Usage

`/generate-test <ComponentName>`

Example: `/generate-test Accordion`

## Instructions

### 1. Read the existing component

Read `app/components/carbon/<name>_component.rb` and its ERB template to understand:
- All initialize parameters and their allowed values
- Slots defined on the component
- CSS classes generated for each variant
- ARIA attributes included

### 2. Read existing test patterns

Read an existing test file (e.g., `test/components/carbon/button_component_test.rb`) for conventions.

### 3. Create the test file

Create `test/components/carbon/<name>_component_test.rb`:

```ruby
# frozen_string_literal: true

require "test_helper"

module Carbon
  class <Name>ComponentTest < CarbonViewComponents::TestCase
    # Test default rendering
    # Test each variant/kind renders correct CSS classes
    # Test each size option
    # Test disabled state (if applicable)
    # Test ARIA attributes are present and correct
    # Test slot content renders
    # Test system_arguments passthrough
    # Test validation of invalid enum values
  end
end
```

### 4. Verify

Run `bundle exec ruby -Itest test/components/carbon/<name>_component_test.rb` to verify all tests pass.
