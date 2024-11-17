class CommentsController < ApplicationController
  # Create a new comment for an article (articles/show.html.erb)
  def create
    # Find the article in the database by its article_id passed in the params
    @article = Article.find(params[:article_id])
    # Instantiate a new comment associated with the article
    @comment = @article.comments.new(comment_params)
    # Attempt to save the comment and check if it was successful
    if @comment.save
      # Redirect to the article's show page (show.html.erb)
      redirect_to show_article_path(@article)
      # Store a success message to be displayed on the page
      flash[:comment_notice] = "Comment added successfully!"
    else
      # Re-render the article show page
      render "articles/show"
      # If saving fails, store an error message to be displayed on the page
      flash[:comment_alert] = "Failed to add comment. #{@comment.errors.full_messages.to_sentence}"
    end
  end

  # Delete the selected comment (articles/show.html.erb)
  def destroy
    # Find the article by its article_id passed in the params
    @article = Article.find(params[:article_id])
    # Find the selected comment in the database by its id passed in the params
    @comment = @article.comments.find(params[:id])
    # Delete the found comment
    @comment.destroy
    # Redirect the user to the article's show page (show.html.erb)
    redirect_to show_article_path(@article)
    # Store a message to be displayed on the page
    flash[:comment_notice]= "Comment deleted successfully!"
  end
  # Reusable component ---------------------------------------------------------------------
  private # Restrict access to the following method for security
  # Strong parameters to allow only the comment body fields to be submitted via the form
  def comment_params
    params.require(:comment).permit(:body)
  end

end
