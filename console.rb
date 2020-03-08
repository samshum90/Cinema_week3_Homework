require_relative('models/Customer')
require_relative('models/film')
require_relative('models/Ticket')
require_relative('models/screening')

require('pry-byebug')

Ticket.delete_all
Screening.delete_all
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

film1 = Film.new( {'title' => 'Parasite'})
film2 = Film.new( {'title' => 'Joker'})

film1.save
film2.save


screening1 = Screening.new( { 'film_id' => film1.id, 'start_time' => 1300, 'max_seats' => 2 , 'price' => 7})
screening2 = Screening.new( { 'film_id' => film1.id, 'start_time' => 1600, 'max_seats' => 3, 'price' => 8} )
screening3 = Screening.new( { 'film_id' => film2.id, 'start_time' => 1700, 'max_seats' => 4, 'price' => 5} )
screening1.save
screening2.save
screening3.save

screening1.start_time = 1200
screening1.update

ticket1 = Ticket.new( {'customer_id' => customer1.id, 'screening_id' => screening1.id })
ticket2 = Ticket.new( {'customer_id' => customer1.id, 'screening_id' => screening2.id })
ticket3 = Ticket.new( {'customer_id' => customer2.id, 'screening_id' => screening3.id })

ticket1.save
ticket2.save
ticket3.save





binding.pry
nil
