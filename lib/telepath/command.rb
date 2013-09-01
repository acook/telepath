require 'clamp'

module Telepath
  class Command < ::Clamp::Command

    option ['-q', '--quiet'], :flag, "Only output when absolutely necessary."

    subcommand ['+'], 'Add item to Telepath' do
      parameter 'VALUE', 'value to add'

      def execute
        $s = Storage.new
        store = $s.store

        key = 'stack'

        store[key] ||= []
        stack = store[key]
        stack << value
        store[key] = stack

        Out.info "Added `#{value}' to `#{key}'!"

        store.close
      end
    end

    subcommand ['='], 'Grab item from Telepath' do
      parameter '[PATTERN]', 'pattern to find'

      def execute
        $s = Storage.new
        store = $s.store

        key = 'stack'
        store[key] ||= []
        stack = store[key]

        if pattern && !pattern.empty? then
          value = stack.include? pattern.to_s

          unless value then
            value = stack.find do |element|
               /#{pattern}/ =~ element.to_s
            end
          end
        else
          value = stack.last
        end

        if value && !value.empty? then
          Out.data value
        else
          store.close
          Out.error self, "Pattern `#{pattern}' not matched."
        end

        store.close
      end
    end

    def execute
      exit 1
    end

  end
end
