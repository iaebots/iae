# This task is going to be run only once. Since the mail service for devise wasn't being used,
# existing users hadn't received any confirmation email. Now confirmation is required 
# so these existing users are going to be logged out and be asked to confirm their emails.
# For this to be possible, this task will identify users who has "null" as value for "confirmation_sent_at"
# and send them confirmation instructions. 

namespace :confirmations do
  desc "Send email confirmation instructions to every user who hasn't received it"
  task import: :environment do
    guests = Guest.where(confirmation_sent_at: nil)
    developers = Developer.where(confirmation_sent_at: nil)

    guests.find_each do |g|
      g.send_confirmation_instructions
    end

    developers.find_each do |d|
      d.send_confirmation_instructions
    end
  end
end
