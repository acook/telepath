require_relative 'spec_helper'

describe Telepath::Out do
  describe '.info' do
    it 'outputs to stdout' do
      expect(capture { described_class.info 'omghai' }).to eq "omghai\n"
    end

    context 'when quiet' do
      it 'does not output at all' do
        expect(capture { described_class.quiet!; described_class.info 'omghai' }).to eq ''
      end
    end
  end

  describe '.data' do
    it 'outputs to stdout' do
      expect(capture { described_class.data 'derp' }).to eq "derp\n"
    end
  end

  describe '.error' do
    it 'raises an error' do
      expect{ described_class.error double, 'zomg' }.to raise_error Clamp::UsageError
    end

    context 'when quiet' do
      it 'does not raise an error' do
        expect{ described_class.quiet!; described_class.error double 'zomg' }.to_not raise_error
      end
    end
  end
end
