class TagsController < ApplicationController

  def index
    @tags=Tag.find(:all)
  end

  def show
    tag=Tag.find(params[:id]) rescue nil
    @posts=tag.taggables
  end

end
