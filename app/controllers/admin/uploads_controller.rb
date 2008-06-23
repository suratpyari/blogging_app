class Admin::UploadsController < Admin::BaseController

  def index
    @uploads = Upload.find(:all)
  end

  def new
    @upload = Upload.new
  end

  def create
    @upload = Upload.new(params[:upload])
  if @upload.save
    flash[:notice] = 'new file uploaded'
    redirect_to admin_uploads_url     
  else
    render :action => :new
  end
  end

end
