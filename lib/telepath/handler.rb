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

      Out.info "Added `#{value}' to `#{name}'!"
    end

    def grab pattern
      value = with_store 'stack' do |container|

        if pattern && !pattern.empty? then
          if container.include? pattern.to_s then
            pattern.to_s
          else
            container.find do |element|
              /#{pattern}/ =~ element.to_s
            end
          end
        else
          stack.last
        end

      end

      if value && !value.empty? then
        Out.data value
      else
        Out.error @command, "Pattern `#{pattern}' not matched."
      end
    end

    protected

    def with_store name = 'stack'
      $s = Telepath::Storage.new
      store = $s.store
      container = store[name] || Array.new

      result = yield container

      store[name] = container
      result
    ensure
      store.close
    end
  end
end
