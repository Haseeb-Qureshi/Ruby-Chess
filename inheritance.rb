class Employee
  attr_accessor :name, :title, :salary, :boss
  def initialize(name = nil, title = nil, salary = nil, boss = nil)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
  end

  def bonus(multiplier = 1)
    @salary * multiplier
  end


end

class Manager < Employee
  attr_writer :reports
  def initialize(name = nil, title = nil, salary = nil, boss = nil, reports = [])
    super(name, title, salary, boss)
    @reports = reports
  end

  def bonus(multiplier = 1)

    @reports.map(&:salary).inject(:+) * multiplier
  end

end


darren = Manager.new("Darren", "TA Manager", 78000)
shawna = Employee.new("Shawna", "TA", 12000)
david = Employee.new("David", "TA", 10000)
ned = Manager.new("Ned", "Founder", 1_000_000, nil)
darren.reports = [shawna, david]
shawna.boss = darren
david.boss = darren
darren.boss = ned
ned.reports = [darren] + darren.reports


p ned.bonus(5) # => 500_000
p darren.bonus(4) # => 88_000
p david.bonus(3) # => 30_000
