# ETL

- Workflows to Extract
- Translate, Load raw Tailwind HTML Templates into their constituent parts.

## Flow

- Raw Components
  - List of raw HTML templates grouped by design system and sub grouped by component hierarchies.
- Component Structures
  - Components are broken down into their constituent parts.
    - HTML
    - tailwind.config.js
    - settings.json
    - clean HTML without comments or extra spaces
- Component Models
  - Further processing in the form of GPT3 extractions
    - data.json
    - model.rb

- Future
  - .astro
  - react
  - vue
  - svelte

## Workflow sections breakdown

### Raw Components

Tailwind Components are current setup using a single source director.

> This is not idea, because we should be able to put UIKits into any location you like, but single root is how it currently works.

The current root path is `templates/tailwind` and under that path there is six design systems.

- codepen
- devdojo
- merakiui
- noq
- starter-kit
- tui

Files with in any design system can be nested any way you like, but a natural hierarchy of component types might look like the following.

**Partial Example**

- tui/application-ui
- tui/application-ui/application-shells
- tui/application-ui/application-shells/multi-column
- tui/application-ui/application-shells/sidebar
- tui/application-ui/application-shells/stacked
- tui/application-ui/component
- tui/application-ui/component/element
- tui/application-ui/component/feedback
- tui/application-ui/component/form
- tui/application-ui/component/heading
- tui/application-ui/component/list
- tui/application-ui/component/navigation
- tui/application-ui/data-display
- tui/application-ui/layout
- tui/application-ui/overlays
- tui/application-ui/page
- tui/ecommerce
- tui/ecommerce/components
- tui/ecommerce/page

The deepest folder part is used to name the component group, e.g. multi-column, sidebar, stacked, element, feedback.

It is noted that a component group could be repeated within different hierarchy paths.

