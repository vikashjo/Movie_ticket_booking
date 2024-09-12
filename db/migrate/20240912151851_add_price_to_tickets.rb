class AddPriceToTickets < ActiveRecord::Migration[7.1]
  def change
    add_column :tickets, :price, :integer
  end
end
