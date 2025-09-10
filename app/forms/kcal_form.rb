class KcalForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :kcal, :integer

  validates :kcal,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 5000
            }
end
