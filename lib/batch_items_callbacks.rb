require 'libxml'

# Callbacks for SAX XML parser
#
class BatchItemsCallbacks
  include LibXML::XML::SaxParser::Callbacks

  def initialize(items_handler)
    @items_handler = items_handler
    @element_data = ''
  end

  def on_start_element(name, _attrs)
    case name
    when 'item'
      @current_item = {}
    when 'g:id', 'title', 'description'
      @start_element = true
    end
  end

  def on_characters(str)
    @element_data += str if @start_element
  end

  def on_end_element(name)
    case name
    when 'g:id', 'title', 'description'
      @current_item[name.sub('g:', '').to_sym] = @element_data
    when 'item'
      handle_item(@current_item)
    end
    @element_data = ''
    @start_element = false
  end

  def on_end_document
    @items_handler.flush
  end

  private

  def handle_item(item)
    @items_handler.call(item)
  end
end
