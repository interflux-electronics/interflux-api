# == Schema Information
#
# Table name: refresh_tokens
#
#  id         :uuid             not null, primary key
#  expires_at :datetime         not null
#  token      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_refresh_tokens_on_token    (token) UNIQUE
#  index_refresh_tokens_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class RefreshToken < ApplicationRecord
  belongs_to :user
  validates :token, :expires_at, presence: true

  def valid_token?
    !expired?
  end

  def expired?
    expires_at < Time.current
  end

  # Dev only

  def label
    return "[RefreshToken] ID=#{id} JWT=#{token}" unless Rails.env.production?

    '[RefreshToken] ID=XXX JWT=XXX' if Rails.env.production?
  end
end
