class CommentsController < ApplicationController
#include ActionView::Helpers::ActiveRecordHelper
  # Creates a new comment and set status as 0

  verify :method => :post, :only => [:create, :accept], :redirect_to => {:controller => 'post', :action => 'index'}
  verify :method => :delete, :only => :destroy, :redirect_to => {:controller => 'post', :action => 'index'}

  def create
    @comment = Comment.new(params[:comment])
    render :update do |page|
      if @comment.save
        page.replace_html :comment_errors , ''
        page.form.reset('comment_form')
      else
        page.replace_html :comment_errors ,
                          @comment.errors.full_messages.join('<br />')
      end
      if @comment.status == 2
        flash[:msg] = "This spam has been subbmitted"
      else
        flash[:msg] = "This comment has been subbmitted"
      end
      page.replace_html :flash , flash[:msg]
    end
  end

  # Accepts comment
  def accept
    comment = Comment.find(params[:id])
    comment.status = 1
    comment.save
    p comment.status
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
