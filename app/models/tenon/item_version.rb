module Tenon
  class ItemVersion < ActiveRecord::Base
    default_scope -> { order('created_at DESC') }
    scope :autosave, -> { where('save_type = ?', 'autosave') }
    belongs_to :item, polymorphic: true
    belongs_to :user, foreign_key: :creator_id
    before_create :destroy_old_autosave

    def attrs=(hash)
      super(Tenon::HasHistory::AttrSerializer.serialize(hash, self))
    end

    private

    def destroy_old_autosave
      same_user_autosave.destroy_all if save_type == 'autosave'
    end

    def same_user_autosave
      item.versions.autosave.where(creator_id: creator_id)
    end
  end
end
