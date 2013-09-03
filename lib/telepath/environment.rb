module Telepath
  class Environment
    def initialize
      @storage = Telepath::Storage.new self
      @handler = Telepath::Handler.new self
      @command = Telepath::CommandLine
    end
    attr :storage, :handler, :command
  end
end
