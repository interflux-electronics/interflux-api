# == Schema Information
#
# Table name: companies
#
#  id                     :uuid             not null, primary key
#  address                :string
#  business_name          :string
#  core_activity          :string
#  description            :text
#  email_accounting       :string
#  email_general          :string
#  email_orders           :string
#  email_support          :string
#  emails                 :string
#  fax                    :string
#  head_count             :integer          default(1)
#  history                :string
#  is_headquarter         :boolean          default(FALSE)
#  latitude               :decimal(, )
#  legal_name             :string
#  longitude              :decimal(, )
#  notes                  :text
#  order                  :integer
#  phone                  :string
#  public                 :boolean
#  rank_on_group_website  :integer          default(999)
#  show_markets           :boolean          default(TRUE)
#  shown_on_group_website :boolean          default(FALSE)
#  shown_on_icsf_website  :boolean          default(FALSE)
#  shown_on_main_website  :boolean          default(FALSE)
#  slug                   :string
#  website                :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  country_id             :string
#
# Indexes
#
#  index_companies_on_business_name  (business_name) UNIQUE
#  index_companies_on_country_id     (country_id)
#  index_companies_on_slug           (slug) UNIQUE
#
class Company < ApplicationRecord
  belongs_to :country, optional: true

  has_many :company_markets, dependent: :destroy
  has_many :markets, through: :company_markets, source: :country

  has_many :company_members, dependent: :destroy
  has_many :people, through: :company_members, source: :person

  alias_method :members, :people
  alias_method :members=, :people=

  has_many :public_members, -> { where(public: true) }, class_name: 'CompanyMember'
end
