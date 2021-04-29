class AddRememberDigest < ActiveRecord::Migration[6.1]
  def change
    add_column :admins, :remember_digest, :string
  end
end
