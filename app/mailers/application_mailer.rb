class ApplicationMailer < ActionMailer::Base
  default from: "appelu@nocontestar.com"
  
  def create_and_deliver_password_change(user, random_password)
    @user = user
    mail(to: @user.email, body: "Su nueva contraseña es: "+random_password,
         content_type: "text/html",subject: 'Nueva contraseña')
  end


end
