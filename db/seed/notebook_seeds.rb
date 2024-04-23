notebook1 = Notebook.find_or_initialize_by(id: 1)
notebook1.assign_attributes(
  title: "Agro1",
  user_id: 1
  )
notebook1.save!

notebook2 = Notebook.find_or_initialize_by(id: 2)
notebook2.assign_attributes(
  title: "Admin's Notebook 2",
  user_id: 1
  )
notebook2.save!

notebook3 = Notebook.find_or_initialize_by(id: 3)
notebook3.assign_attributes(
  title: "User's Notebook 1",
  user_id: 2
  )
notebook3.save!
