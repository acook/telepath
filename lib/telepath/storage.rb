require 'moneta'
require 'daybreak'

module Telepath
  class Storage

    DEFAULT_PATH = '~'
    DEFAULT_FILE = '.telepath.db'
    DEFAULT_TYPE = :Daybreak

    attr_accessor :file, :path

    def stack
      store['stack'] || Array.new
    end

    def store
      if ready? then
        @store
      else
        @store = create_store
      end
    end

    def ready?
      !!@store && !@store.adapter.backend.closed?
    end

    def close!
      @store.close if @store.respond_to? :close
      @store = nil
    end

    ### -----

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

    def path
      @path || set_path
    end

    def path= new_path
      set_path new_path
    end

    def file
      @file ||= DEFAULT_FILE
    end

    def type
      @type ||= DEFAULT_TYPE
    end

    protected

    def set_path new_path = nil
      @path = Pathname.new(new_path || DEFAULT_PATH).expand_path
    end

    def create_store
      Moneta.new type, file: location
    end

    def get name
      const_name = "DEFAULT_#{name.to_s.upcase}"

      value && !value.empty? && value || self.class.const_get(const_name)
    end

  end
end
