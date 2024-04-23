class CreatePages < ActiveRecord::Migration[7.0]
  def change
    create_table :pages do |t|
      t.string :title
      t.text :content
      t.references :section, null: false, foreign_key: true

      t.timestamps
    end
  end
end
