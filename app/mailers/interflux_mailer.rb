class InterfluxMailer < ApplicationMailer
  def otp(otp)
    @otp = otp

    mail(
      from: 'bot@interflux.com',
      reply_to: 'jw@interflux.au',
      to: @otp.user.email,
      subject: "Your code is #{@otp.code}",
      message_stream: 'outbound'
    )
  end
end
