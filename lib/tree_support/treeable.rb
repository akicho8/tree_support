# Definition of methods that are common in tree-structured interfaces
#
# All you need is parent and children methods
#

require "active_support/core_ext/module/concerning"

module TreeSupport
  concern :Treeable do
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
      [self] + (parent ? parent.ancestors : [])
    end

    def ancestors_without_self
      ancestors.drop(1)
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
      children.empty?
    end
  end
end
