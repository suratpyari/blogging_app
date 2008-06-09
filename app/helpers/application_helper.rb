# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def current(page)
    'current' if controller.controller_name==page
  end

#  def tag_cloud
 #   tags=Tag.find(:all)
  #  tag_hash = Hash.new
   # for tag in tags
    #  tag_hash[tag.name]=tag.taggings.size
#    end
 #   tag_cloud=tag_hash.sort{|a,b| b[1]<=>a[1]}
  #  tag_cloud.delete_if{|key, value| value == 0}
   # return tag_cloud
#  end

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
