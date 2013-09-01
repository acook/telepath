require 'clamp'

module Telepath
  class Command < ::Clamp::Command

    option ['-q', '--quiet'], :flag, 'Only output when absolutely necessary.',
      environment_variable: 'TELEPORT_QUIET', default: false

    option ['-f', '--file'], 'FILE', 'Filename of the Teleport store file.',
      environment_variable: 'TELEPORT_FILE', default: Telepath::Storage::DEFAULT_FILE

    option ['-p', '--path'], 'PATH', 'Path where the the Teleport store file is located.',
      environment_variable: 'TELEPORT_PATH', default: Telepath::Storage::DEFAULT_PATH

    subcommand ['+', 'add'], 'Add item' do
      parameter '[VALUE] ...', 'value to add', attribute_name: 'values'

      def execute
        handler = Telepath::Handler.new self
        values = self.values || Array.new

        unless $stdin.tty? then
          buffered = IO.select([$stdin], [], [], 1)
          values << $stdin.read.strip if buffered && buffered.first && buffered.first.first
        end

        Out.error self, "No values supplied!" if values.empty?

        results = values.map do |value|
          handler.add value
        end

        success = results.all?{|r|r.first}
        name    = results.first.last

        if success then
          Out.info "Added [#{values.map(&:inspect).join ', '}] to `#{name}'!"
        else
          failures = values.reject.with_index{|_, i| results[i].first}
          Out.error self, "Could not add [#{failures.map().join ', '}] to `#{name}'!"
        end
      end
    end

    subcommand ['?', 'lookup'], 'Look up item by pattern' do
      parameter '[PATTERN]', 'pattern to find'

      def execute
        handler = Telepath::Handler.new self
        value = handler.lookup pattern

        if value && !value.empty? then
          Out.data value
        else
          Out.error self, "Pattern `#{pattern}' not matched."
        end
      end
    end

    subcommand ['$', 'last'], 'Get most recent item' do
      def execute
        handler = Telepath::Handler.new self
        value = handler.last

        if value && !value.empty? then
          Out.data value
        else
          Out.error self, "Telepath is empty, is your storage location configured properly?"
        end
      end
    end

    subcommand ['@', 'index'], 'Get item from (reverse) index' do
      parameter 'INDEX ...', 'index of item, starting from most recent (0)',
        attribute_name: :indicies do |i|
          Integer(i)
        end

      def execute
        handler = Telepath::Handler.new self
        index = indicies.first
        value = handler.index index

        if value && !value.to_s.empty? then
          Out.data value
        else
          Out.error self, "Hmm, couldn't find anything at that index."
        end
      end
    end

    def execute
      exit 1
    end

  end
end
