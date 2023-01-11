require 'items_handler'

RSpec.describe ItemsHandler do
  let(:max_batch_size) { 15 }
  subject { described_class.new(max_batch_size: max_batch_size, batch_service: batch_service) }
  let(:eight_bytesize_item) { { id: 1 } }
  let(:another_eight_bytesize_item) { { id: 2 } }
  let(:batch_service) { double(call: true) }

  describe '#call' do
    it "doesn't sends anything if size of items is not enough" do
      expect(batch_service).not_to receive(:call)

      subject.call(eight_bytesize_item) # 8 bytes of item + [] = 10 < max_batch_size
    end

    it 'sends butch to ExternalService when batch size is bigger than maximum' do
      json = JSON.generate([eight_bytesize_item])
      expect(batch_service).to receive(:call).with(json).once

      subject.call(eight_bytesize_item) # 8 bytes of item + [] = 10 < max_batch_size
      subject.call(eight_bytesize_item) # 16 bytes of items + [] > max_batch_size
    end

    it 'sends butch to ExternalService again when batch size is bigger than maximum' do
      json = JSON.generate([eight_bytesize_item])
      expect(batch_service).to receive(:call).with(json).once

      subject.call(eight_bytesize_item) # 8 bytes of item + [] = 10 < max_batch_size
      subject.call(another_eight_bytesize_item) # 16 bytes of items + [] > max_batch_size

      json = JSON.generate([another_eight_bytesize_item])
      expect(batch_service).to receive(:call).with(json).once
      subject.call(eight_bytesize_item) # 16 bytes of items + [] > max_batch_size
    end
  end

  describe '#flush' do
    it 'send current items' do
      json = JSON.generate([eight_bytesize_item])
      expect(batch_service).to receive(:call).with(json).once

      subject.call(eight_bytesize_item)

      subject.flush
    end
  end
end
