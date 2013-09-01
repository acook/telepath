require_relative 'spec_helper'

describe Telepath::Handler do
  before { pre_test_setup }
  after  { post_test_teardown }

  subject(:handler){ described_class.new double(Clamp::Command) }

  let(:storage){ Telepath::Storage.new }

  it 'exists' do
    expect(described_class).to be
  end

  after do
    storage.store.close unless storage.store.adapter.backend.closed?
  end

  describe '#add' do
    it 'adds 1 item' do
      expect{ handler.add 'whatever' }.to change{
        storage.store.adapter.backend.sunrise
        storage.stack.length
      }.from(0).to(1)
    end

    it 'adds the right item' do
      handler.add 'whatever'
      expect(storage.stack).to include('whatever')
    end
  end

  describe '#grab' do
    let(:value){ 'whatever' }
    before do
      handler.add value
    end

    it 'grabs last value' do
      expect(handler.grab).to eq(value)
    end

    it 'does not delete the item' do
      expect{ handler.grab value }.to change{
        storage.store.adapter.backend.sunrise
        storage.stack.length
      }.by(0)
    end

    context 'pattern matching' do
      it 'matches substrings of words' do
        expect(handler.grab('what')).to eq(value)
      end

      context 'numbers' do
        let(:value){ '12' }

        it 'matches parts of numbers' do
          expect(handler.grab('1')).to eq(value)
        end
      end
    end
  end
end
