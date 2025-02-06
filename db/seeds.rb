# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Product.delete_all

3.times do
  Product.create!(
    title: 'Donuts!',
    description: %(
      <p>
        <em>Fresh, Delicious Artisanal Donuts</em>

        Indulge in our handcrafted donuts, made fresh daily with premium ingredients.
        Each donut is carefully prepared using traditional techniques passed down through
        generations, ensuring the perfect balance of flavors and textures.

        Our signature recipes combine classic favorites with innovative twists,
        creating unique treats that satisfy both traditional tastes and adventurous
        palates. Whether you're starting your day, seeking an afternoon treat, or
        planning a special event, our donuts are sure to delight.
      </p>
    ),
    image_url: 'donut.jpg',
    price: 10.99
  )
end
