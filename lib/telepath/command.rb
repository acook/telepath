require 'clamp'

module Telepath
  class Command < ::Clamp::Command

    option ['-q', '--quiet'], :flag, "Only output when absolutely necessary."

    subcommand ['+'], 'Add item to Telepath' do
      parameter 'VALUE', 'value to add'

      def execute
        handler = Telepath::Handler.new self
        success, name = handler.add value

        if success then
          Out.info "Added `#{value}' to `#{name}'!"
        else
          Out.error "Could not add `#{value}' to `#{name}'!"
        end
      end
    end

    subcommand ['='], 'Grab item from Telepath' do
      parameter '[PATTERN]', 'pattern to find'

      def execute
        handler = Telepath::Handler.new self
        value = handler.grab pattern

        if value && !value.empty? then
          Out.data value
        else
          Out.error @command, "Pattern `#{pattern}' not matched."
        end
      end
    end

    def execute
      exit 1
    end

  end
end
