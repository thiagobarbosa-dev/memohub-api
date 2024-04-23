section1 = Section.find_or_initialize_by(id: 1)
section1.assign_attributes(
  title: "About",
  notebook_id: 1
  )
section1.save!

section2 = Section.find_or_initialize_by(id: 2)
section2.assign_attributes(
  title: "Contact",
  notebook_id: 1
  )
section2.save!

section3 = Section.find_or_initialize_by(id: 3)
section3.assign_attributes(
  title: "Test Section",
  notebook_id: 3
  )
section3.save!
