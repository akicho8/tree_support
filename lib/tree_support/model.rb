# -*- coding: utf-8 -*-
require "active_support/concern"

module TreeSupport
  module Model
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

    def ancestors
      [self] + (parent ? parent.ancestors : [])
    end

    def root
      parent ? parent.root : self
    end

    def siblings
      self_and_siblings - [self]
    end

    def self_and_siblings
      parent ? parent.children : []
    end

    def to_s_tree(options = {}, &block)
      Inspector.tree(self, options, &block)
    end
  end
end
