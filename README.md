# phlex-style_variants

[![Gem Version](https://img.shields.io/gem/v/phlex-style_variants)](https://rubygems.org/gems/phlex-style_variants)
[![Gem Downloads](https://img.shields.io/gem/dt/phlex-style_variants)](https://www.ruby-toolbox.com/projects/phlex-style_variants)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/omarluq/phlex-style_variants/ci.yml)](https://github.com/omarluq/phlex-style_variants/actions/workflows/ci.yml)
[![Code Climate maintainability](https://img.shields.io/codeclimate/maintainability/omarluq/phlex-style_variants)](https://codeclimate.com/github/omarluq/phlex-style_variants)

Powerful Variant API for phlex component built on top of Literal

> [!WARNING]
> This gem is currently in development and is considered unstable. The API is subject to change, and you may encounter bugs or incomplete features.
> Use it at your own risk, and contribute by reporting issues or suggesting improvements!

---

- [Quick start](#quick-start)
- [Support](#support)
- [License](#license)
- [Code of conduct](#code-of-conduct)
- [Contribution guide](#contribution-guide)

## Features

- Declarative Style Definitions: Easily define base styles and variant groups using a clean DSL.
- Automatic Enum Generation: Automatically generates enum classes for variant groups, ensuring type safety and easy usage.
- Inheritance Support: Create style sets that inherit from other style sets, promoting DRY (Don't Repeat Yourself) principles.
- Variant Predicates: Built-in predicate methods to check active variants (e.g., `size.md?`).
- Flexible Compilation: Compile styles based on active variants, allowing dynamic class generation.
- Seamless Integration with Phlex: Designed to work effortlessly with Phlex components, enhancing their styling capabilities.

## Quick start

```
gem install phlex-style_variants
```

```ruby
require "phlex/style_variants"
```

## Usage

```rb
require "phlex/style_variants"

class Button < Phlex::HTML
  include Phlex::StyleVariants

  # Define the primary style set
  style do
    base { 'inline-block px-4 py-2 rounded font-semibold' }

    variants do
      color do
        primary { 'bg-blue-500 text-white' }
        danger  { 'bg-red-500 text-white' }
      end

      size do
        sm { 'text-sm' }
        md { 'text-base' }
        lg { 'text-lg' }
      end
    end
  end

  # Define a named style set called :wrapper with inheritance
  style(:wrapper) do
    base { 'p-4 bg-gray-100' }

    variants do
      border_style do
        none   { '' }
        dashed { 'border-2 border-dashed border-gray-400' }
      end
    end
  end

  prop :text, String, default: -> { 'Click Me!' }, reader: :public

  def view_template
    div(class: style(:wrapper, border_style:).compiled) do
      button(class: style(color:, size:).compiled) do
        text
      end
    end
  end
end

# Rendering the Button component
button = Button.new(
  text: 'Delete',
  color: Button::ColorEnum::Danger,
  size: Button::SizeEnum::Lg,
  border_style: Button::BorderStyleEnum::Dashed
)
button.call
```

output:

```html
<div class="p-4 bg-gray-100 border-2 border-dashed border-gray-400">
  <button
    class="inline-block px-4 py-2 rounded font-semibold bg-red-500 text-white text-lg"
  >
    Delete
  </button>
</div>
```

## Support

If you want to report a bug, or have ideas, feedback or questions about the gem, [let me know via GitHub issues](https://github.com/omarluq/phlex-style_variants/issues/new) and I will do my best to provide a helpful answer. Happy hacking!

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).

## Code of conduct

Everyone interacting in this project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](CODE_OF_CONDUCT.md).

## Contribution guide

Pull requests are welcome!
