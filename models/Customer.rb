require_relative('../db/sql_runner')
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
  sql = 'SELECT films.* FROM films
  INNER JOIN tickets
  ON film_id = tickets.film_id
  WHERE customer_id = $1'
  values = [@id]
  film = SqlRunner.run(sql, values)
  result = film.map {|film| Film.new(film)}
  return result
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
