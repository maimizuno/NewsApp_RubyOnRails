Rails.application.routes.draw do
  # Routes for Articles
  get "articles/index", to: "articles#index", as: "index_articles"
  get "articles/search", to: "articles#search", as: "search_articles"
  get "articles/list", to: "articles#list", as: "list_articles"
  get "articles/new", to: "articles#new", as: "new_article"
  post "articles/create", to: "articles#create", as: "create_article"
  patch "articles/update/:id", to: "articles#update", as: "update_article"
  get "articles/show/:id", to: "articles#show", as: "show_article"
  get "articles/edit/:id", to: "articles#edit", as: "edit_article"
  delete "articles/delete/:id", to: "articles#destroy", as: "delete_article"

  # Routes for comments under a specific article
  post "articles/:article_id/comments", to: "comments#create", as: "article_comments"
  delete "articles/:article_id/comments/:id", to: "comments#destroy", as: "delete_comment"

  # Routes for Categories
  get "categories/list", to: "categories#list", as: "list_categories"
  get "categories/new", to: "categories#new", as: "new_category"
  post "categories/create", to: "categories#create", as: "create_category"
  patch "categories/update/:id", to: "categories#update", as: "update_category"
  get "categories/show/:id", to: "categories#show", as: "show_category"
  get "categories/show_delete/:id", to: "categories#show_delete", as: "show_delete_category"
  delete "categories/delete/:id", to: "categories#destroy", as: "delete_category"

  # Routes for Admins
  get "admins/index", to: "admins#index", as: "index_admins"
  patch "admins/hide_unhide/:id", to: "articles#hide_unhide", as: "hide_unhide"
  get "admins/show_delete/:id", to: "articles#show_delete", as: "show_delete"
  get "admins/hidden", to: "articles#show_hidden", as: "hidden_articles"
  get "admins/index/:id", to: "admins#index", as: "index_admins_id"
  get "admins/register", to: "admins#register_form", as: "show_register"
  post "admins/register", to: "admins#register", as: "register"
  get "admins/login", to: "admins#login_form", as: "show_login"
  post "admins/login", to: "admins#login", as: "login"
  delete "logout", to: "admins#logout", as: "logout"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # Default root
  root "articles#index"

end
