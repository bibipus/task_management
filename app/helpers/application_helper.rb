module ApplicationHelper
  include Pagy::Frontend

  def highlight_term(text, term)
    return text if term.blank?

    escaped = Regexp.escape(term)
    regex = Regexp.new("(#{escaped})", Regexp::IGNORECASE)
    text.to_s.gsub(regex, '<mark>\1</mark>').html_safe
  end

  def flash_class(type)
    {
      notice: 'flash flash-success',
      alert: 'flash flash-danger',
      error: 'flash flash-danger',
      info: 'flash flash-info'
    }.fetch(type.to_sym, 'flash flash-secondary')
  end

  def render_flash_message(key, message)
    content_tag :div, class: "flash-message #{flash_class(key)}" do
      concat content_tag(:span, message, class: 'flash-message__text')
      concat tag.button('×', type: 'button', class: 'flash-message__close', aria: { label: 'Zavřít' })
    end
  end

end
