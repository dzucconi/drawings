class DrawingsController < ApplicationController
  before_action :require_admin!, except: [:index, :show]

  def index
    @drawings = Drawing.order(created_at: :desc)
  end

  def show
    @drawing = Drawing.find(params[:id])
  end

  def edit
    @drawing = Drawing.find(params[:id])
  end

  def new
    @drawing = Drawing.new
  end

  def create
    @drawing = Drawing.new(drawing_params)

    if @drawing.save
      @drawing.put(upload) if upload.present?
      redirect_to drawings_path, notice: 'You added a drawing.'
    else
      render :new
    end
  end

  def update
    @drawing = Drawing.find(params[:id])

    if @drawing.update(drawing_params)
      @drawing.put(upload) if upload.present?
      redirect_to @drawing, notice: 'You updated this drawing.'
    else
      render :edit
    end
  end

  def destroy
    drawing = Drawing.find(params[:id])
    drawing.destroy
    redirect_to drawings_path
  end

  private

  def drawing_params
    params.require(:drawing).permit(
      :title,
      :format_id
    ).merge!(upload_params)
  end

  def upload_params
    return {} unless upload.present?

    @upload_params ||= begin
      width, height = FastImage.size(upload)

      {
        image_width: width,
        image_height: height,
        image_filename: upload.original_filename,
        image_filesize: upload.size,
        image_content_type: upload.content_type
      }
    end
  end

  def upload
    @upload ||= params.require(:drawing).permit(:image)[:image]
  end
end
