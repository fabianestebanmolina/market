class Order < ApplicationRecord
  include ActiveModel::Validations
  before_validation :set_total!
  belongs_to :user
  validates :total, numericality: { greater_than_or_equal_to: 0 }
  validates :total, presence: true
  has_many :placements, dependent: :destroy # por que el test no pasa al invertir las posiciones de la L5 Y L6?????
  has_many :products, through: :placements

  validates_with EnoughProductsValidator

  def set_total!
    self.total = placements.map { |placement| placement.product.price * placement.quantity }.sum
  end

  def build_placements_with_product_ids_and_quantities(product_ids_and_quantities)
    product_ids_and_quantities.each do |product_id_and_quantity|
      placement = placements.build(
        product_id: product_id_and_quantity[:product_id],
        quantity: product_id_and_quantity[:quantity]
      )
      yield placement if block_given?
    end
  end
end
