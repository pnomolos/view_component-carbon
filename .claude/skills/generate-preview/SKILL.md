# Generate Preview

Generate a Lookbook preview file for an existing Carbon ViewComponent.

## Usage

`/generate-preview <ComponentName>`

Example: `/generate-preview Accordion`

## Instructions

### 1. Read the existing component

Read `app/components/carbon/<name>_component.rb` to understand:
- All initialize parameters and their allowed values
- Slots defined on the component
- Content patterns

### 2. Read existing preview patterns

Read an existing preview file (e.g., `previews/carbon/button_component_preview.rb`) for conventions.

### 3. Create the preview file

Create `previews/carbon/<name>_component_preview.rb`:

```ruby
# frozen_string_literal: true

module Carbon
  class <Name>ComponentPreview < ViewComponent::Preview
    # @param <param_name> select { choices: [option1, option2] }
    def default(<param_name>: :<default>)
      render Carbon::<Name>Component.new(<param_name>: <param_name>.to_sym) do
        "Content"
      end
    end

    # Additional preview methods for each major variant
    # def variant_name ...
  end
end
```

Key conventions:
- Use `@param` annotations for Lookbook interactive controls
- Use `select` for enum params with `{ choices: [...] }`
- Use `toggle` for boolean params
- Use `text` for string params
- Create a `default` method showing the most common usage
- Create additional methods for notable variants or combinations
- Include realistic sample content
