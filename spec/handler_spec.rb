require_relative 'spec_helper'

describe Telepath::Handler do
  before { pre_test_setup }
  after  { post_test_teardown }

  subject(:handler){ described_class.new double(Clamp::Command) }

  let(:storage){ Telepath::Storage.new }
  let(:value){ 'whatever' }
  let(:next_value){ 'all your bass' }

  before do
    handler.add value
    handler.add next_value
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
      }.from(2).to(3)
    end

    it 'adds the right item' do
      handler.add 'something'
      expect(storage.stack).to include('something')
    end

    context 'redirected input' do
      xit 'reads and stores stdin' do
        # how to test?
      end
    end
  end

  describe '#last' do
    it 'returns the last value' do
      expect(handler.last).to eq(next_value)
    end

    it 'does not delete the item' do
      expect{ handler.last }.to change{
        storage.store.adapter.backend.sunrise
        storage.stack.length
      }.by(0)
    end

    context 'with a count' do
      it 'returns the count last items' do
        expect(handler.last 2).to eq ["whatever", "all your bass"]
      end
    end
  end

  describe '#index' do
    it 'returns the item at the specified reverse index (1)' do
      expect(handler.index 1).to eq [value]
    end

    it 'returns the item at the specified reverse index (0)' do
      expect(handler.index 0).to eq [next_value]
    end

    it 'does not delete the item' do
      expect{ handler.index 1 }.to change{
        storage.store.adapter.backend.sunrise
        storage.stack.length
      }.by(0)
    end

    context 'multiple indicies' do
      it 'should return the items in the same order specified' do
        expect(handler.index 0, 1).to eq [next_value, value]
      end
    end
  end

  describe '#lookup' do
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
