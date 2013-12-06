require "active_support/concern"

module TreeSupport
  module Treeable
    extend ActiveSupport::Concern

    included do
      include Enumerable
    end

    module ClassMethods
      def each_node(root, &block)
        return enum_for(__method__, root) unless block_given?
        yield root
        root.each{|v|each_node(v, &block)}
      end
    end

    def each(&block)
      children.each(&block)
    end

    def each_node(&block)
      self.class.each_node(self, &block)
    end
  end
end
