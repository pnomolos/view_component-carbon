# Implementation Plan: Carbon Design System ViewComponents

## Context

Build a Ruby gem (`carbon_view_components`) that implements IBM's Carbon Design System as Rails ViewComponents, with optional dual interactivity support (Stimulus+Hotwire or WebComponents). The project starts from an empty Git repository. The implementation is designed to be driven primarily by an LLM (Claude Code) with human oversight at key decision points, using agent delegation and Playwright MCP for automated testing.

---

## Workflow Conventions

- **Package manager**: Use `pnpm` (not npm or yarn) for all Node.js dependency management. The devcontainer is pre-configured with pnpm via corepack.
- **Git workflow**: Use feature branches and atomic commits where possible. Each phase or logical unit of work should be developed on its own branch and merged via PR. Commits should be small, focused, and self-contained — one logical change per commit.

---

## Phase 0: Project Infrastructure (Human + Opus)

**Goal**: Set up the gem skeleton, tooling, CLAUDE.md, agents, and skills so that all subsequent work can be parallelized and delegated.

**Human required**: Review and approve the gem structure, naming conventions, and API patterns before any components are generated.

### 0.1 Gem Scaffold

Create the following structure:

```
carbon_view_components/
├── .claude/
│   ├── CLAUDE.md
│   ├── skills/
│   │   ├── generate-component/SKILL.md
│   │   ├── generate-test/SKILL.md
│   │   └── generate-preview/SKILL.md
│   └── agents/
│       ├── component-generator.md
│       ├── stimulus-author.md
│       ├── test-writer.md
│       └── a11y-auditor.md
├── app/
│   ├── components/
│   │   └── carbon/
│   │       └── base_component.rb
│   ├── assets/
│   │   └── stylesheets/
│   │       └── carbon_view_components/
│   │           └── application.scss      # @use '@carbon/styles'
│   └── helpers/
│       └── carbon/
│           └── view_components_helper.rb
├── lib/
│   ├── carbon_view_components.rb
│   ├── carbon_view_components/
│   │   ├── engine.rb
│   │   └── version.rb
│   └── generators/
│       └── carbon_view_components/
│           └── install_generator.rb
├── test/
│   ├── test_helper.rb
│   ├── components/
│   │   └── carbon/
│   └── dummy/                            # Minimal Rails app for testing
│       ├── app/
│       ├── config/
│       └── ...
├── previews/
│   └── carbon/
├── config/
│   └── importmap.rb
├── Gemfile
├── Rakefile
├── carbon_view_components.gemspec
├── package.json                          # For @carbon/styles dependency
├── .rubocop.yml
└── .github/
    └── workflows/
        └── ci.yml
```

### 0.2 Key Files

**`carbon_view_components.gemspec`**
```ruby
Gem::Specification.new do |spec|
  spec.name          = "carbon_view_components"
  spec.version       = CarbonViewComponents::VERSION
  spec.summary       = "ViewComponents for the Carbon Design System"
  spec.required_ruby_version = ">= 3.2.0"
  spec.add_dependency "actionview", ">= 7.2.0"
  spec.add_dependency "activesupport", ">= 7.2.0"
  spec.add_dependency "view_component", ">= 3.1", "< 5.0"
  spec.files = Dir["{app,lib,config,previews}/**/*", "LICENSE", "README.md"]
  spec.require_paths = ["lib"]
end
```

**`lib/carbon_view_components/engine.rb`**
```ruby
module CarbonViewComponents
  class Engine < ::Rails::Engine
    isolate_namespace CarbonViewComponents

    config.autoload_paths << root.join("app/components")
    config.eager_load_paths << root.join("app/components")

    initializer "carbon_view_components.assets" do |app|
      app.config.assets.precompile += %w[carbon_view_components/application.css]
    end

    initializer "carbon_view_components.importmap", before: "importmap" do |app|
      app.config.importmap.paths << Engine.root.join("config/importmap.rb")
    end
  end
end
```

**`app/components/carbon/base_component.rb`**
```ruby
module Carbon
  class BaseComponent < ViewComponent::Base
    # Shared utilities: CSS class building, ARIA helpers, theme support
    # Interactivity mode configuration (stimulus vs webcomponent)

    class_attribute :interactivity_mode, default: :stimulus

    private

    def class_names(*args)
      args.flatten.compact.join(" ")
    end

    def carbon_class(block, element = nil, modifier = nil)
      base = "cds--#{block}"
      base = "#{base}__#{element}" if element
      base = "#{base}--#{modifier}" if modifier
      base
    end
  end
end
```

**`package.json`**
```json
{
  "name": "carbon_view_components",
  "private": true,
  "dependencies": {
    "@carbon/styles": "^1.x",
    "@carbon/web-components": "^2.x"
  }
}
```

> **Note:** Use `pnpm install` (not `npm install`) to install dependencies. A `pnpm-lock.yaml` will be committed to the repo.

**`app/assets/stylesheets/carbon_view_components/application.scss`**
```scss
// Consuming apps @use this entrypoint, or import individual components
// Requires dartsass-rails with --load-path=node_modules
@use '@carbon/styles';
```

### 0.3 Dummy Rails App for Testing

The `test/dummy/` directory contains a minimal Rails 8 app:
- Propshaft as asset pipeline
- `dartsass-rails` for SCSS compilation with `--load-path=node_modules`
- Lookbook mounted at `/lookbook` for component previews
- Importmap for Stimulus controllers
- The gem mounted as a local dependency
- Node dependencies managed via `pnpm`

### 0.4 HUMAN CHECKPOINT: Review gem structure, naming conventions, BaseComponent API, and interactivity mode switching before proceeding.

---

## Phase 1: CLAUDE.md, Agents, and Skills (Opus)

**Goal**: Create the project intelligence layer that makes all subsequent component generation repeatable, parallelizable, and cost-efficient.

### 1.1 CLAUDE.md

```markdown
# Carbon ViewComponents

## Stack
- Ruby gem / Rails Engine
- ViewComponent 3.x+, Rails 7.2+
- Styles: @carbon/styles via dartsass-rails + Propshaft
- Interactivity: Stimulus controllers (primary), @carbon/web-components (optional)
- Testing: Minitest + Capybara matchers, Playwright MCP for a11y
- Previews: Lookbook

## Component Conventions
- All components live in `app/components/carbon/`
- Class names: `Carbon::<Name>Component` (e.g., `Carbon::ButtonComponent`)
- Files: `carbon/<name>_component.rb` + sidecar directory
- Sidecar: `carbon/<name>_component/<name>_component.html.erb`
- Stimulus: `carbon/<name>_component/<name>_controller.js`
- Tests: `test/components/carbon/<name>_component_test.rb`
- Previews: `previews/carbon/<name>_component_preview.rb`

## CSS Class Convention
- Use Carbon's `cds--` prefix: `cds--btn`, `cds--accordion`, etc.
- Use BaseComponent#carbon_class helper for consistent class generation
- Never write custom CSS — use @carbon/styles classes only

## Component API Pattern
- Use keyword arguments in initialize (kind:, size:, disabled:, etc.)
- Use ViewComponent slots for nested content
- All components accept **system_arguments for HTML attributes
- Validate kind/size/variant against allowed values
- Include ARIA attributes per Carbon's accessibility docs

## Interactivity
- Default: Stimulus controllers in sidecar JS files
- WebComponent mode: render <cds-*> custom elements instead of HTML
- Mode set via Carbon::BaseComponent.interactivity_mode = :stimulus | :webcomponent

## Reference Docs (fetch when implementing a component)
- Usage: https://carbondesignsystem.com/components/<name>/usage/
- Accessibility: https://carbondesignsystem.com/components/<name>/accessibility/
- React API: https://react.carbondesignsystem.com/?path=/docs/components-<name>--overview
```

### 1.2 Custom Skills

**`.claude/skills/generate-component/SKILL.md`**
The skill instructs the agent to:
1. Fetch the Carbon docs for the component (usage + accessibility pages)
2. Create the Ruby class with proper initialize params, slots, validations
3. Create the ERB template with correct CSS classes and ARIA attributes
4. Create a Stimulus controller if the component is interactive
5. Create a Minitest test file with unit tests
6. Create a Lookbook preview with all variants
7. Run tests to verify

**`.claude/skills/generate-test/SKILL.md`** — Generates test file for an existing component

**`.claude/skills/generate-preview/SKILL.md`** — Generates Lookbook preview for an existing component

### 1.3 Custom Subagents

**`.claude/agents/component-generator.md`** (Sonnet)
- Purpose: Generate complete component implementations
- Tools: Read, Write, Edit, Bash, WebFetch
- Follows patterns from CLAUDE.md
- Fetches Carbon docs for each component before generating

**`.claude/agents/stimulus-author.md`** (Sonnet)
- Purpose: Write Stimulus controllers for interactive components
- Tools: Read, Write, Edit, WebFetch
- References Carbon's web-components source for behavior specification
- Produces clean, idiomatic Stimulus code

**`.claude/agents/test-writer.md`** (Haiku)
- Purpose: Generate Minitest component tests
- Tools: Read, Write, Edit
- Follows existing test patterns in the project
- Boilerplate-heavy, good fit for cheaper model

**`.claude/agents/a11y-auditor.md`** (Sonnet + Playwright MCP)
- Purpose: Run accessibility audits on rendered components
- Tools: Read, Bash, Playwright MCP, axe-core
- Starts the dummy app server
- Navigates to Lookbook previews
- Runs axe-core scans
- Tests keyboard navigation (Tab, Enter, Escape, Arrow keys)
- Reports violations back for fixing

---

## Phase 2: Reference Component (Opus — HUMAN REVIEW REQUIRED)

**Goal**: Build one complete component end-to-end to establish all patterns. Every subsequent component follows this template.

### 2.1 Button Component (reference implementation)

This is the "golden" component. Build it manually with Opus, get human sign-off, then use it as the template for all others.

**Files to create:**

| File | Purpose |
|------|---------|
| `app/components/carbon/button_component.rb` | Ruby class: kind, size, disabled, icon, href, tag, type params |
| `app/components/carbon/button_component/button_component.html.erb` | ERB: renders `<button>` or `<a>` with `cds--btn` classes |
| `app/components/carbon/button_component/button_controller.js` | Stimulus: minimal (button doesn't need much JS) |
| `test/components/carbon/button_component_test.rb` | Tests: all kinds, sizes, disabled, icon-only, link variant |
| `previews/carbon/button_component_preview.rb` | Lookbook: all variants with param controls |

**Button API:**
```ruby
Carbon::ButtonComponent.new(
  kind: :primary,          # :primary, :secondary, :tertiary, :ghost, :danger
  size: :md,               # :sm, :md, :lg, :xl, :2xl
  disabled: false,
  icon: nil,               # Icon name or component
  icon_only: false,
  href: nil,               # If set, renders <a> instead of <button>
  type: :button,           # :button, :submit, :reset
  **system_arguments       # HTML attributes passthrough
)
```

**CSS mapping:**
```
kind: :primary   → cds--btn--primary
size: :lg        → cds--btn--lg
disabled: true   → cds--btn--disabled + disabled attribute
icon_only: true  → cds--btn--icon-only
```

### 2.2 Validate the reference

- Run `rake test` — all button tests pass
- Start dummy app, visit Lookbook, verify all variants render correctly
- Run a11y-auditor agent against button previews
- Verify Stimulus controller loads (if applicable)

### 2.3 HUMAN CHECKPOINT: Review Button implementation. Confirm API style, file organization, CSS class approach, test patterns, and preview format. This sets the template for all 40+ remaining components.

---

## Phase 3: Simple Components — Batch 1 (Parallelizable — Haiku/Sonnet agents)

**Goal**: Generate ~12 simple components in parallel. These are primarily static HTML + CSS with minimal/no interactivity.

### Parallelization Strategy

Launch up to **4-5 component-generator agents in parallel**, each producing one complete component (Ruby class + ERB + test + preview). Use Sonnet for the generator, Haiku for tests/previews.

### Components in this batch

| # | Component | Complexity | Notes |
|---|-----------|-----------|-------|
| 1 | Link | Simple | `<a>` with `cds--link` classes, inline/disabled variants |
| 2 | Tag | Simple | Read-only, filter, dismissible variants; size, type params |
| 3 | Badge Indicator | Simple | Status dot with color |
| 4 | Loading | Simple | Spinner, small/large, overlay variant |
| 5 | Inline Loading | Simple | Small spinner with text |
| 6 | Progress Bar | Simple | Value, max, label, size, status |
| 7 | Breadcrumb | Simple | Parent with BreadcrumbItem slot |
| 8 | List | Simple | Ordered/unordered, nested; ListItem slot |
| 9 | Structured List | Simple | Rows + cells, selection variant |
| 10 | Skeleton Text | Simple | Placeholder lines for loading states |
| 11 | Contained List | Simple | List with header |
| 12 | Progress Indicator | Medium-low | Steps with current/complete/incomplete states |

### Agent delegation plan

```
Orchestrator (Opus): Assigns components, reviews output
├── Agent 1 (Sonnet): Link + Tag + Badge Indicator
├── Agent 2 (Sonnet): Loading + Inline Loading + Progress Bar
├── Agent 3 (Sonnet): Breadcrumb + List + Structured List
├── Agent 4 (Sonnet): Skeleton Text + Contained List + Progress Indicator
└── Test Writer (Haiku): Generates additional test cases after components are created
```

Each agent:
1. Reads the Button reference component for patterns
2. Fetches Carbon docs for their assigned components
3. Generates Ruby class + ERB + test + preview
4. Runs `rake test` to verify

### After batch completion
- a11y-auditor agent scans all new components in Lookbook
- Human spot-checks 2-3 components visually

---

## Phase 4: Medium Components — Batch 2 (Parallelizable — Sonnet agents)

**Goal**: Components requiring Stimulus controllers for interactivity.

### Components

| # | Component | Key Interactivity | Stimulus Controller Needed |
|---|-----------|-------------------|---------------------------|
| 1 | Accordion | Expand/collapse panels | Yes — toggle panel visibility |
| 2 | Tabs | Tab switching | Yes — show/hide tab panels |
| 3 | Content Switcher | Toggle between views | Yes — similar to tabs |
| 4 | Toggle | On/off switch | Yes — state change + ARIA |
| 5 | Checkbox | Check/uncheck, indeterminate | Minimal — mostly HTML |
| 6 | Radio Button | Selection within group | Minimal — mostly HTML |
| 7 | Text Input | Validation states, character count | Yes — counter + validation |
| 8 | Number Input | Increment/decrement buttons | Yes — step buttons |
| 9 | Text Area | Character count, auto-resize | Yes — counter |
| 10 | Notification (Toast) | Auto-dismiss timer, close button | Yes — timeout + dismiss |
| 11 | Notification (Inline) | Close button | Minimal |
| 12 | Code Snippet | Copy to clipboard, expand/collapse | Yes — clipboard API |
| 13 | Tooltip | Show on hover/focus | Yes — positioning |
| 14 | Toggletip | Show on click | Yes — positioning + dismiss |
| 15 | Popover | Anchored positioning | Yes — positioning logic |
| 16 | Slider | Drag handle, value display | Yes — drag + ARIA |
| 17 | Pagination | Page navigation, items-per-page | Yes — state management |
| 18 | Search | Clear button, expand/collapse | Yes — input management |

### Agent delegation plan

```
Orchestrator (Opus): Assigns, reviews, ensures consistency
├── Agent 1 (Sonnet): Accordion + Tabs + Content Switcher + Toggle
├── Agent 2 (Sonnet): Checkbox + Radio + Text Input + Number Input + Text Area
├── Agent 3 (Sonnet): Notification (both) + Code Snippet + Search
├── Agent 4 (Sonnet): Tooltip + Toggletip + Popover + Slider + Pagination
├── Stimulus Author (Sonnet): Reviews/refines all Stimulus controllers
└── a11y-auditor (Sonnet + Playwright): Tests each component after generation
```

### HUMAN CHECKPOINT: After batch 2, review Stimulus controllers for Accordion, Tabs, and Tooltip. These set patterns for positioning logic, panel management, and focus handling used by more complex components.

---

## Phase 5: Complex Components — Batch 3 (Sequential with human involvement)

**Goal**: Components with significant JavaScript, keyboard navigation, and ARIA requirements. These should NOT be fully parallelized — each one needs individual attention.

### Components

| # | Component | Why Complex |
|---|-----------|------------|
| 1 | Modal | Focus trapping, scroll lock, backdrop, Escape to close, nested modals |
| 2 | Dropdown | Keyboard nav (arrows), typeahead, open/close, ARIA listbox |
| 3 | Select | Native vs custom select, keyboard nav |
| 4 | Multiselect | Multiple selection, tags, clear all |
| 5 | Combo Box | Typeahead filtering, async loading, keyboard nav |
| 6 | Date Picker | Calendar rendering, range selection, locale, keyboard nav |
| 7 | Time Picker | Hour/minute input, AM/PM, validation |
| 8 | File Uploader | Drag-and-drop, progress, file list management |
| 9 | Menu | Nested submenus, keyboard nav, focus management |
| 10 | Menu Buttons | Button + menu combination |
| 11 | Tree View | Hierarchical expand/collapse, keyboard nav, multi-select |
| 12 | Form | Validation orchestration across child inputs |

### Approach: Sequential, 2-3 components at a time

```
For each component:
1. Opus or Sonnet agent generates initial implementation
2. a11y-auditor agent runs Playwright MCP tests
3. Agent iterates on failures (fix → retest loop, up to 3 rounds)
4. HUMAN reviews keyboard navigation and screen reader behavior
5. Human approves or requests changes
```

### HUMAN CHECKPOINT: Required for each complex component. Focus on:
- Modal focus trapping behavior
- Dropdown/Combo Box keyboard navigation
- Date Picker calendar interaction
- Menu nested focus management

---

## Phase 6: Very Complex Components — Batch 4 (Human-heavy)

**Goal**: Compound components with multiple interrelated sub-components.

### Components

| # | Component | Sub-components |
|---|-----------|---------------|
| 1 | DataTable | Table, TableHead, TableBody, TableRow, TableCell, TableHeaderCell, TableExpandedRow, TableToolbar, TableToolbarSearch, TableBatchActions, TableSkeleton |
| 2 | UI Shell | Header, HeaderNav, HeaderMenuItem, SideNav, SideNavItems, SideNavLink, SideNavMenu, HeaderPanel, Switcher |
| 3 | Tile | ClickableTile, SelectableTile, ExpandableTile, RadioTile |

### Approach

These cannot be fully delegated. The recommended workflow:

1. **Opus designs the sub-component API** — which sub-components, how they nest, slot structure
2. **HUMAN approves the API design** before any code is written
3. **Sonnet agents generate sub-components in parallel** once API is approved
4. **Stimulus author builds the coordination controller** (e.g., DataTable sorting/filtering/selection state)
5. **a11y-auditor runs comprehensive keyboard/ARIA tests**
6. **HUMAN does integration testing** — especially DataTable with sorting + filtering + pagination + batch actions all working together

### HUMAN CHECKPOINT: DataTable and UI Shell both require holistic design review. These are the most likely to need multiple rounds of iteration.

---

## Phase 7: WebComponent Alternative Renderer (Parallelizable — Sonnet)

**Goal**: Add optional WebComponent rendering mode to all existing components.

### Approach

For each component, add an alternative ERB template or conditional rendering path:

```ruby
# In BaseComponent
def render_mode
  self.class.interactivity_mode
end

# In each component's ERB
<% if render_mode == :webcomponent %>
  <cds-button kind="<%= @kind %>" size="<%= @size %>"><%= content %></cds-button>
<% else %>
  <button class="cds--btn cds--btn--<%= @kind %>" data-controller="carbon--button">
    <%= content %>
  </button>
<% end %>
```

This phase is highly parallelizable — each component's WebComponent template is independent.

```
Orchestrator assigns 5-6 components per agent
├── Agent 1: Button, Link, Tag, Badge, Loading, Inline Loading
├── Agent 2: Accordion, Tabs, Toggle, Content Switcher, Notification
├── Agent 3: Text Input, Number Input, Checkbox, Radio, Select
├── ...
└── Test Writer: Add tests for WebComponent rendering mode
```

---

## Phase 8: Polish and Documentation (Parallelizable)

### 8.1 Install Generator
```ruby
# lib/generators/carbon_view_components/install_generator.rb
# Adds @carbon/styles via pnpm
# Configures dartsass-rails load path
# Adds stylesheet @use to application.scss
# Mounts Lookbook in development routes
```

### 8.2 Documentation
- README with installation, usage examples, theme configuration
- Each component gets a usage section in its Lookbook preview
- YARD documentation on all public methods

### 8.3 CI Pipeline
- GitHub Actions: Ruby tests, Rubocop, SCSS compilation check
- Playwright a11y audit on all Lookbook previews

---

## Agent & Skill Summary

### Custom Agents (`.claude/agents/`)

| Agent | Model | Purpose | Tools |
|-------|-------|---------|-------|
| `component-generator` | Sonnet | Generate complete component implementations | Read, Write, Edit, Bash, WebFetch |
| `stimulus-author` | Sonnet | Write/refine Stimulus controllers | Read, Write, Edit, WebFetch |
| `test-writer` | Haiku | Generate Minitest test files | Read, Write, Edit |
| `a11y-auditor` | Sonnet | Run Playwright + axe-core accessibility audits | Read, Bash, Playwright MCP |
| `webcomponent-templater` | Haiku | Add WebComponent rendering paths | Read, Write, Edit |

### Custom Skills (`.claude/skills/`)

| Skill | Model | Purpose |
|-------|-------|---------|
| `/generate-component <Name>` | Sonnet | End-to-end component generation |
| `/generate-test <Name>` | Haiku | Generate test file for existing component |
| `/generate-preview <Name>` | Haiku | Generate Lookbook preview for existing component |
| `/audit-a11y <Name>` | Sonnet | Run a11y audit on a specific component via Playwright |

### Cost Optimization

- **Haiku** ($1/$5 per M tokens): Tests, previews, WebComponent templates, boilerplate — ~60% of agent invocations
- **Sonnet** ($3/$15 per M tokens): Component generation, Stimulus controllers, a11y auditing — ~35% of agent invocations
- **Opus** ($5/$25 per M tokens): Orchestration, complex component design, Phase 0/1/2 — ~5% of agent invocations

---

## Parallelization Map

```
Phase 0: Gem scaffold ──────────────────────────── [Opus, sequential]
Phase 1: CLAUDE.md + agents + skills ───────────── [Opus, sequential]
Phase 2: Reference component (Button) ─────────── [Opus, sequential, HUMAN REVIEW]
    │
    ▼
Phase 3: Simple components (12) ────────────────── [4 Sonnet agents in PARALLEL]
    │                                                 + Haiku test writer
    │
    ▼
Phase 4: Medium components (18) ────────────────── [4 Sonnet agents in PARALLEL]
    │                                                 + Stimulus author
    │                                                 + a11y-auditor
    │
    ▼
Phase 5: Complex components (12) ───────────────── [Sequential, 2-3 at a time]
    │                                                 [HUMAN REVIEW each]
    │
    ▼
Phase 6: Very complex components (3) ───────────── [Sequential, HUMAN-HEAVY]
    │
    ▼
Phase 7: WebComponent alt renderer ─────────────── [5-6 agents in PARALLEL]
    │
    ▼
Phase 8: Polish + docs + CI ────────────────────── [agents in PARALLEL]
```

**Phases 3+4 are the big wins for parallelization** — 30 components across 4 agents each.

---

## Human Involvement Summary

| Checkpoint | When | What to Review | Blocking? |
|-----------|------|---------------|-----------|
| Gem structure | After Phase 0 | File layout, naming, BaseComponent API | Yes |
| Button reference | After Phase 2 | Component API pattern, CSS approach, test style | Yes |
| Stimulus patterns | After Phase 4 | Accordion, Tabs, Tooltip controllers | Yes |
| Each complex component | During Phase 5 | Keyboard nav, focus management, ARIA | Yes |
| DataTable + UI Shell API | Start of Phase 6 | Sub-component design, slot structure | Yes |
| DataTable + UI Shell integration | End of Phase 6 | Full integration testing | Yes |
| Final review | After Phase 8 | Overall quality, install flow, docs | Yes |

**Non-blocking human tasks** (can happen async):
- Screen reader testing (VoiceOver/NVDA) on any completed component
- Visual design fidelity review in Lookbook
- Cross-browser spot checks (Firefox, Safari)

---

## MCP Configuration Required

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@executeautomation/playwright-mcp-server"]
    },
    "playwright-axe": {
      "command": "npx",
      "args": ["-y", "playwright-axe-mcp"]
    }
  }
}
```

---

## Verification

After each phase:
1. `bundle exec rake test` — all component tests pass
2. `bundle exec rake dartsass:build` — SCSS compiles without errors
3. Start dummy app → visit `/lookbook` → visually verify components
4. a11y-auditor agent scans all new components → zero axe-core violations
5. Keyboard navigation test via Playwright MCP → Tab order, Enter/Escape/Arrows work

Final verification:
1. Create a fresh Rails 8 app
2. Add `gem "carbon_view_components"` to Gemfile
3. Run `rails generate carbon_view_components:install`
4. Run `pnpm install` to install Node dependencies
5. Render several components in a test page
6. Verify styles load, Stimulus controllers connect, all interactions work
