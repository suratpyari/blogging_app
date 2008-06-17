class CommentsController < ApplicationController
#include ActionView::Helpers::ActiveRecordHelper
  # Creates a new comment and set status as 0

  def create
    post = Post.find(params[:post_id])
    @comment = Comment.new(params[:comment])
    post.comments << @comment
    params[:comment].merge!({:ip=>request.remote_ip})
    if post.save
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
      end
    end
  end

end
