module UsersHelper
  def avatar_column(record)
    record.avatar.exists? ? image_tag(record.avatar.url(:thumb)) : ""
  end
end
