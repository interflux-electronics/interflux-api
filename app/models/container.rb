# == Schema Information
#
# Table name: containers
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_containers_on_name  (name) UNIQUE
#
class Container < ApplicationRecord
  has_many :product_variants

  alias_method :variants, :product_variants
  alias_method :variants=, :product_variants=
end
