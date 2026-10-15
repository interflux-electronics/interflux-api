require 'ap'

# == Schema Information
#
# Table name: event_attendees
#
#  id         :uuid             not null, primary key
#  company    :string
#  email      :string
#  first_name :string
#  last_name  :string
#  locale     :string
#  role       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :uuid
#  person_id  :uuid
#
class EventAttendee < ApplicationRecord
  belongs_to :event
  belongs_to :person, optional: true

  after_save :send_confirmation_emails

  private

  def send_confirmation_emails
    log.info "✅ EventAttendee #{id} saved"

    return if email.nil?

    # TODO: Prevent this email from being sent upon every save...

    template_locale = locale == 'fr' ? 'fr' : 'en'

    log.info '✅ creating confirmation email'

    EmailAttempt.create!(
      to: email,
      from: 'Interflux Electronics <robot@interflux.com>',
      reply_to: 'Interflux Electronics <ask@interflux.com>',
      # provider: :postmark,
      postmark_stream: 'outbound',
      postmark_template_alias: "interflux-event-registration-1-#{template_locale}",
      postmark_template_model: {
        first_name: first_name,
        last_name: last_name,
        event_name: event.name,
        event_dates: event.start_to_end_date,
        event_location: event.location
      },
      created_by: self
    )

    log.info '✅ creating internal email'

    EmailAttempt.create!(
      to: 'Steven Teliszewski <s.teliszewski@interflux.com>',
      cc: 'Jan Werkhoven <jw@interflux.au>',
      from: 'Interflux Electronics <robot@interflux.com>',
      reply_to: 'Interflux Electronics <ask@interflux.com>',
      # provider: :postmark,
      postmark_stream: 'outbound',
      postmark_template_alias: 'interflux-event-registration-2-en',
      postmark_template_model: {
        receiver: {
          first_name: 'Steven'
        },
        attendee: {
          first_name: first_name,
          last_name: last_name,
          role: role,
          company: company,
          email: email,
          locale: locale
        },
        event: {
          name: event.name,
          dates: event.start_to_end_date,
          location: event.location
        }
      },
      created_by: self
    )
  end
end
