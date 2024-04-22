User.find_or_initialize_by(id: 1).update!(
  name: 'Admin',
  login: 'admin',
  email: 'admin@admin.com',
  password: '123456',
  password_confirmation: '123456'
)
