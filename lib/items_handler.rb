require 'json'

# Class for collecting batch of items and sending them to `batch_service`
#
class ItemsHandler
  def initialize(batch_service:, max_batch_size:)
    @max_batch_size = max_batch_size
    @batch_service = batch_service
    reset
  end

  def call(item)
    size = item_bytesize(item)
    if calc_full_size(size) > @max_batch_size
      send_batch
      reset
    end
    add_item(item, size)
  end

  def flush
    return if @items.empty?

    send_batch
    reset
  end

  private

  # Calculating real size of future json
  # bytesize of items +
  # commas (count of items - 1) +
  # size of new item +
  # 2 - for squares
  def calc_full_size(size)
    @items_bytesize + @items.count + size + 1
  end

  def reset
    @items = []
    @items_bytesize = 0
  end

  def add_item(item, size)
    @items << item
    @items_bytesize += size
  end

  def item_bytesize(item)
    JSON.generate(item).bytesize
  end

  def send_batch
    @batch_service.call(@items.to_json)
  end
end
