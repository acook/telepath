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

        if pattern && !pattern.empty? then
          if container.include? pattern.to_s then
            pattern.to_s
          else
            container.find do |element|
              /#{pattern}/ =~ element.to_s
            end
          end
        else
          container.last
        end

      end
    end

    def index *indicies
      index = indicies.first

      with_store 'stack' do |container|
        container[-(index.to_i + 1)]
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
