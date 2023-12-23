class CommentsController < ApplicationController
  def new
    @recipe = Recipe.find(params[:recipe_id])
    @comment = @recipe.comments.new(parent_id: params[:parent_id])
  end

  def create
    @recipe = Recipe.find(params[:recipe_id])
    @comment = @recipe.comments.new(comment_params)
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @recipe, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      end
    end
  end

  def destroy
    @recipe = Recipe.find(params[:recipe_id])
    @comment = @recipe.comments.find(params[:id])
    @comment.destroy
    redirect_to recipe_path(@recipe), status: :see_other
  end

  private

  def comment_params
    params.require(:comment).permit(:commenter, :body, :main_image, :parent_id, :user_id)
  end
end
