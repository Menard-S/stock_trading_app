class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :stock
      t.integer :quantity
      t.string :transaction_type
      t.decimal :price
      t.datetime :timestamp

      t.timestamps
    end
  end
end
