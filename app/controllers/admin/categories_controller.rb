class Admin::CategoriesController < Admin::BaseController

  skip_before_filter :find_user, :except => 'index'
  before_filter :find_admin, :except => 'index'

  def index
    @categories = Category.find(:all, :conditions => ["category_name != 'Uncategorized'"]) rescue nil
    @category = Category.new if is_admin?
  end

  def create
    @cat = Category.new(params[:category])
    render :update do |page|
      if @cat.save
        page.insert_html :bottom, :categories, :partial => 'category'
        page.form.reset('category_form')
        page.replace_html :flash, "New category created"
        page.replace_html :category_error, ''
      else
        page.replace_html :category_error, @cat.errors.full_messages.join('<br />')
      end
    end
  end

  def delete
    categories = params[:selected]
    if categories.nil?
      flash[:msg] = "Select category to delete"
    else
      categories.each{|category| Category.find(category.to_i).destroy}
      flash[:msg] = "Selected categories has been deleted"
    end
    redirect_to admin_categories_path
  end

  def edit
    @category = Category.find(params[:id])
    render :update do |page|
      if @category.category_name = "Uncategorized"
        page.replace :flash, "<div id='flash'>Can not edit Uncategorized</div>"
      else
        page.replace :catform, :partial => 'edit_form'
        page.replace "category-#{@category.id}", "<div id=category-#{@category.id}></div>"
      end
    end
  end

  def update
    @cat = Category.find(params[:id])
    render :update do |page|
      if @cat.category_name = "Uncategorized"
        page.replace :flash, "<div id='flash'>can not update Uncategorized</div>"
        page.replace :catform, :partial => 'new_form'
      else
        @cat.update_attributes(params[:category])
        @category = Category.new
        page.replace :catform, :partial => 'new_form'
        page.replace "category-#{@cat.id}", :partial => 'category'
      end
    end
  end

  def cancel_edit_form
    @cat = Category.find(params[:id])
    @category = Category.new
    render :update do |page|
      page.replace "category-#{@cat.id}", :partial => 'category'
      page.replace :catform, :partial => 'new_form'
    end
  end

  def cancel_new_form
    @category = Category.new
    render :update do |page|
      page.replace :catform, :partial => 'new_form'
    end
  end

end
