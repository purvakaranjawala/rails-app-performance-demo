class ReceipeInfosController < ApplicationController
  before_action :set_receipe_info, only: %i[show edit update destroy]

  # GET /receipe_infos
  def index
    @receipe_infos = ReceipeInfo.all
  end

  # GET /receipe_infos/1
  def show; end

  # GET /receipe_infos/new
  def new
    @receipe_info = ReceipeInfo.new
  end

  # GET /receipe_infos/1/edit
  def edit; end

  # POST /receipe_infos
  def create
    @receipe_info = ReceipeInfo.new(receipe_info_params)
    respond_to do |format|
      if @receipe_info.save
        format.html { redirect_to receipe_info_url(@receipe_info), notice: 'Receipe info was successfully created.' }
        format.json { render :show, status: :created, location: @receipe_info }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /receipe_infos/1
  def update
    respond_to do |format|
      if @receipe_info.update(receipe_info_params)
        format.html { redirect_to receipe_info_url(@receipe_info), notice: 'Receipe info was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receipe_infos/1
  def destroy
    @receipe_info.destroy

    respond_to do |format|
      format.html { redirect_to receipe_infos_url, notice: 'Receipe info was successfully destroyed.' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_receipe_info
    @receipe_info = ReceipeInfo.with_attached_other_images.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def receipe_info_params
    params.require(:receipe_info).permit(:title, :ingredients, :speciality,
                                         :origin, :posted_at, :content,
                                         :remove_main_image, :main_image, :recipe_id,
                                         other_images: [])
  end
end
