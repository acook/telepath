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
      @path ||= Pathname.new(get :path).expand_path
    end

    def file
      @file ||= get :file
    end

    def type
      @type ||= get :type
    end

    protected

    def create_store
      Moneta.new type, file: location
    end

    def get name
      env_name   = "TELEPATH_#{name.to_s.upcase}"
      const_name = "DEFAULT_#{name.to_s.upcase}"
      value      = ENV[env_name]

      value && !value.empty? && value || self.class.const_get(const_name)
    end

  end
end
