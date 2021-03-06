class Person
  extend Siren::Node
  
  attr_reader :id, :cars, :favourite, :handle
  
  def initialize(*cars)
    @cars = cars.map { |brand| Car.new(brand) }
  end
  
  def ==(other)
    @cars.size == other.cars.size &&
        @cars.all? { |car| other.cars.include?(car) }
  end
end

