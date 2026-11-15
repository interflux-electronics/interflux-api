# == Schema Information
#
# Table name: one_time_passwords
#
#  id         :uuid             not null, primary key
#  attempts   :integer          default(0), not null
#  code       :string(6)        not null
#  suspended  :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_one_time_passwords_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class OneTimePassword < ApplicationRecord
  belongs_to :user

  before_validation :generate_code, on: :create

  validates :code,
            presence: true,
            length: { is: 6 },
            format: { with: /\A\d{6}\z/ }

  private

  def generate_code
    self.code = format('%06d', rand(1_000_000))
  end

  def label
    "[OneTimePassword] #{user.email} → ✨✨✨ #{code} ✨✨✨"
  end
end
