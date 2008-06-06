class Admin::CategoriesController < Admin::BaseController

  before_filter :find_admin, :except => 'index'

  def index
    @categories = Category.find(:all)
    if is_admin?
      @category = Category.new
    end
  end

  def create
    @cat = Category.new(params[:category])
    render :update do |page|
      if @cat.save
        flash[:msg] = "New category created"
        page.insert_html :bottom, :categories, :partial => 'category'
        page.form.reset('category_form')
        page.replace_html :flash, flash[:msg]
        page.replace_html :category_error, ''
      else
        page.replace_html :category_error, @cat.errors.full_messages.join('<br />')
      end
    end
  end

  def destroy
    @category = Category.find(params[:id]) rescue nil
    render :update do |page|
      if @category && @category.category_name != 'Uncategorized'
        @category.destroy
        flash[:msg] = "#{@category.category_name} deleted"
        page.replace_html "category-#{@category.id}", ''
      else if @category.nil?
          flash[:msg] = "This category does not exists"
        else 
          flash[:msg] = "You can not delete this category"
        end
      end
      page.replace_html :flash, flash[:msg]
    end
  end

end
