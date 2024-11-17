class CategoriesController < ApplicationController

  # List all categories (Categories page/list.html.erb)
  def list
    # Check if an admin is logged in
    if session[:admin_id]
      # Retrieve all categories in alphabetical order except "Unknown (id: 13)"
      @categories = Category.where.not(id: 13).order(name: :asc)
    else
      # Retrieve all categories in alphabetical order
      @categories = Category.order(name: :asc)
    end
  end

  # Show all articles associated with the category selected by user
  def show
    # Find the selected category by its ID
    @category = Category.find(params[:id])
    # Retrieve all articles within the category
    @articles = @category.articles.order(created_at: :desc)
  end

  # Render the form for creating a new category
  def new
    # Initialise a new Category object
    @category = Category.new
  end

  # Create a new category and save it to the database
  def create
    # Initialise a new category with the parameters submitted via the form (using strong parameters)
    @category = Category.new(category_params)
    # # Attempt to save the category and check if it was successful
    if @category.save
      # Redirect the user to the categories page (list.html.erb)
      redirect_to list_categories_path
      # Store a success message to be displayed on the page
      flash[:category_notice] = "Category created successfully!"
    else
      # Re-render the new category form
      render :new
      # Store an error message to be displayed above the new category form
      flash.now[:alert] = "Category not created. #{@category.errors.full_messages.to_sentence}"
    end
  end

  # Update an existing category
  def update
    # Find the selected category by its ID
    @category = Category.find(params[:id])
    # Check if the category is successfully updated
    if @category.update(category_params)
      # Redirect the user to the categories page (list.html.erb)
      redirect_to list_categories_path
      # Store a success message to be displayed on the page
      flash[:category_notice] = "Category updated successfully!"
    else
      # Re-render the category page
      render list_categories_path
      # Store an error message to be displayed on the page
      flash.now[:alert] = "Category not updated. #{@category.errors.full_messages.to_sentence}"
    end
  end

  # Show the warning message for the category deletion
  def show_delete
    # Retrieve a category based on the ID passed in the params
    @category = Category.find(params[:id])
    # Retrieve all articles in order by created date
    @articles = @category.articles.order(created_at: :desc)
    render :show
  end

  # Delete a category from the database
  def destroy
    # Retrieve a category based on the ID passed in the params
    @category = Category.find(params[:id])
    # Update all articles within the category and assign them to the "Unknown"(id = 13)
    @category.articles.update_all(category_id: 13)
    # Delete the category
    @category.destroy
    # Redirect the user to the categories page (list.html.erb)
    redirect_to list_categories_path
    # Store a success message to be displayed on the page
    flash[:category_notice] = "Category deleted successfully!"

  end

  # Reusable component ---------------------------------------------------------------------
  private # Restrict access to the following method for security
  # Strong parameters for category
  def category_params
    params.require(:category).permit(:name)
  end

end
