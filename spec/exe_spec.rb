require_relative 'spec_helper'

describe 'Telepath Executable' do
  let(:exe){ run "./bin/tel #{args.join ' '}" }
  let(:status){ exe.first }
  let(:output){ exe.last }
  let(:args){ [] } # override this in context

  it 'runs' do
    expect(status).to be_success
  end

  context 'invalid arguments' do
    let(:args){ ['invalid_argument'] }
    specify { expect(status).to_not be_success }
  end
end
