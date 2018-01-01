class DrawingsController < ApplicationController
  # TODO: Authentication
  # TODO: Error handling

  def index
    @drawings = Drawing.all
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
    drawing = Drawing.create!(drawing_params)
    drawing.put(upload)
    redirect_to drawings_path
  end

  def update
    drawing = Drawing.find(params[:id])
    drawing.update!(drawing_params)
    redirect_to :back
  end

  def destroy
    drawing = Drawing.find(params[:id])
    drawing.destroy
    redirect_to :back
  end

  private

  def drawing_params
    params.require(:drawing).permit(
      :title,
      :width,
      :height,
      :units
    ).merge!(upload_params)
  end

  def upload_params
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
