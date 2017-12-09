# acts_as_tree replacement
#
#   class Node < ActiveRecord::Base
#     ar_tree_model                                                 # default
#     ar_tree_model scope: -> { order(:name) }                      # Designate the scope yourself
#     ar_tree_model scope: -> { order(:id).where(:active => true) } # You can also specify where
#   end
#
require "active_support/concern"

module TreeSupport
  module ArTreeModel
    extend ActiveSupport::Concern

    included do
    end

    class_methods do
      def ar_tree_model(options = {})
        return if ar_tree_model_defined?

        class_attribute :ar_tree_model_configuration
        self.ar_tree_model_configuration = {
          scope: -> { order(:id) },
        }.merge(options)

        if block_given?
          yield ar_tree_model_configuration
        end

        include SingletonMethods
      end

      def ar_tree_model_defined?
        ancestors.include?(SingletonMethods)
      end
    end

    concern :SingletonMethods do
      include Treeable
      include Stringify

      included do
        scope :tree_default_scope, ar_tree_model_configuration[:scope]

        belongs_to :parent, -> { tree_default_scope }, class_name: name, foreign_key: :parent_id, required: false
        has_many :children, -> { tree_default_scope }, class_name: name, foreign_key: :parent_id, dependent: :destroy, inverse_of: :parent
        scope :roots, -> { tree_default_scope.where(parent_id: nil) }
      end

      class_methods do
        def ar_tree_model?
          ar_tree_model_defined? # && columns_hash.has_key?(:id)
        end

        def root
          roots.first
        end

        # In combination with acts_as_list accident in destroy_all, we have to erase from the leaves in order
        def safe_destroy_all
          roots.collect(&:destroy)
        end

        def destroy_all(*args)
          if respond_to?(:acts_as_list)
            ActiveSupport::Deprecation.warn("When you use acts_as_list destroy_all do not get id failed to accidentally delete_all Please use safe_destroy_all to erase from the end")
          end
          super
        end
      end
    end
  end
end
