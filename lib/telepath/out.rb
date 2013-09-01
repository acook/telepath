module Telepath
  module Out
    module_function

    def info *args
      puts args.flatten.join ' '
    end

    def data *args
      puts args.flatten
    end

    def error *args
      command = args.shift if args.length > 1
      raise Clamp::UsageError.new(args.flatten.join("\n"), command)
    end
  end
end
