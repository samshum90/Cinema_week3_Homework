require_relative('../db/sql_runner')
require_relative('./film')
require_relative('./ticket')
class Customer

attr_reader :id
attr_accessor :name, :funds

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name  = options['name']
    @funds = options['funds']
  end

  def save()
    sql = 'INSERT INTO customers (
              name,
              funds
              )
              VALUES(
              $1, $2
              )
              RETURNING id'
      values = [@name, @funds]
      customer = SqlRunner.run(sql, values).first
      @id = customer['id'].to_i
  end

def update()
  sql = 'UPDATE customers
        SET
        (
        name,
        funds
        ) =
        (
        $1, $2
        )
        WHERE id = $3'
  values = [@name, @funds, @id]
  SqlRunner.run(sql, values)
end

def get_film()
  sql = 'SELECT DISTINCT films.* FROM films
  INNER JOIN tickets
  ON screening_id = tickets.screening_id
  INNER JOIN screenings
  ON film_id = screenings.film_id
  WHERE customer_id = $1'
  values = [@id]
  film = SqlRunner.run(sql, values)
  result = film.map {|film| Film.new(film)}
  return result
end

# def buy_ticket()
#   # sql = "SELECT SUM(films.price) FROM films
#   # INNER JOIN tickets
#   # ON screening_id = tickets.screening_id
#   # INNER JOIN screenings
#   # ON film_id = screenings.film_id
#   #        WHERE customer_id = $1"
#   # values = [@id]
#   # price = SqlRunner.run(sql, values).first['sum'].to_i
#   # payment = @funds.to_i - price
#   # return payment
#
#   # sql = 'SELECT DISTINCT films.* FROM films
#   # INNER JOIN tickets
#   # ON screening_id = tickets.screening_id
#   # INNER JOIN screenings
#   # ON film_id = screenings.film_id
#   # WHERE customer_id = $1'
#   # values = [@id]
#   # film = SqlRunner.run(sql, values)
#   # sum = film.map {|film| Film.new(film)}
#   # result = sum.reduce(0) {|total, price| total + price}
#   # # return result
#   # @funds = @funds - total
#   # update()
# end

def buy_ticket(screening)
   return nil if !(can_afford?(screening.price) && screening.tickets_available?)
   spend_money(screening.price)
   update
   new_ticket = Ticket.new({'screening_id' => screening.id, 'customer_id' => @id})
   new_ticket.save
   screening.ticket_sold
   screening.update
 end

 def can_afford?(price)
   return @funds >= price
 end

 def spend_money(amount)
   @funds -= amount if can_afford?(amount)
 end

  def tickets_bought()
    sql = "SELECT * FROM tickets
    WHERE customer_id = $1"
    values = [@id]
    tickets = SqlRunner.run(sql, values)
    results = tickets.map{|ticket|Ticket.new(ticket)}
    return results.length
  end



  def self.delete_all()
    sql = 'DELETE FROM customers'
    SqlRunner.run(sql)
  end

  def self.all()
    sql = 'SELECT * FROM customers'
    customer = SqlRunner.run(sql)
    result = customer.map{|customer| Customer.new(customer)}
    return result
  end


end
