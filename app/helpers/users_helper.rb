module UsersHelper

  def avatar_for(user, options = {version: :thumb})
    unless user.avatar.file.nil?
      version = options[:version]
      image_tag(user.avatar.url(version), alt: "#{user.name} avatar", class: "avatar")
    end
  end

end
