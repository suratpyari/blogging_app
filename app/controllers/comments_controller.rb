class CommentsController < ApplicationController

  # Creates a new comment and set status as 0
  def create
    @comment = Comment.new(params[:comment])
    render :update do |page|
      if @comment.save
        flash[:msg] = 'New comment created'
        page.replace_html :comment_errors , ''
        page.form.reset('comment_form')
      else
        flash[:msg] = 'New comment not created'
        page.replace_html :comment_errors , @comment.errors.full_messages.join('<br />')
      end
      page.replace_html :flash , flash[:msg]
    end
  end

  def accept
    comment = Comment.find(params[:id])
    comment.status = 1
    comment.save
    p comment.status
    render :update do |page|
      page.replace_html 'status-'+comment.id.to_s, ''
    end
  end

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
