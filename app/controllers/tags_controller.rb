class TagsController < ApplicationController

  def index
    @tags=Tag.find(:all)
  end

  def show
    tag=Tag.find_by_name(params[:id])
    @posts=tag.taggables
  end

end
