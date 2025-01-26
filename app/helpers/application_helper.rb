module ApplicationHelper
  include Pagy::Frontend
  def highlight_term(text, term)
    return text if term.blank?

    escaped = Regexp.escape(term)
    regex = Regexp.new("(#{escaped})", Regexp::IGNORECASE)
    text.to_s.gsub(regex, '<mark>\1</mark>').html_safe
  end
end
