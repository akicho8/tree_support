# Definition of methods that are common in tree-structured interfaces
#
# All you need is parent and children methods
#

require "active_support/core_ext/module/concerning"

module TreeSupport
  concern :Treeable do
    def root
      parent ? parent.root : self
    end

    def root?
      !parent
    end

    def leaf?
      children.empty?
    end

    def each_node(&block)
      return enum_for(__method__) unless block_given?
      yield self
      children.each { |e| e.each_node(&block) }
    end

    def descendants
      children.flat_map { |e| [e] + e.descendants }
    end

    def self_and_descendants
      [self] + descendants
    end

    def ancestors
      self_and_ancestors - [self]
    end

    def self_and_ancestors
      [self] + (parent ? parent.self_and_ancestors : [])
    end

    def siblings
      self_and_siblings - [self]
    end

    def self_and_siblings
      parent ? parent.children : []
    end
  end
end
