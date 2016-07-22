# 木構造あるあるメソッドの定義
#
# 必要なのは parent, children メソッドだけ
#

require "active_support/core_ext/module/concerning"

module TreeSupport
  concern :Treeable do
    included do
      # Ruby 2.1 からこれで to_h が上書きされてしまうので
      # include TreeSupport::Treeable の前に to_h を定義している場合は注意
      if RUBY_VERSION >= "2.1"
        if respond_to?(:to_h)
          warn "include TreeSupport::Treeable によって、すでに定義されていた to_h が上書きされてしまいます。to_h が配列をハッシュ化させる目的でない場合は include TreeSupport::Treeable を to_h を定義する前に実行してください。"
        end
      end

      include Enumerable
    end

    def each(&block)
      children.each(&block)
    end

    def each_node(&block)
      return enum_for(__method__) unless block_given?
      yield self
      each {|node| node.each_node(&block)}
    end

    def descendants
      flat_map { |node| [node] + node.descendants }
    end

    def self_and_descendants
      [self] + descendants
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
      children.empty?
    end
  end
end
