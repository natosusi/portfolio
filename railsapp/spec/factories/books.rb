FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    author { Faker::Book.author }
    description { Faker::Lorem.sentences }
    image_link { "http://books.google.com/books/content?id=dXKtzgEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api" }
  end
end
