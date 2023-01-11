require 'xml_parser'
require 'libxml'

class TestItemCallbacks
  include LibXML::XML::SaxParser::Callbacks

  attr_reader :items_count

  def initialize
    @items_count = 0
  end

  def on_start_element(name, _attrs)
    @items_count += 1 if name == 'item'
  end
end

RSpec.describe XmlParser do
  let(:callbacks) { TestItemCallbacks.new }
  let(:file_path) { fixture('feed.xml').path }
  subject { described_class.new(file_path, callbacks) }

  it 'calls parsing of file with specific callbacks' do
    subject.call

    expect(callbacks.items_count).to eq(3) # amount of items in the fixtures/feed.xml
  end
end
