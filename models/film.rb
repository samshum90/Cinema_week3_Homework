require_relative('../db/sql_runner')

class Film

attr_reader :id
attr_accessor :title


  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
  end

  def save()
    sql = 'INSERT INTO films
          ( title
          ) VALUES
          ( $1 )
          RETURNING id'
    values = [@title]
    film = SqlRunner.run(sql, values).first
    @id = film['id'].to_i
  end

  def update()
    sql = 'UPDATE films
          SET
          title =
            $1
          WHERE id =$2'
    values = [@title, @id]
    SqlRunner.run(sql, values)
  end

  def get_customer()
    sql = 'SELECT DISTINCT customers.* FROM customers
    INNER JOIN tickets
    ON customer_id = tickets.customer_id
    INNER JOIN screenings
    ON film_id = screenings.film_id
    WHERE film_id = $1'
    values = [@id]
    customer = SqlRunner.run(sql, values)
    result = customer.map{ |customer| Customer.new(customer)}
    return result
  end

  def most_popular_screening()
  sql = "SELECT *
  FROM screenings
  WHERE id =
  (SELECT screening_id
    FROM tickets
    WHERE screening_id
    IN
    (SELECT       id
      FROM     screenings
      WHERE film_id = $1)
    GROUP BY screening_id
    ORDER BY COUNT(screening_id) DESC
    LIMIT 1)
  ;"
  values = [@id]
  result = SqlRunner.run(sql, values)
  return Screening.new(result[0])
end

  def self.delete_all()
    sql = 'DELETE FROM films'
    SqlRunner.run(sql)

  end

  def self.all()
    sql = 'SELECT * FROM films'
    film = SqlRunner.run(sql)
    result = film.map{|map|Film.new(map)}
    return result
  end

end
