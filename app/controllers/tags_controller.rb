class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tag, only: %i[show edit update destroy]

  def index
    @tags = current_user.tags.order(:title)
  end

  def show
  end

  def new
    @tag = current_user.tags.new
  end

  def create
    @tag = current_user.tags.new(tag_params)
    if @tag.save
      redirect_to @tag, notice: t('flash.tags.created')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @tag.update(tag_params)
      redirect_to @tag, notice: t('flash.tags.updated')
    else
      render :edit
    end
  end

  def destroy
    @tag.destroy
    redirect_to tags_path, notice: t('flash.tags.destroyed')
  end

  private

  def set_tag
    @tag = current_user.tags.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:title)
  end
end