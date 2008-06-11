class CommentsController < ApplicationController
#include ActionView::Helpers::ActiveRecordHelper
  # Creates a new comment and set status as 0

  verify :method => :post, :only => [:create, :accept], :redirect_to => {:controller => 'posts', :action => 'index'}
  verify :method => :delete, :only => :destroy, :redirect_to => {:controller => 'posts', :action => 'index'}

  def create
    @comment = Comment.new(params[:comment])
    @comment.commentable_type = "post"
    @comment.commentable_id = params[:post_id]
    if @comment.save
      if @comment.status == 2
        msg = "Your comment looks like spam and will show up once admin approves"
      else
        msg = "This comment has been submitted"
      end
      render :update do |page|
        page.replace_html :comment_errors, ''
        page.form.reset('comment_form')
        page.replace_html :flash , msg
      end
    else
      render :update do |page|
        page.replace_html :comment_errors, @comment.errors.full_messages.join('<br />')
        msg = ""
       page.replace_html :flash , msg
      end
    end
  end

  # Accepts comment
  def accept
    comment = Comment.find(params[:id])
    comment.update_attribute('status', 1)
    render :update do |page|
      page.replace_html 'status-'+comment.id.to_s, ''
    end
  end

  # Destroy comment 
  def destroy
    comment = Comment.find(params[:id])
    render :update do |page|
      if comment.commentable.user == current_user || is_admin?
        comment.destroy
        page.replace_html :flash, 'comment deleted'
        page.replace_html 'comment-'+comment.id.to_s, ''
      else
        page.replace_html :flash, 'Cannot delete this comment'
      end
    end
  end
end
