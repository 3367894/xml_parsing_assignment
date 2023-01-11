require_relative 'external_service'
require_relative  'xml_parser'
require_relative  'batch_items_callbacks'
require_relative  'items_handler'

# Orchestration for the components project that run parsing and handling items in the XML file
#
class XmlItemsProcessor
  MAX_BATCH_SIZE = 5 * 1024 * 1024

  def initialize(file_path:, max_batch_size: MAX_BATCH_SIZE)
    @file_path = file_path
    @max_batch_size = max_batch_size
  end

  def call
    xml_parser.call
  end

  private

  def external_service
    @external_service ||= ExternalService.new
  end

  def items_handler
    @items_handler ||= ItemsHandler.new(
      batch_service: external_service,
      max_batch_size: @max_batch_size
    )
  end

  def items_parsing_callbacks
    @items_parsing_callbacks ||= BatchItemsCallbacks.new(items_handler)
  end

  def xml_parser
    @xml_parser ||= XmlParser.new(@file_path, items_parsing_callbacks)
  end
end
