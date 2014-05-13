module Tenon
  class ItemVersion < ActiveRecord::Base
    belongs_to :item, polymorphic: true
    belongs_to :user, foreign_key: :creator_id

    def attrs=(hash)
      super(Tenon::HasHistory::AttrSerializer.serialize(hash, self))
    end
  end
end
