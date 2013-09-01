require 'clamp'

module Telepath
  class Command < ::Clamp::Command

    option ['-q', '--quiet'], :flag, "Only output when absolutely necessary."

    subcommand ['+'], 'Add item to Telepath' do
      parameter 'VALUE', 'value to add'

      def execute
        handler = Telepath::Handler.new self
        handler.add value
      end
    end

    subcommand ['='], 'Grab item from Telepath' do
      parameter '[PATTERN]', 'pattern to find'

      def execute
        handler = Telepath::Handler.new self
        handler.grab pattern
      end
    end

    def execute
      exit 1
    end

  end
end
