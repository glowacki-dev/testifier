class NotificationMailer < ApplicationMailer
  def notification_email(post)
    @body = post.body
    mail(to: 'notify@cia.gov', subject: 'New Post published') do |format|
      format.text
    end
  end
end
