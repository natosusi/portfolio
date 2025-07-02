User.create!(
  name: "管理者",
  email: ENV['ADMIN_EMAIL'],
  password: ENV['ADMIN_PASSWORD'],
  confirmed_at: Time.now,
  admin: true
)
5.times do |n|
  User.create!(
    name: "テストユーザー#{n + 1}",
    email: "testuser#{n + 1}@example.com",
    password: ENV['USER_PASSWORD'],
    confirmed_at: Time.now
  )
end