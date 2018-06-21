class HsreplayCardHtmlParser

  def initialize(html)
    @html = html
  end

  def card_data
    data_el = doc.css("#react_context")
    JSON.parse(data_el.text)
  end

  def doc
    @doc ||= Nokogiri::HTML.parse @html
  end
end
