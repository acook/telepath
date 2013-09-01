require_relative 'spec_helper'

describe 'Telepath Executable' do
  let(:exe){ run "./bin/tel #{command} #{args.join ' '}" }
  let(:status){ exe.status }
  let(:stdout){ exe.stdout.strip }

  # override these in context
  let(:command){ '' }
  let(:args){ [] }

  before do
    pre_test_setup
  end

  after do
    post_test_teardown
  end

  it 'runs' do
    expect(status).to be_success
  end

  context 'invalid arguments' do
    let(:args){ ['invalid_argument'] }
    specify { expect(status).to_not be_success }
  end

  describe '+' do
    let(:command){ :+ }

    context 'without value' do
      specify { expect(status).to_not be_success }
    end

    context 'with value' do
      let(:args){ ['12'] }

      specify { expect(status).to be_success }

      it 'adds the value to the stack' do
        expect(stdout).to eq("Added `12' to `stack'!")
      end
    end
  end

  describe '=' do
    let(:command){ '=' }
    let(:handler){ Telepath::Handler.new double(Clamp::Command) }
    let(:value){ '12' }

    before do
      handler.add value
    end

    context 'without parameters' do
      context 'with values in telepath' do

        specify { expect(status).to be_success }
        specify { expect(stdout).to eq value }
      end
    end

    context 'with parameters' do
      let(:args){ ['1'] }

      specify { expect(status).to be_success }
      specify { expect(stdout).to eq value }
    end
  end
end
