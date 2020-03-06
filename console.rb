require_relative('models/Customer')
require_relative('models/film')
require_relative('models/Ticket')

require('pry-byebug')

Ticket.delete_all
Film.delete_all
Customer.delete_all
customer1 = Customer.new ({ 'name' => 'Tom Hardy', 'funds' => 100 } )
customer2 = Customer.new ({ 'name' => 'Emma Turell', 'funds' => 30 } )
customer3 = Customer.new ({ 'name' => 'Jack Smith', 'funds' => 20 } )
customer1.save
customer2.save
customer3.save

customer1.name = 'Thomas Hardy'
customer1.update

film1 = Film.new( {'title' => 'Parasite', 'price' => 5})
film2 = Film.new( {'title' => 'Joker', 'price' => 7})

film1.save
film2.save


film1.price = 6
film1.update

ticket1 = Ticket.new( {'customer_id' => customer1.id, 'film_id' => film1.id })
ticket2 = Ticket.new( {'customer_id' => customer1.id, 'film_id' => film2.id })
ticket3 = Ticket.new( {'customer_id' => customer3.id, 'film_id' => film1.id })

ticket1.save
ticket2.save
ticket3.save





binding.pry
nil
