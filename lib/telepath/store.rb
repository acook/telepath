require 'moneta'
require 'daybreak'

module Telepath
  class Store

    PATH_VAR = 'TELEPATH_PATH'
    FILE_VAR = 'TELEPATH_FILE'
    DEFAULT_PATH = '~'
    DEFAULT_FILE = '.telepath.db'

    class << self
      def path
        Pathname.new(ENV[PATH_VAR] || DEFAULT_PATH).expand_path
      end

      def file
        ENV[FILE_VAR] || DEFAULT_FILE
      end

      def location
        if path.exist? then
          path.join file
        else
          raise <<-ERRMSG
            Create or change the storage path for Telepath.
            Current: `#{path}'
            Environment Variable Name: `#{PATH_VAR}'
          ERRMSG
        end
      end


      def create
        new Moneta.new :Daybreak, file: location
      end
    end

    def initialize store
      @store = store
    end

    def close
      @store.close if @store
    end

    protected

    attr_accessor :store

  end
end
