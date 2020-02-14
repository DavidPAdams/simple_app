# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(name: "Example User",
            email: "example@railstutorial.org",
            password: "foobarbaz",
            password_confirmation: "foobarbaz",
            admin: true,
            activated: true,
            activated_at: Time.zone.now)

99.times do |x|
  name = Faker::Name.name
  email = "example-#{x+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
              email: email,
              password: password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)
end

users = User.order(:created_at).take(20)
40.times do
  content = Faker::ChuckNorris.fact
  users.each { |user| user.microposts.create!(content: content) }
end

# Following relationships
users = User.all
user  = users.first
following = users[2..70]
followers = users[3..60]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
