module Telepath
  class Handler
    def initialize command
      @command = command
    end

    def add value, name = 'stack'
      with_store name do |container|
        container << value
        container.last
      end
    end

    def last count = nil
      with_store 'stack' do |container|
        if count.nil? then
          container.last
        else
          container.last count
        end
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

    def list *containers
      c = containers.first

      if c then
        with_store c do |container|
          rev_array container
        end
      else
        rev_array storage.store.adapter.backend.keys
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

    def rev_array list_of_things
      Array(list_of_things).reverse
    end

    def with_store name = 'stack'
      container = storage.store[name] || Array.new

      result = yield container

      storage.store[name] = container if present? container
      result
    ensure
      storage.store.close
    end

    def present? value
      !!value && ((value.respond_to?(:empty?) || true) && !value.empty?)
    end
  end
end
