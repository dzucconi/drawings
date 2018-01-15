class FormatsController < ApplicationController
  before_action :require_admin!

  def index
    @formats = Format.order(created_at: :desc)
  end

  def show
    @format = Format.find(params[:id])
  end

  def edit
    @format = Format.find(params[:id])
  end

  def new
    @format = Format.new
  end

  def create
    @format = Format.new(format_params)

    if @format.save
      redirect_to formats_path, notice: 'You added a format.'
    else
      render :new
    end
  end

  def update
    @format = Format.find(params[:id])

    if @format.update(format_params)
      redirect_to @format, notice: 'You updated this format.'
    else
      render :edit
    end
  end

  def destroy
    format = Format.find(params[:id])
    format.destroy
    redirect_to formats_path
  end

  private

  def format_params
    params.require(:format).permit(
      :width,
      :height,
      :unit,
      :name
    )
  end
end
