require_relative 'spec_helper'

describe Telepath::Handler do
  before { pre_test_setup }
  after  { post_test_teardown }

  subject(:handler){ described_class.new double(Clamp::Command) }

  let(:storage){ Telepath::Storage.new }
  let(:value){ 'whatever' }
  let(:next_value){ 'all your bass' }
  let(:default_container){ 'stack' }

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

    it 'returns the value added according to the database' do
      expect( handler.add 999 ).to eq 999
    end

    context 'with container specified' do
      let(:container){ 'keepsafe' }
      let(:not_in_stack){ 'are belong to us' }

      before do
        handler.add not_in_stack, container
      end

      it do
        expect(handler.list container).to include not_in_stack
      end

      it do
        expect(handler.list).not_to include not_in_stack
      end
    end

  end

  describe '#last' do
    it 'returns the last value' do
      expect(handler.last).to eq(next_value)
    end

    it 'does not delete the item' do
      store_unchanged { handler.last }
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
      store_unchanged { handler.index 1 }
    end

    context 'multiple indicies' do
      it 'should return the items in the same order specified' do
        expect(handler.index 0, 1).to eq [next_value, value]
      end
    end
  end

  describe '#lookup' do
    it 'does not delete the item' do
      store_unchanged { handler.lookup value }
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

  describe '#list' do

    let(:other_container){ 'keepsafe' }

    before do
      handler.add 'not_in_stack', other_container
    end

    it 'does not alter the store' do
      store_unchanged { handler.list; handler.list default_container }
    end

    context 'without specifying a container' do
      it do
        expect(handler.list).to eq([other_container, default_container])
      end
    end

    context 'with container specified' do
      it do
        expect(handler.list default_container).to eq ['all your bass', 'whatever']
      end
    end
  end
end
