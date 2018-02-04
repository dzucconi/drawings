class ProductionFilesController < ApplicationController
  before_action :require_admin!, :find_drawing

  def index
    @production_files = @drawing.production_files.order(created_at: :desc)
  end

  def show
    @production_file = @drawing.production_files.find(params[:id])
  end

  def edit
    @production_file = @drawing.production_files.find(params[:id])
  end

  def new
    @production_file = @drawing.production_files.new
  end

  def create
    @production_file = @drawing.production_files.new(production_file_params)

    if @production_file.save
      @production_file.put(upload) if upload.present?
      redirect_to @drawing, notice: 'You added a production file.'
    else
      render :new
    end
  end

  def update
    @production_file = @drawing.production_files.find(params[:id])

    if @production_file.update(production_file_params)
      @production_file.put(upload) if upload.present?
      redirect_to @drawing, notice: 'You updated this production file.'
    else
      render :edit
    end
  end

  def destroy
    production_file = ProductionFile.find(params[:id])
    production_file.destroy
    redirect_to @drawing
  end

  private

  def find_drawing
    @drawing = Drawing.find(params[:drawing_id])
  end

  def production_file_params
    params.require(:production_file).permit(
      :name
    ).merge!(upload_params)
  end

  def upload_params
    return {} unless upload.present?

    @upload_params ||= begin
      {
        attachment_filename: upload.original_filename,
        attachment_filesize: upload.size,
        attachment_content_type: upload.content_type
      }
    end
  end

  def upload
    @upload ||= params.require(:production_file).permit(:attachment)[:attachment]
  end
end
