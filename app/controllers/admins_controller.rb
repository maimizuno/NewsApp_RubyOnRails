class AdminsController < ApplicationController

  # List all visible articles (Admin Home/index.html.erb)
  def index
    # Find the admin based on the session user_id
    @admin = Admin.find(session[:admin_id]) if session[:admin_id]
    # Retrieve all visible articles (and nil) and sort them by created date
    @articles = Article.where(is_hidden: [false, nil]).order(created_at: :desc)
    # Set @show_hidden to false so that the page only shows visible articles
    @show_hidden = false
  end

  # Display the registration form
  def register_form
    # Initialise a new Admin object
    @admin = Admin.new
    # Render the register view (register.html.erb)
    render :register
  end

  # Create a new admin (register)
  def register
    # Create a new Admin object with the params (Strong parameters)
    @admin = Admin.new(admin_params)
    # Try to save the new admin to the database and check if it was successful
    if @admin.save
      # If successful, save the admin's ID in the session and let the user login
      session[:admin_id] = @admin.id
      # Redirect to the admin home page (index.html.erb)
      redirect_to index_admins_path
    else
      # If unsuccessful, re-render the registration form
      render :register
      # Store an error message to be displayed on the page
      flash.now[:alert] = "Registration failed. #{@admin.errors.full_messages.to_sentence}"
    end
  end

  # Display the login form
  def login_form
    # Render the "login" view (login.html.erb)
    render "login"
  end

  # Authenticate and log in the admin (login.html.erb)
  def login
    # Find the admin by the username passed through the login form
    @admin = Admin.find_by(username: params[:username])
    # Check if the admin exists and the password is correct (using the authenticate method from bcrypt)
    if @admin&.authenticate(params[:password])
      # Save the admin's ID in the session and Log in
      session[:admin_id] = @admin.id
      # Redirect to the admin home page (index.html.erb)
      redirect_to index_admins_path
    else
      # If the login fails, display an error message
      flash.now[:alert] = "Invalid username or password"
      # Render the login page (login.html.erb)
      render :login
    end
  end

  # Log out the admin
  def logout
    # Clear the admin ID from the session and log out
    session[:admin_id] = nil
    # Redirect the user to the home page
    redirect_to root_path
  end

  # Reusable component ---------------------------------------------------------------------
  private # Restrict access to the following method for security

  # Allow users to submit only the specified parameters through the form
  def admin_params
    params.require(:admin).permit(:username, :password, :password_confirmation)
  end

end
