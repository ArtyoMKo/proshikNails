class AddIndexToSuperusersPhone < ActiveRecord::Migration[6.1]
  def change
    add_index(:admins, :phone_number, unique: true)
  end
end
