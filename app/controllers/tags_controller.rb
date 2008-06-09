class TagsController < ApplicationController

  def index
    @tags=Tag.cloud
  end

  def show
    tag=Tag.find_by_name(params[:id])
    @posts=tag.taggables
    render :partial => 'posts/post_list', :layout => 'application'
  end

end
