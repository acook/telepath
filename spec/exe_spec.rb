require_relative 'spec_helper'

describe 'Telepath Executable' do
  let(:exe){ run "./bin/tel #{command} #{args.join ' '}" }
  let(:status){ exe.first }
  let(:output){ exe.last }

  # override these in context
  let(:command){ '' }
  let(:args){ [] }

  before do
    ENV[path_env_var] = test_path.to_s
    test_file.delete if test_file.exist?
  end

  after do
    ENV[path_env_var] = nil
    test_file.delete if test_file.exist?
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

      it do
        expect(output.stdout).to eq("Added `12' to `stack'!\n")
      end
    end
  end

  describe '=' do
    let(:command){ '=' }

    context 'without parameters' do
      context 'with values in telepath' do
        before do
          Telepath::Storage.new.store['stack'] = ['12']
        end

        specify { expect(status).to be_success }
        specify { expect(output.stdout).to eq "12\n" }
      end
    end

    context 'with parameters' do
      let(:args){ ['1'] }

      specify { expect(status).to be_success }

      specify { binding.pry; expect(output.stdout).to eq "12\n" }
    end
  end
end
