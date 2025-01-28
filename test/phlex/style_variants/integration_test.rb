# frozen_string_literal: true

require 'test_helper'

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

class IntegrationTest < Phlex::StyleVariants::Test
  # Helper method to render a Phlex component into HTML
  def test_default_button
    button = Button.new
    doc = render_fragment(button) # Uses Phlex::Testing::Nokogiri's render_fragment

    # Assertions using Nokogiri
    wrapper = doc.at_css('div.p-4.bg-gray-100')
    assert wrapper, 'Wrapper should have default classes'

    btn = wrapper.at_css('button.inline-block.px-4.py-2.rounded.font-semibold.bg-blue-500.text-white.text-sm')
    assert btn, 'Button should have default classes'
    assert_equal 'Click Me!', btn.text.strip, 'Button should display default text'

    # Ensure border classes are not present
    refute doc.at_css('div.border-2.border-dashed.border-gray-400'), 'Wrapper should not have border-dashed classes'
    # Test enum methods
    # styles = button.style
    # assert styles.size.md?, 'Expected size to be md'
    # assert styles.color.primary?, 'Expected color to be primary'
    # assert styles.border_style.none?, 'Expected border_style to be none'
  end

  def test_danger_large_button_with_dashed_border
    button = Button.new(
      text: 'Delete',
      color: Button::ColorEnum::Danger,
      size: Button::SizeEnum::Lg,
      border_style: Button::BorderStyleEnum::Dashed
    )
    doc = render_fragment(button) # Uses render_fragment

    # Assertions using Nokogiri
    wrapper = doc.at_css('div.p-4.bg-gray-100.border-2.border-dashed.border-gray-400')
    assert wrapper, 'Wrapper should have dashed border classes'

    btn = wrapper.at_css('button.inline-block.px-4.py-2.rounded.font-semibold.bg-red-500.text-white.text-lg')
    assert btn, 'Button should have danger and lg size classes'
    assert_equal 'Delete', btn.text.strip, 'Button should display "Delete" text'

    # Ensure specific classes are not present
    refute btn.at_css('button.text-sm'), 'Button should not have text-sm class'

    # # Test enum methods
    # styles = button.style
    # assert styles.size.lg?, 'Expected size to be lg'
    # assert styles.color.danger?, 'Expected color to be danger'
    # assert styles.border_style.dashed?, 'Expected border_style to be dashed'
  end

  def test_small_default_button_without_border
    button = Button.new(
      text: 'Small Button',
      size: Button::SizeEnum::Sm,
      border_style: Button::BorderStyleEnum::None
    )
    doc = render_fragment(button) # Uses render_fragment

    # Assertions using Nokogiri
    wrapper = doc.at_css('div.p-4.bg-gray-100')
    assert wrapper, 'Wrapper should have default classes'

    btn = wrapper.at_css('button.inline-block.px-4.py-2.rounded.font-semibold.bg-blue-500.text-white.text-sm')
    assert btn, 'Button should have sm size classes'
    assert_equal 'Small Button', btn.text.strip, 'Button should display "Small Button" text'

    # Ensure border classes are not present
    refute doc.at_css('div.border-2.border-dashed.border-gray-400'), 'Wrapper should not have border-dashed classes'

    # # Test enum methods
    # styles = button.style
    # assert styles.size.sm?, 'Expected size to be sm'
    # assert styles.color.primary?, 'Expected color to be primary'
    # assert styles.border_style.none?, 'Expected border_style to be none'
  end

  def test_border_style_none
    button = Button.new(
      text: 'No Border',
      border_style: Button::BorderStyleEnum::None
    )
    doc = render_fragment(button) # Uses render_fragment

    # Assertions using Nokogiri
    wrapper = doc.at_css('div.p-4.bg-gray-100')
    assert wrapper, 'Wrapper should have default classes'

    btn = wrapper.at_css('button.inline-block.px-4.py-2.rounded.font-semibold.bg-blue-500.text-white.text-sm')
    assert btn, 'Button should have default classes'
    assert_equal 'No Border', btn.text.strip, 'Button should display "No Border" text'

    # Ensure border classes are not present
    refute doc.at_css('div.border-2.border-dashed.border-gray-400'), 'Wrapper should not have border-dashed classes'

    # Test enum methods
    # styles = button.style
    # assert styles.border_style.none?, 'Expected border_style to be none'
  end

  def test_border_style_dashed
    button = Button.new(
      text: 'Dashed Border',
      border_style: Button::BorderStyleEnum::Dashed
    )
    doc = render_fragment(button) # Uses render_fragment

    # Assertions using Nokogiri
    wrapper = doc.at_css('div.p-4.bg-gray-100.border-2.border-dashed.border-gray-400')
    assert wrapper, 'Wrapper should have dashed border classes'

    btn = wrapper.at_css('button.inline-block.px-4.py-2.rounded.font-semibold.bg-blue-500.text-white.text-sm')
    assert btn, 'Button should have default classes'
    assert_equal 'Dashed Border', btn.text.strip, 'Button should display "Dashed Border" text'

    # Ensure shadow-lg class is not present
    refute doc.at_css('div.shadow-lg'), 'Wrapper should not have shadow-lg class'

    # Test enum methods
    # styles = button.style
    # assert styles.border_style.dashed?, 'Expected border_style to be dashed'
  end
end
