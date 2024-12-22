class CreateDeliveries < ActiveRecord::Migration[8.0]
  def up
    enable_extension 'vector'

    create_table :deliveries do |t|
      t.string :destination
      t.decimal :cost
      t.text :description

      t.string :pickup_address, null: false
      t.string :delivery_address, null: false
      t.decimal :weight, null: false
      t.decimal :distance, null: false
      t.datetime :scheduled_time, null: false
      t.string :driver_name

      t.timestamps
    end

    add_index :deliveries, :pickup_address
    add_index :deliveries, :driver_name
    
    # Add the embedding column as vector type
    execute "ALTER TABLE deliveries ADD COLUMN embedding vector(1536)"
    
    # Add the vector index
    execute "CREATE INDEX ON deliveries USING hnsw (embedding vector_l2_ops)"
  end

  def down
    remove_index :deliveries, :pickup_address
    remove_index :deliveries, :driver_name
    drop_table :deliveries
    disable_extension 'vector'
  end
end
