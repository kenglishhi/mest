class Admin::UsersController < ApplicationController
  active_scaffold :users do |config|
    non_editable = [:current_login_at, :current_login_ip, :last_login_at,
      :last_login_ip, :last_request_at, :token_expires_at,:fasta_files,:job_logs,:jobs]

    config.list.columns = [:avatar,:full_name,
      :email,:current_login_at, :current_login_ip,
      :last_login_ip, :last_login_at, :updated_at,
      :created_at]
    config.update.columns = [:email, :first_name,:last_name, :mi, :title, :organization]


    config.columns.add :password
    config.columns[:password].description = 'minimum 4 characters'
    config.columns[:email].description = 'minimum 6 characters'

    config.columns.exclude :crypted_password, :password_salt, :persistence_token, :perishable_token, :password, :single_access_token

    config.create.columns = [:email, :first_name, :mi, :last_name, :password, :password_confirmation]
    config.update.columns.add :password, :password_confirmation
    config.update.columns.exclude non_editable
  end

end
