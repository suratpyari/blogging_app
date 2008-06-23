module Admin::PostsHelper

  def new_attachment_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :attachment, :partial => 'upload' , :object => Upload.new
    end    
  end

end
