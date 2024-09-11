class UpdateTickets < ActiveRecord::Migration[7.1]
  def change
    remove_column :tickets, :seat_number
    add_reference :tickets, :seat, foreign_key: true
  end
end
