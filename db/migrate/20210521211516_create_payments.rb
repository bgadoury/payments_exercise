class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.decimal :amount, precision: 8, scale: 2
      t.belongs_to :loan, index: true
      t.timestamps
    end
  end
end
