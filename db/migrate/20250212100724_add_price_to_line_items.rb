class AddPriceToLineItems < ActiveRecord::Migration[7.2]
  def change
    add_column :line_items, :price, :decimal, precision: 8, scale: 2

    LineItem.all.each do |line_item|
      line_item.update_columns(price: line_item.product.price)
    end
  end
end
