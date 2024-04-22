user1 = User.find_or_initialize_by(id: 1)
user1.assign_attributes(
  name: 'Admin',
  login: 'admin',
  email: 'admin@admin.com',
  password: '123456',
  password_confirmation: '123456'
  )
user1.save!

user2 = User.find_or_initialize_by(id: 2)
user2.assign_attributes(
  name: 'User Test 1',
  login: 'user',
  email: 'user@user1.com',
  password: '123456',
  password_confirmation: '123456'
)
user2.save!
