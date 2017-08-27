class UserMailer < ActionMailer::Base
  default :from => 'signup@nitesite.co'

  def welcome_email(user, password)
    @user = user
    @password = password
    @url  = "http://nitesite.co/users/activate/0?token=#{@user.activation_token}"
    mail(:to => user.email, :subject => 'Welcome to NiteSite')
  end

end
