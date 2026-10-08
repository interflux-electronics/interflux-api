# == Schema Information
#
# Table name: product_uses
#
#  id                      :uuid             not null, primary key
#  rank_among_products     :integer
#  rank_among_uses         :integer
#  show_alternative_avatar :boolean          default(FALSE)
#  show_on_product_list    :boolean
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  image_id                :string
#  product_id              :string
#  use_id                  :string
#
class ProductUse < ApplicationRecord
  belongs_to :product
  belongs_to :use

  # If :show_alternative_avatar is true then the frontend will prefer ProductUse.image over Product.image.
  belongs_to :image, optional: true
  alias_method :alternative_avatar, :image
  alias_method :alternative_avatar=, :image=
end
