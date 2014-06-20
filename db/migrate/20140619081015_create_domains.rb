class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :hostname
      t.string :ip_address
      t.references :account, index: true

      t.timestamps
    end
  end
end
