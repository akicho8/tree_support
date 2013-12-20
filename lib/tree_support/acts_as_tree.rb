# -*- coding: utf-8 -*-
#
# acts_as_tree の代替品
#
#   class Node < ActiveRecord::Base
#     acts_as_tree
#   end
#
require "active_support/concern"

module TreeSupport
  module ActsAsTree
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def acts_as_tree(options = {})
        return if acts_as_tree_defined?

        class_attribute :acts_as_tree_configuration
        self.acts_as_tree_configuration = {
          :order => :id,
        }.merge(options)

        if block_given?
          yield acts_as_tree_configuration
        end

        include SingletonMethods
      end

      def acts_as_tree_defined?
        ancestors.include?(SingletonMethods)
      end
    end

    module SingletonMethods
      extend ActiveSupport::Concern
      include Treeable
      include Stringify

      included do
        belongs_to :parent, :class_name => name, :foreign_key => :parent_id
        has_many :children, -> { order(acts_as_tree_configuration[:order]) }, :class_name => name, :foreign_key => :parent_id, :dependent => :destroy, :inverse_of => :parent

        scope :roots, -> { where(:parent_id => nil).order(acts_as_tree_configuration[:order]) }
      end

      module ClassMethods
        def acts_as_tree?
          acts_as_tree_defined? # && columns_hash.has_key?(:id)
        end

        def root
          roots.first
        end

        # acts_as_list との組み合わせでは destroy_all で事故るため、葉から順に消していかないといけない
        def safe_destroy_all
          roots.collect(&:destroy)
        end
      end
    end
  end
end
