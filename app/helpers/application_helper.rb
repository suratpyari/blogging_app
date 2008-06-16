# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  require 'digest/md5'

  def gravatar_url_for(email, options = {})    
    url_for({ :gravatar_id => Digest::MD5.hexdigest(email),
            :host => 'www.gravatar.com',
            :protocol => 'http://',
            :only_path => false,
            :controller => 'avatar.php'}.merge(options))  
  end

  def current(page)
    'current' if controller.controller_name==page
  end

  def build_tag_cloud(tags)
    max, min = 30, 10
    x = ((max - min) / tags.length)
    for i in 0...(tags.length)
      if i != 0 && tags[i - 1].popularity.to_i > tags[i].popularity.to_i
        max=max - x
      end
      yield tags[i].name, max.to_s+'px'
    end
  end

end
