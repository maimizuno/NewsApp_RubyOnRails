class Admin < ApplicationRecord
  # Rails' method to add functionality for securely handling passwords.
  # It needs a password_digest column in the database which stores the hashed password.
  has_secure_password
  # Validates the username to ensure that an unique username is provided.
  # If it’s blank, the record will not save, and Rails will add an error.
  validates :username, presence: true, uniqueness: true
  # Validates the password to ensure that a password is provided.
  validates :password, presence: true
end
