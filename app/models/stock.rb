class Stock < ApplicationRecord
	has_many :portfolios
	has_many :transactions
	has_many :users, through: :portfolios
end
