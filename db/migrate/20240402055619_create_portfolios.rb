class CreatePortfolios < ActiveRecord::Migration[7.1]
  def change
    create_table :portfolios do |t|
      t.references :user, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
