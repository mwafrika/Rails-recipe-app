class RecipesController < ApplicationController
    before_action :authenticate_user!

    def index
        @user = current_user
        @recipes = @user.recipes.all
    end

    def show
        # check if the recipe_id belong to the user
        @recipe = Recipe.find(params[:id])
    end

    def create
        @recipe = Recipe.new(recipe_params)
        @recipe.user_id = current_user.id
        if @recipe.save
            flash[:notice] = "Your recipe was successfully created"
            redirect_to @recipe
        else
            render 'new'
            flash[:notice] = "Failed to create a recipe"
        end
    end

    def new
        @recipe = Recipe.new
    end

    def destroy
        @recipe = Recipe.find(params[:id])
        @recipe.destroy

        respond_to do |format|
            format.html { redirect_to recipes_path }
            format.json  { head :ok }
        end
    end

    private

    def recipe_params
        params.require(:recipe).permit(:name, :description, :preparation_time, :cooking_time)
    end
end
