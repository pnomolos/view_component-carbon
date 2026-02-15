# Carbon ViewComponents

[![Gem Version](https://badge.fury.io/rb/carbon_view_components.svg)](https://rubygems.org/gems/carbon_view_components)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

ViewComponent implementations of [IBM's Carbon Design System](https://carbondesignsystem.com) for Ruby on Rails. Built with [ViewComponent](https://viewcomponent.org), styled by `@carbon/styles`, and interactive via Stimulus controllers (with optional WebComponent support).

## Installation

Add the gem to your Gemfile:

```ruby
gem 'carbon_view_components'
```

Then run the install generator:

```bash
bundle install
rails generate carbon_view_components:install
```

### Prerequisites

- Ruby 3.2+
- Rails 7.2+
- Node.js (for `@carbon/styles`)
- [dartsass-rails](https://github.com/rails/dartsass-rails) (for SCSS compilation)

### Manual Setup

If you prefer to configure things yourself instead of running the generator, here is what it does:

1. **Install `@carbon/styles`** via your preferred package manager:

   ```bash
   pnpm add @carbon/styles
   # or: yarn add @carbon/styles
   # or: npm install @carbon/styles
   ```

2. **Import Carbon styles** in your application stylesheet (e.g. `app/assets/stylesheets/application.scss`):

   ```scss
   @use '@carbon/styles';
   ```

3. **Configure importmap pins** for the bundled Stimulus controllers. Add the following to `config/importmap.rb`:

   ```ruby
   pin_all_from CarbonViewComponents::Engine.root.join("app/assets/javascripts/carbon"),
                under: "controllers/carbon",
                to: "carbon"
   ```

4. **Mount the engine** (optional, for Lookbook previews in development):

   ```ruby
   # config/routes.rb
   mount Lookbook::Engine, at: "/lookbook" if Rails.env.development?
   ```

## Usage

### Basic Components

Render a primary button:

```erb
<%= render Carbon::ButtonComponent.new(kind: :primary) do %>
  Click me
<% end %>
```

Render a danger button as a link:

```erb
<%= render Carbon::ButtonComponent.new(kind: :danger, href: "/delete") do %>
  Delete
<% end %>
```

Button kinds: `:primary`, `:secondary`, `:tertiary`, `:ghost`, `:danger`, `:danger_tertiary`, `:danger_ghost`

Button sizes: `:sm`, `:md`, `:lg`, `:xl`, `:"2xl"`

### Components with Slots

Build an accordion with expandable items:

```erb
<%= render Carbon::AccordionComponent.new do |accordion| %>
  <% accordion.with_item(title: "Section 1") do %>
    Content for section 1
  <% end %>
  <% accordion.with_item(title: "Section 2") do %>
    Content for section 2
  <% end %>
  <% accordion.with_item(title: "Section 3", open: true) do %>
    This section starts expanded
  <% end %>
<% end %>
```

### Form Components

Render a text input with validation:

```erb
<%= render Carbon::TextInputComponent.new(
  label_text: "Email",
  name: "email",
  invalid: true,
  invalid_text: "Please enter a valid email"
) %>
```

Render a dropdown:

```erb
<%= render Carbon::DropdownComponent.new(
  label: "Choose a plan",
  title_text: "Plan"
) do |dropdown| %>
  <% dropdown.with_item(value: "free", label: "Free") %>
  <% dropdown.with_item(value: "pro", label: "Pro") %>
  <% dropdown.with_item(value: "enterprise", label: "Enterprise") %>
<% end %>
```

### Complex Components

Render a data table with sorting and selection:

```erb
<%= render Carbon::DataTableComponent.new(
  title: "Users",
  sortable: true,
  selectable: true
) do |table| %>
  <% table.with_head do |head| %>
    <% head.with_cell(sortable: true, key: "name") { "Name" } %>
    <% head.with_cell(sortable: true, key: "email") { "Email" } %>
    <% head.with_cell { "Role" } %>
  <% end %>
  <% @users.each do |user| %>
    <% table.with_row do |row| %>
      <% row.with_cell { user.name } %>
      <% row.with_cell { user.email } %>
      <% row.with_cell { user.role } %>
    <% end %>
  <% end %>
<% end %>
```

Data table features: sorting, row selection (checkbox or radio), expandable rows, batch actions, toolbar search, zebra striping, sticky headers.

## Available Components

### Layout

| Component | Description |
|-----------|-------------|
| `UIShellComponent` | Application shell with header, side navigation, and panels |

### Content

| Component | Description |
|-----------|-------------|
| `AccordionComponent` | Expandable/collapsible content sections |
| `BreadcrumbComponent` | Navigation breadcrumb trail |
| `CodeSnippetComponent` | Inline, single-line, and multi-line code display |
| `ListComponent` | Ordered and unordered lists |
| `StructuredListComponent` | Tabular data in a structured layout |
| `ContainedListComponent` | List with a visible container and header |
| `TabsComponent` | Tabbed content navigation |
| `ContentSwitcherComponent` | Toggle between content views |
| `TreeViewComponent` | Hierarchical tree navigation |
| `TileComponent` | Read-only content tile |
| `ClickableTileComponent` | Tile that acts as a link |
| `SelectableTileComponent` | Tile with selection state |
| `ExpandableTileComponent` | Tile with expandable content |
| `TileGroupComponent` | Group of radio-selectable tiles |

### Data Display

| Component | Description |
|-----------|-------------|
| `DataTableComponent` | Full-featured data table with sorting, selection, expansion, and toolbar |
| `TagComponent` | Categorical labels and filters |
| `BadgeComponent` | Numeric status indicators |
| `ProgressBarComponent` | Determinate progress indicator |
| `ProgressIndicatorComponent` | Multi-step progress tracker |

### Forms

| Component | Description |
|-----------|-------------|
| `ButtonComponent` | Primary action trigger with multiple variants |
| `TextInputComponent` | Single-line text input with label and validation |
| `NumberInputComponent` | Numeric input with increment/decrement controls |
| `TextAreaComponent` | Multi-line text input |
| `CheckboxComponent` | Binary selection control |
| `RadioButtonComponent` | Single radio option |
| `RadioButtonGroupComponent` | Group of mutually exclusive radio options |
| `ToggleComponent` | On/off switch |
| `DropdownComponent` | Single-select dropdown menu |
| `SelectComponent` | Native HTML select element styled for Carbon |
| `MultiSelectComponent` | Multi-select dropdown with checkboxes |
| `ComboBoxComponent` | Filterable dropdown with type-ahead |
| `DatePickerComponent` | Date selection with calendar |
| `TimePickerComponent` | Time entry input |
| `FileUploaderComponent` | File upload with drag-and-drop |
| `SliderComponent` | Range slider input |
| `SearchComponent` | Search input with clear action |
| `FormComponent` | Form wrapper with layout support |
| `FormGroupComponent` | Logical grouping of form fields |
| `PaginationComponent` | Page navigation for paginated data |

### Feedback

| Component | Description |
|-----------|-------------|
| `InlineNotificationComponent` | Contextual inline alert message |
| `ToastNotificationComponent` | Temporary floating notification |
| `LoadingComponent` | Full-page or overlay loading spinner |
| `InlineLoadingComponent` | Inline loading state indicator |
| `SkeletonTextComponent` | Placeholder skeleton for loading content |
| `ModalComponent` | Dialog overlay for focused tasks |

### Overlays

| Component | Description |
|-----------|-------------|
| `TooltipComponent` | Informational text on hover/focus |
| `ToggletipComponent` | Interactive tooltip toggled by click |
| `PopoverComponent` | Floating content panel |
| `MenuComponent` | Contextual action menu |
| `OverflowMenuComponent` | Actions hidden behind a "more" button |

### Navigation

| Component | Description |
|-----------|-------------|
| `LinkComponent` | Styled anchor element |
| `BreadcrumbComponent` | Breadcrumb navigation trail |

## System Arguments

All components accept arbitrary HTML attributes via `**system_arguments`. These are passed through to the root element of the rendered component:

```erb
<%= render Carbon::ButtonComponent.new(
  kind: :primary,
  id: "submit-btn",
  data: { turbo: false, action: "click->form#submit" },
  aria: { label: "Submit the form" }
) do %>
  Submit
<% end %>
```

You can also pass custom CSS classes, which are merged with the component's own Carbon classes:

```erb
<%= render Carbon::ButtonComponent.new(kind: :secondary, class: "my-custom-class") do %>
  Custom styled
<% end %>
```

## Interactivity

Components that require JavaScript behavior (accordions, dropdowns, modals, data tables, etc.) ship with sidecar [Stimulus](https://stimulus.hotwired.dev/) controllers.

- Controllers are automatically registered via importmap -- no manual JavaScript setup is required beyond running the install generator.
- Stimulus data attributes are added to component markup automatically.
- For projects that prefer Web Components, an optional WebComponent adapter is available for each interactive component.

## Lookbook Previews

Every component includes [Lookbook](https://lookbook.build/) previews with multiple scenarios covering common use cases, edge cases, and accessibility states.

To browse previews in development:

1. Start your Rails server (from the dummy app or your host app).
2. Visit `/lookbook` in your browser.

Previews are located in the `previews/` directory and follow the naming convention `Carbon::<ComponentName>Preview`.

## Development

```bash
# Install dependencies
bundle install
pnpm install

# Run the test suite
bundle exec rake test

# Run the linter
bundle exec rubocop

# Start Lookbook (from the test dummy app)
cd test/dummy && bin/rails server
```

### Running Specific Tests

```bash
# Run a single test file
bundle exec ruby -Itest test/components/carbon/button_component_test.rb

# Run tests matching a pattern
bundle exec rake test TESTOPTS="--name=/button/"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pnomolos/view_component-carbon.

1. Fork the repository.
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Write tests for your changes.
4. Ensure all tests pass (`bundle exec rake test`).
5. Ensure code style passes (`bundle exec rubocop`).
6. Commit your changes (`git commit -am 'Add some feature'`).
7. Push to the branch (`git push origin my-new-feature`).
8. Create a new Pull Request.

## License

This gem is available as open source under the terms of the [MIT License](LICENSE).
