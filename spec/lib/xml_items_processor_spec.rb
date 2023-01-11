require 'xml_items_processor'

RSpec.describe XmlItemsProcessor do
  let(:file_path) { fixture('feed.xml').path }
  subject { described_class.new(file_path: file_path, max_batch_size: 120) }

  it 'sends data from XML to ExternalService' do
    expect_any_instance_of(ExternalService).to receive(:call).twice

    subject.call
  end
end
