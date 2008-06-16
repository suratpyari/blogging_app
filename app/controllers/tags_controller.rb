class TagsController < ApplicationController

  def index
    @tags=Tag.cloud
  end

  def show
    tag=Tag.find_by_name(params[:id])
    if tag
      @posts=tag.taggables
      render :partial => 'posts/post_list', :layout => 'application'
    else
      flash[:msg] = "This tag does not exists"
      redirect_to "/"
    end
  end

end
