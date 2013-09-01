module Telepath
  module Out
    module_function

    def info *messages
      puts messages.flatten.join ' '
    end

    def data *messages
      puts messages.flatten
    end

    def error command, *messages
      raise Clamp::UsageError.new(messages.flatten.join("\n"), command)
    end

  end
end
