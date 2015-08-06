# -*- coding: utf-8 -*-
require "gviz"

# for GvizEx#output
require "pathname"
require "delegate"
require "fileutils"

require "active_support/core_ext/module/delegation"

module TreeSupport
  def self.graphviz(*args, &block)
    GraphvizBuilder.build(*args, &block)
  end

  def self.graph_open(*args, &block)
    graphviz(*args, &block).output("_output.png")
    `open _output.png`
  end

  class GraphvizBuilder
    # Gviz#save だけなぜか使いずらいため
    class GvizEx < SimpleDelegator
      def output(filename)
        filename = Pathname(filename).expand_path
        FileUtils.makedirs(filename.dirname)
        save("#{filename.dirname}/#{filename.basename(".*")}", filename.extname.delete("."))
      end

      # alias to_dot to_s はできない
      def to_dot
        to_s
      end
    end

    def self.build(object, *args, &block)
      new(*args, &block).build(object)
    end

    def initialize(options = {}, &block)
      @options = {
        :take => 256,
        :drop => 0,
      }.merge(options)
      @block = block
    end

    def build(object)
      GvizEx.new(Gviz.new).tap do |gv|
        gv.global(:rankdir => "LR", :concentrate => "true")
        visit(gv, object)
      end
    end

    private

    def visit(gv, object, depth = 0)
      if depth < @options[:take]
        if @options[:drop] <= depth
          attrs = {}
          if @block
            attrs = @block.call(object) || {}
          end
          attrs[:label] ||= TreeSupport.node_name(object)
          gv.node(node_code(object), attrs)
          if depth.next < @options[:take]
            gv.route node_code(object) => object.children.collect {|node| node_code(node) }
          end
        end
        object.children.each {|node| visit(gv, node, depth.next) }
      end
    end

    def node_code(object)
      "n#{object.object_id}"
    end
  end
end
