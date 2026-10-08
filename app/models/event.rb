# == Schema Information
#
# Table name: events
#
#  id                         :uuid             not null, primary key
#  ask_company                :boolean
#  ask_first_name             :boolean
#  ask_last_name              :boolean
#  ask_role                   :boolean
#  city                       :string
#  confirmation_email_bcc     :string           default("s.teliszewski@interflux.com, jw@interflux.au")
#  confirmation_email_body    :string           default("Hello {first_name} {last_name},    We look forward seeing you at {event_name} on {event_date} in {event_location}.    Best regards,    The Interflux Electronics team")
#  confirmation_email_subject :string           default("See you soon at {event_name}!")
#  dates                      :string
#  description                :string
#  end_date                   :string
#  has_registration_form      :boolean
#  name                       :string
#  start_date                 :string
#  website                    :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  country_id                 :string
#
class Event < ApplicationRecord
  belongs_to :country

  has_many :permalinks
  has_many :event_attendees

  alias_method :attendees, :event_attendees
  alias_method :attendees=, :event_attendees=

  def location
    "#{city}, #{country.name_english}"
  end

  scope :past, -> { where('start_date < ?', Date.current - 2.days) }
  scope :upcoming, -> { where('start_date >= ?', Date.current - 2.days) }

  def start_to_end_date
    return '?' if sd.nil? && ed.nil?
    return sd.strftime('%a %-d %b %Y') if sd.present? && ed.nil?
    return sd.strftime('%a %-d %b %Y') if ed == sd
    return "#{sd.strftime('%a %d')} to #{ed.strftime('%a %-d %b %Y')}" if sd.month == ed.month

    "#{sd.strftime('%a %-d %b %Y')} to #{ed.strftime('%a %-d %b %Y')}"
  end

  def sd
    start_date&.to_date
  end

  def ed
    end_date&.to_date
  end
end
