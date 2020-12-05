
def evaluate(ex, envi)
  
  case ex
    when IntConstant    
      return IntValue.new(ex.c)
    when BooleanConstant    
      return BooleanValue.new(ex.c)
    when BinaryOperationExpression
      leftValue = IntValue.new(evaluate(ex.left,envi)).v
      rightValue = IntValue.new(evaluate(ex.right,envi)).v
      
      case ex.op
        when BinaryOperationExpression::Operator::PLUS
          return IntValue.new(leftValue.v + rightValue.v)
        when BinaryOperationExpression::Operator::MINUS
          return IntValue.new(leftValue.v - rightValue.v)
        when BinaryOperationExpression::Operator::TIMES
          return IntValue.new(leftValue.v * rightValue.v)
        when BinaryOperationExpression::Operator::DIV
          return IntValue.new(leftValue.v / rightValue.v)
        else
          raise "Unkown Binary Operation"
      end
    when ComparisonExpression
      left = evaluate(ex.left,envi).v
      right = evaluate(ex.right,envi).v

      case ex.type
        when ComparisonExpression::TYPE::EQ
          result = IntValue.new(left).v == IntValue.new(right).v
          return BooleanValue.new(result)
        else  
          raise "Unknown comparison type"  
      end  
    
    
    
    when IfExpression
      cond = evaluate(ex.condition,envi)
      if(cond.b)
        return evaluate(ex.thenSide,envi)
      else
        return evaluate(ex.elseSide,envi)
      end
    when LetExpression
      v = evaluate(ex.value, envi)
      envi.bind(ex.variable, v)
      return evaluate(ex.body, envi)
    when VariableExpression
      return envi.lookup(ex.variable)


    end    
end


class Expression
end
class IntConstant < Expression  
  def c 
    @c 
  end
  def initialize(c) 
    @c = c          
  end
end
class BooleanConstant < Expression  
  def c 
    @c 
  end
  def initialize(c) 
    @c = c          
  end
end

class BinaryOperationExpression < Expression
  
  module Operator
    PLUS = "+"
    MINUS = "-"
    TIMES = "*"
    DIV = "/"
  end

  def op 
    @op 
  end
  def left 
    @left 
  end
  def right 
    @right 
  end
  def initialize(op, left, right)
    @op = op
    @left = left
    @right = right
  end
end
class ComparisonExpression < Expression
  module TYPE
    EQ = "=="
  end

  def type 
    @type 
  end
  def left 
    @left 
  end
  def right 
    @right 
  end
  def initialize(type, left, right)
    @type = type
    @left = left
    @right = right
  end
end 
class IfExpression < Expression

  def condition
    @condition
  end
  def thenSide
    @thenSide
  end
  def elseSide
    @elseSide
  end 

  def initialize( condition, thenSide, elseSide)
    @condition = condition
    @thenSide = thenSide
    @elseSide = elseSide
  end

end  
class LetExpression < Expression
  
  def variable
    @variable
  end
  def value
    @value
  end
  def body
    @body
  end 

  def initialize(variable, value, body)
    @variable = variable
    @value = value
    @body = body
  end
end 
class VariableExpression < Expression
  def variable
    @variable
  end
  
  def initialize (variable)
    @variable = variable
  end
end

# values
class Value
end
class IntValue < Value
  def v
    @v
  end

  def initialize(v)
    @v = v
  end

  def to_s
    return 'IntValue{' + "v=" + "#{@v}" +'}'
  end
end
class BooleanValue < Value
  def b
    @b
  end

  def initialize(b)
    @b = b
  end

  def to_s
    return 'BooleanValue{' + "b=" + "#{@b}" +'}'
  end
end



class Bindings
  def name
    @name
  end
  def value
    @value
  end
  def initialize(name, value)
    @name = name
    @value = value
  end

  def to_s
    return '{' + "name=" + "#{@name}" + ', value=' +"#{@value}" + '}'
  end
end

class Environmnet
  BINDS = []

  def lookup (name)
    BINDS.each do |item|
      if (item.name.equals(name))
        return item.value
      end
    end
  end

  def to_s
    return 'Environmnet{' + "#{BINDS}" +'}'
  end

end
class DynamicScopedEnvironment < Environmnet
  def bind (name, value)
    BINDS.unshift(Bindings.new(name, value))
  end
end


class Name
  def theName
    @theName
  end

  def initialize (theName)
    @theName = theName
  end

  def equals (nameclass)

    if(self == nameclass)
      return true
    end
    if(nameclass == nil || self.class != nameclass.class)
      return false
    end
    return self.class == nameclass.class
    
  end

end


envi = DynamicScopedEnvironment.new
# Problems
# 474
p1 = IntConstant.new(474)
puts 'p1'
puts evaluate(p1,envi)

# (400 + 74) / 3
p2 = BinaryOperationExpression.new(
  BinaryOperationExpression::Operator::DIV,
  BinaryOperationExpression.new(
    BinaryOperationExpression::Operator::PLUS,
    IntConstant.new(400),
    IntConstant.new(74) ),
  IntConstant.new(3)
)
puts 'p2'
puts evaluate(p2,envi)

#((400 + 74) / 3) == 158
p3 = ComparisonExpression.new(
  ComparisonExpression::TYPE::EQ,
  (BinaryOperationExpression.new(
  BinaryOperationExpression::Operator::DIV,
  BinaryOperationExpression.new(
    BinaryOperationExpression::Operator::PLUS,
    IntConstant.new(400),
    IntConstant.new(74) ),
  IntConstant.new(3)
  )),
  IntConstant.new(158)
)
puts 'p3'
puts evaluate(p3,envi)

# if (((400 + 74) / 3) == 158) then 474 else 474/0
p4 = IfExpression.new(
  p3,
  IntConstant.new(474),
  BinaryOperationExpression.new(
    BinaryOperationExpression::Operator::DIV,
    IntConstant.new(474),
    IntConstant.new(0)
  )
)
puts 'p4'
puts evaluate(p4,envi)

#let bot = 3 in
#   (let bot = 2 in bot)
#   +
#   (if (bot == 0) then 474/0 else (400+74)/b


# }
#   let x = 10
# { let x = 20
#   x -> Always 20
# }
#  + x -> 10 on lexical scoping, 20 on dynamic scoping
# }
p5 = LetExpression.new(
  Name.new('x'),
  IntConstant.new(10),
  BinaryOperationExpression.new(
    BinaryOperationExpression::Operator::PLUS,
    LetExpression.new(
      Name.new('x'),
      IntConstant.new(20),
      VariableExpression.new(Name.new('x'))
    ),
    VariableExpression.new(Name.new('x'))
  )
)
puts 'p5'
puts evaluate(p5,envi)

