# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def current(page)
    'current' if controller.controller_name==page
  end

  def tags
    tags = Tag.find(:all)
    return tags
  end

end
