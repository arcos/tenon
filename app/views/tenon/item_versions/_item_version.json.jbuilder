json.title item_version.title.blank? ? "(No Title)" : item_version.title
json.created_at item_version.created_at.strftime('%m/%d/%Y at %l:%M%p')
json.user_email item_version.user.try(:email)
json.load_link action_link('View Draft', polymorphic_path([:edit, item_version.item], version: item_version.id), 'reply')