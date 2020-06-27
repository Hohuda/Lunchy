require_relative 'users_helper.rb'

module ApplicationHelper

  def avatar_for(model, options = {version: :full_sized})
    version = options[:version]
    if !model.avatar.file.nil? 
      image_tag(model.avatar.url(version), 
                alt: "#{model.name} avatar",
                class: "rounded-circle d-block")
    elsif model.class.to_s == 'User'
      image_tag(model.avatar.default_avatar_url(version), 
                class: "rounded-circle d-block")
    elsif model.class.to_s == 'Victual'
      image_tag(model.avatar.default_avatar_url(version), 
                class: "rounded-circle d-block")
    end
  end
  
end
