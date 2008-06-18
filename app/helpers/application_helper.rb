# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  require 'digest/md5'

  def gravatar_url_for(email, options = {})    
    url_for({ :gravatar_id => Digest::MD5.hexdigest(email),
            :host => 'www.gravatar.com',
            :protocol => 'http://',
            :only_path => false,
            :controller => '/avatar.php'}.merge(options))  
  end

  def current(page)
    'current' if controller.controller_name==page
  end

  # Creates a tag cloud according to the popularity of tags
  def build_tag_cloud(tags)
    max, min = 30, 10 # font size of tags
    popularity = []
    tags.each{|t| (popularity << t.popularity)}
    x = ((max - min) / popularity.uniq.length)
    for i in 0...(tags.length)
      if i != 0 && tags[i - 1].popularity.to_i > tags[i].popularity.to_i
        max=max - x # Setting font size
      end
      yield tags[i].name, max.to_s+'px'
    end
  end

  # lists those comments which are given either on current user's post or having status 1
  # admin can see all the comments 
  def users_comments(post_id)
    @comments = []
    comments = Post.find(post_id).comments
    for comment in comments
      if (is_admin? || comment.commentable.user == current_user)
        @comments << comment
      end
    end
    @comments
  end

  def recent_posts
    Post.find(:all, :limit => 10, :order => "created_at DESC")
  end

end
