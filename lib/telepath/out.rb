module Telepath
  module Out
    module_function

    def info *messages
      puts messages.flatten.join ' ' unless quiet?
    end

    def data *messages
      puts messages.flatten
    end

    def error command, *messages
      raise Clamp::UsageError.new(messages.flatten.join("\n"), command) unless quiet?
    end

    def quiet!
      @quiet = true
    end

    def unquiet!
      @quiet = false
    end

    def quiet?
      @quiet
    end

  end
end
