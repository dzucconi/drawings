class Admin
  include ActiveModel::Model

  attr_accessor :username, :password

  def login_valid?
    username == ENV['ADMIN_USERNAME'] && password == ENV['ADMIN_PASSWORD']
  end
end
