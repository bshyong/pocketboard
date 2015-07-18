# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
10.times do
  User.create(
    phone: Faker::PhoneNumber.cell_phone.gsub('.', '-'),
    country: Faker::Address.country,
    city: Faker::Address.city,
    state: Faker::Address.state,
    zipcode: Faker::Address.zip
  )
end

User.find_each do |user|
  conversation = user.conversations.create
  conversation.messages.create(
    body: Faker::Lorem.sentence(3)
  )
end
