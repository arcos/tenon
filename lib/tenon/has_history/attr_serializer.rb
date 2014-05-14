module Tenon
  module HasHistory
    class AttrSerializer
      def self.serialize(attrs, item_version)
        new(attrs, item_version).serialize
      end

      def initialize(attrs, item_version)
        @attrs = attrs
        @item_version = item_version
        @item = @item_version.item
      end

      def serialize
        Marshal.dump(filtered_attrs)
      end

      private

      def filtered_attrs
        @attrs.deep_reject_key!(:id)
        @attrs.deep_reject_key!('id')
        require_only_attrs! unless @item.has_history_only.empty?
        remove_except_attrs! unless @item.has_history_except.empty?
        remove_children!
        @attrs
      end

      def require_only_attrs!
        @attrs = @attrs.select do |k, v|
          @item.has_history_only.include?(k)
        end
      end

      def remove_except_attrs!
        @attrs = @attrs.reject do |k, v|
          @item.has_history_except.include?(k.to_sym)
        end
      end

      def remove_children!
        includes = @item.has_history_includes.map(&:to_s)
        @attrs = @attrs.reject do |k, v|
          key = k.to_s
          relation = key.gsub(/_attributes$/, '')
          key.match(/_attributes$/) && !includes.include?(relation)
        end
      end
    end
  end
end
