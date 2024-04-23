page1 = Page.find_or_initialize_by(id: 1)
page1.assign_attributes(
  title: "About Us",
  content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor, nunc nec ultricies ultricies, nunc nunc ultricies ultricies, nunc nunc ultricies ultricies, nunc nunc ultricies ultricies, nunc nunc ultricies ultricies, nunc nunc ultricies ultricies, nunc nunc ultricies ultricies, nunc nunc ultricies ultricies, nunc nunc ultricies ultricies, nunc nunc ultricies ultricies, nunc nunc ultricies ultricies, nunc nec ultricies ultricies, nunc nec ultricies ultricies, nunc nec ultricies ultricies, nunc nec ultricies ultricies, nunc nec ultricies ultricies, nunc nec ultricies ultricies, nunc nec ultricies ultricies, nunc nec ultricies ultricies, nunc nec ultricies ultricies, nunc nec ultricies ultricies, nunc nec ultricies ultricies, nunc nec ultricies ultricies.",
  section_id: 1
  )
page1.save!

page2 = Page.find_or_initialize_by(id: 2)
page2.assign_attributes(
  title: "Contact Us",
  content: "Endereço: Rua Tal, 123
            Telefone: (xx) 9999-9999
            E-mail: email@dominio.com.br",
  section_id: 1
  )
page2.save!

page3 = Page.find_or_initialize_by(id: 3)
page3.assign_attributes(
  title: "Test Page",
  content: "This is a test page",
  section_id: 3
  )
page3.save!

page4 = Page.find_or_initialize_by(id: 4)
page4.assign_attributes(
  title: "Test Page 2",
  content: "This is a test page 2",
  section_id: 3
  )
page4.save!
