# == Schema Information
#
# Table name: product_families
#
#  gist              :string
#  name_plural       :string
#  name_single       :string
#  rank              :integer
#  slug              :string           not null, primary key
#  the_full_monty    :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  product_family_id :string
#
class ProductFamily < ApplicationRecord
  belongs_to :product_family, optional: true
  alias_attribute :parent, :product_family

  has_many :products, foreign_key: :main_family_id, inverse_of: :main_family
  has_many :product_uses, through: :products
  has_many :uses, through: :product_uses

  # TODO: deprecate product family images
  has_many :product_family_images
  has_many :images, through: :product_family_images, source: :image

  def main_family?
    parent.nil?
  end

  def sub_family?
    parent.present?
  end
end
