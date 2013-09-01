require_relative 'spec_helper'

describe Telepath::Handler do
  before { pre_test_setup }
  after  { post_test_teardown }

  subject(:handler){ described_class.new double(Clamp::Command) }

  let(:storage){ Telepath::Storage.new }
  let(:value){ 'whatever' }

  before do
    handler.add value
  end

  it 'exists' do
    expect(described_class).to be
  end

  after do
    storage.store.close unless storage.store.adapter.backend.closed?
  end

  describe '#add' do
    it 'adds 1 item' do
      expect{ handler.add 'something' }.to change{
        storage.store.adapter.backend.sunrise
        storage.stack.length
      }.from(1).to(2)
    end

    it 'adds the right item' do
      handler.add 'something'
      expect(storage.stack).to include('something')
    end
  end

  describe '#grab' do
  end

  describe '#index' do
  end

  describe '#lookup' do
    it 'looks up last value' do
      expect(handler.lookup).to eq(value)
    end

    it 'does not delete the item' do
      expect{ handler.lookup value }.to change{
        storage.store.adapter.backend.sunrise
        storage.stack.length
      }.by(0)
    end

    context 'pattern matching' do
      it 'matches substrings of words' do
        expect(handler.lookup('what')).to eq(value)
      end

      context 'numbers' do
        let(:value){ '12' }

        it 'matches parts of numbers' do
          expect(handler.lookup('1')).to eq(value)
        end
      end
    end
  end
end
