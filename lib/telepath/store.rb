require 'moneta'
require 'daybreak'

module Telepath
  class Store

    class << self
      def path
        Pathname.new('~/').expand_path
      end

      def file
        '.telepath.db'
      end

      def location
        path.join file
      end


      def create
        new Moneta.new :Daybreak, file: location
      end
    end

    def initialize store
      @store = store
    end

    protected

    attr_accessor :store

  end
end
