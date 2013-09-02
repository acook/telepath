module Telepath
  class Handler
    def initialize command
      @command = command
    end

    def add value
      name = 'stack'

      with_store name do |container|
        container << value
      end

      [true, name]
    end

    def last
      with_store 'stack' do |container|
        container.last
      end
    end

    def lookup pattern
      with_store 'stack' do |container|
        container.find do |element|
          /#{pattern}/ =~ element.to_s
        end
      end
    end

    def index *indicies
      with_store 'stack' do |container|
        indicies.map do |index|
          container[-(index.to_i + 1)]
        end
      end
    end

    def storage
      if @storage && @storage.ready? then
        @storage
      else
        @storage = Telepath::Storage.new
      end
    end

    protected

    def with_store name = 'stack'
      container = storage.store[name] || Array.new

      result = yield container

      storage.store[name] = container
      result
    ensure
      storage.store.close
    end
  end
end
