class CreatePaymentTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :payment_types do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :payment_types, :name, unique: true

    # Add a reference column to orders
    add_reference :orders, :payment_type, foreign_key: true

    # Populate the payment types table with SQL
    reversible do |dir|
      dir.up do
        # Create the payment types with direct SQL
        execute <<-SQL
          INSERT INTO payment_types (name, created_at, updated_at)#{' '}
          VALUES#{' '}
            ('Check', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
            ('Credit card', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
            ('Purchase order', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
        SQL

        # Update existing orders with their payment type
        execute <<-SQL
          UPDATE orders
          SET payment_type_id = (
            SELECT id FROM payment_types#{' '}
            WHERE name = CASE orders.pay_type#{' '}
                          WHEN 0 THEN 'Check'
                          WHEN 1 THEN 'Credit card'
                          WHEN 2 THEN 'Purchase order'
                          END
          )
        SQL
      end
    end

    # Remove the old pay_type column
    remove_column :orders, :pay_type
  end
end
