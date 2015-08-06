# -*- coding: utf-8 -*-
require "active_support/core_ext/module/concerning"

module TreeSupport
  concern :Treeable do
    included do
      include Enumerable
    end

    def each(&block)
      children.each(&block)
    end

    def each_node(&block)
      return enum_for(__method__) unless block_given?
      yield self
      each{|node|node.each_node(&block)}
    end

    def descendants(&block)
      return enum_for(__method__) unless block_given?
      each do |node|
        yield node
        node.descendants(&block)
      end
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

    def root?
      !parent
    end

    def leaf?
      children.size.zero?
    end
  end
end
