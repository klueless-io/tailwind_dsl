require 'gpt3/builder'

# Send an email to the user
#
# @param [String] use_ses - use AWS SES to send the email, if you are just testing, then set this value to false
def send_email(use_ses = nil)
  use_ses ||= true

  puts 'email sent successfully via Amazon Simple Email Service' if use_ses
end

KManager.action :test do
  action do

    # Send an email to the user
    send_email

    # Send an email to the user
    send_email(true)

    # This is a test, don't send the email
    send_email(false)
  end
end

KManager.opts.sleep = 2
