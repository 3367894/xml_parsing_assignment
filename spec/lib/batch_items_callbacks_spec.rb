require 'xml_parser'
require 'batch_items_callbacks'
require 'libxml'

RSpec.describe BatchItemsCallbacks do
  let(:items_handler) { double(call: true, flush: true) }
  let(:callbacks) { described_class.new(items_handler) }
  let(:file_path) { fixture('feed.xml').path }
  subject { XmlParser.new(file_path, callbacks) }

  it 'collects items from xml file and send them to handler' do
    3.times do |index|
      item_index = index + 1
      expect(items_handler).to(
        receive(:call)
          .with(
            {
              id: item_index.to_s,
              description: "Description #{item_index}",
              title: "Title #{item_index}"
            }
          ).once
      )
    end

    subject.call
  end

  it 'calls flush of current state to handle items at the end of the document' do
    expect(items_handler).to receive(:flush).once

    subject.call
  end

  context 'empty XML file' do
    let(:file_path) { fixture('empty_feed.xml').path }

    it "'doesn't call handler" do
      expect(items_handler).not_to receive(:call)

      subject.call
    end
  end
end
