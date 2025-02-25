class AddSubdomainToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :subdomain, :string
  end
end
