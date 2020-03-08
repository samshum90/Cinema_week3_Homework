require_relative('../db/sql_runner')

class Screening

attr_reader :id
attr_accessor :film_id, :start_time, :max_seats, :price
  def initialize(options)
    @id = options['id'].to_i if options['id']
    @film_id = options['film_id'].to_i
    @start_time = options['start_time']
    @max_seats = options['max_seats']
    @price = options['price']
  end

  def save()
    sql = 'INSERT INTO screenings (
          film_id,
          start_time,
          max_seats,
        price)
          VALUES(
            $1, $2, $3, $4)
          RETURNING id'
    values = [@film_id, @start_time, @max_seats, @price]
    screening =SqlRunner.run(sql, values).first
    @id = screening['id'].to_i
  end

  def update()
    sql = 'UPDATE screenings
          SET (
          film_id,
          start_time,
          max_seats,
          price
          ) =
          ( $1, $2, $3, $4 )
          WHERE id = $5'
    values = [@film_id, @start_time, @max_seats, @price, @id]
    SqlRunner.run(sql, values)
  end

  def ticket_sold
    @max_seats -= 1 if tickets_available?
  end

  def tickets_available?
    return @max_seats > 0
  end

  def self.delete_all()
    sql = 'DELETE FROM screenings'
    SqlRunner.run(sql)
  end

  def self.all()
    sql = 'SELECT * FROM screenings'
    screening = SqlRunner.run(sql)
    results = screening.map {|screening| Screening.new(screening)}
    return results
  end
end
