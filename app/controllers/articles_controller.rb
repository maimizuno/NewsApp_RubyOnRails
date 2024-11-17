class ArticlesController < ApplicationController
  # Public ---------------------------------------------------------------------

  # List 4 of the latest news articles (Home page/list.html.erb)
  def index
    # Retrieve 4 of the recent, visible articles from the database sorted by the created date
    @articles = Article.where(is_hidden: false).order(created_at: :desc).limit(4)
  end

  # List all news (News page/list.html.erb)
  def list
    # Retrieve all categories in alphabetical order for the headings
    @categories = Category.order(name: :asc)
  end

  # Search function for search bar (Nav/header component)
  def search
    # Check if any keywords have been entered in the search bar
    if params[:search]
      # Filter articles by content
      @articles = Article.where(is_hidden: false).search(params[:search]).order(created_at: :desc)
    else
      # If no search keywords are provided, set @articles to empty
      @articles = []
    end
    render :index
  end

  # Show an individual article page (show.html.erb)
  def show
    # Retrieve an article selected by the user based on the ID passed in the params
    @article = Article.find(params[:id])
  end

  # Admin Tasks ------------------------------------------------------------
  # Show new article form (new.html.erb)
  def new
    # Initialise a new Article object with default values (Visibility: public, Published date: today)
    @article = Article.new(is_hidden: false, created_at: Time.current)
    # Retrieve all categories for the dropdown
    @categories = Category.order(name: :asc)
    render :form
  end

  # Create a new article and save it to the database
  def create
    # Initialise a new article with the parameters submitted via the form (using strong parameters)
    @article = Article.new(article_params)
    # Try to save the article and check if it was successful
    if @article.save
      # Redirect the user to the admin home (index.html.erb)
      redirect_to index_admins_path
      # Store a success message to be displayed on the admin home page
      flash[:article_notice] = "Article saved successfully!"
    else
      # If saving fails, retrieve the categories again for the dropdown in the form
      @categories = Category.all
      # Re-render the new article form
      render :new
      # Store an error message to be displayed above the new article form
      flash.now[:alert] = "Article not saved. #{@article.errors.full_messages.to_sentence}"
    end
  end

  # Edit an existing article
  def edit
    # Find the article to edit by its ID
    @article = Article.find(params[:id])
    # Retrieve all categories to display in the dropdown for category selection
    @categories = Category.all
    render :form
  end

  # Update an existing article
  def update
    # Find the article to update by its ID
    @article = Article.find(params[:id])
    # Check if the article is successfully updated
    if @article.update(article_params)
      # Redirect the user to the individual article page (show.html.erb)
      redirect_to show_article_path(@article)
      # Store a success message to be displayed on the article page
      flash[:update_notice] = "Article updated successfully!"
    else
      # If updating fails, retrieve the categories again for the dropdown in the form
      @categories = Category.all
      # Re-render the edit form
      render :edit
      # Store an error message to be displayed above the edit form
      flash[:update_alert] = "Article not updated. #{@article.errors.full_messages.to_sentence}"
    end
  end

  # Hide or unhide the selected article
  def hide_unhide
    # Find the article by its ID
    @article = Article.find(params[:id])
    # Check the current visibility setting of the article
    if @article.is_hidden
      # If the article is currently hidden, set is_hidden to false (change the visibility to Public)
      @article.update(is_hidden: false)
      # Redirect the user to the hidden articles page (index.html.erb)
      redirect_to hidden_articles_path
      # Store a success message to be displayed on the page
      flash[:article_notice]= "Article visibility updated successfully!"
    else
      # If the article is currently visible, set is_hidden to true (change the visibility to Admin Only)
      @article.update(is_hidden: true)
      # Redirect the user to the visible articles page (index.html.erb)
      redirect_to index_admins_path
      # Store a success message to be displayed on the page
      flash[:article_notice]= "Article visibility updated successfully!"
    end
  end

  # Show all hidden articles
  def show_hidden
    # Find the admin based on the session user_id
    @admin = Admin.find(session[:admin_id]) if session[:admin_id]
    # Fetch all hidden articles
    @articles = Article.where(is_hidden: true).order(created_at: :desc)
    # Set show_hidden to true so the admin index can display the hidden articles
    @show_hidden = true
    # Render the admin index view
    render index_admins_path
  end

  # Show the warning message for the article deletion with the article details
  def show_delete
    # Retrieve an article based on the ID passed in the params
    @article = Article.find(params[:id])
    # Set a show_delete flag to true so that the articles/show page can display the warning message
    @show_delete = true
    # Render the articles/show page (show.html.erb)
    render :show
  end

  # Delete an article from the database
  def destroy
    # Find the article by its ID
    @article = Article.find(params[:id])
    # Delete the found article from the database
    @article.destroy
    # Redirect the user to the admin home page (index.html.erb)
    redirect_to index_admins_path
    # Store a success message to be displayed on the page
    flash[:article_notice]= "Article deleted successfully!"
  end

  # Reusable component ---------------------------------------------------------------------
  private # Restrict access to the following method for security
  # Strong parameters for security
  def article_params
    # Allow users to submit only the specified parameters through the form
    params.require(:article).permit(:title, :content, :category_id, :source, :created_at, :is_hidden)
  end

end