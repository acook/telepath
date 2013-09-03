require 'clamp'

module Telepath
  class CommandLine
    class Command < Clamp::Command

      # GLOBAL OPTIONS

      option ['-q', '--quiet'], :flag, 'Only output when absolutely necessary.',
        environment_variable: 'TELEPATH_QUIET', default: false

      option ['-f', '--file'], 'FILE', 'Filename of the Teleport store file.',
        environment_variable: 'TELEPATH_FILE', default: Telepath::Storage::DEFAULT_FILE

      option ['-p', '--path'], 'PATH', 'Path where the the Teleport store file is located.',
        environment_variable: 'TELEPATH_PATH', default: Telepath::Storage::DEFAULT_PATH

      # HELPERS

      def setup_environment
        # quiet
        # timeout
        # file
        # path
      end

      def handler
        @handler ||= Telepath::Handler.new self
      end

      def data_out value, failure_message
        if value then
          Out.data value
        else
          Out.error self, failure_message
        end
      end

    end

    class Add < Command
      parameter '[ITEM] ...', 'item to add', attribute_name: 'items'

      option ['-t', '--timeout'], 'TIMEOUT', 'How long to wait for stdin (in seconds).',
        environment_variable: 'TELEPATH_TIMEOUT', default: 1

      def execute
        container = 'stack'
        values    = self.items || Array.new

        values << read_stdin if stdin?

        Out.error self, "No values supplied!" if values.empty?

        values.each do |value|
          handler.add value, container
          # check that value was added correctly, individually?
        end

        info values, container
      end

      def info values, container
        value_text = values.length == 1 ? values.first : "[#{values.join ', '}]"
        Out.info "Added #{value_text} to #{container}!"
      end

      def read_stdin
        $stdin.read.strip if stdin?
      end

      def stdin?
        if not $stdin.tty? then
          buffered = IO.select([$stdin], [], [], timeout)
          buffered && buffered.first && buffered.first.first
        end
      end

      # check that values were added, as a group?
      #def verify_values_added values
      #  failures = values.reject.with_index{|_, i| results[i].first}
      #  Out.error self, "Could not add [#{failures.map().join ', '}] to `#{container}'!"
      #end
    end

    class Lookup < Command
      parameter '[PATTERN]', 'pattern to find'

      def execute
        data_out handler.lookup(pattern),
          "Pattern `#{pattern}' not matched."
      end
    end

    class Last < Command
      parameter '[COUNT]', 'number of most recent items to get',
        default: 1 do |c|
          Integer c
        end

      def execute
        data_out handler.last(count),
          "Telepath is empty, is your storage location configured properly?"
      end
    end

    class Index < Command
      parameter 'INDEX ...', 'index of item, starting from most recent (0)',
        attribute_name: :indicies do |i|
          Integer i
        end

      def execute
        data_out handler.index(*indicies),
          "Hmm, couldn't find anything at that index."
      end
    end

    class List < Command
      parameter '[CONTAINER] ...', 'container to list contents of',
        attribute_name: :containers

      def execute
        data_out handler.list(*containers),
          "Container empty (or no container with that name)."
      end
    end

    class Main < Command
      subcommand ['+', 'add'], 'Add item', Add
      subcommand ['?', 'lookup'], 'Look up item by pattern', Lookup
      subcommand ['$', 'last'], 'Get most recent item', Last
      subcommand ['@', 'index'], 'Get item from (reverse) index', Index
      subcommand ['list'], 'List known containers and contents', List
    end
  end
end
