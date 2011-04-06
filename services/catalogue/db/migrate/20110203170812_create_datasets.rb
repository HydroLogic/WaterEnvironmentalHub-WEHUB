class CreateDatasets < ActiveRecord::Migration
  def self.up
    create_table :datasets do |t|
      t.string :name
      t.string :uuid
      t.text :description
      t.text :methodology
      t.references :feature_type
      t.references :feature_source

      t.timestamps
    end
    
    add_index :datasets, [:uuid], :unique => true
  end

  def self.down
    drop_table :datasets
  end
end
