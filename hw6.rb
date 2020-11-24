
def evaluate(ex)
  
  case ex
    when IntConstant    
      return IntValue.new(ex.c)

    when BinaryOperationExpression

      leftValue = IntValue.new(evaluate(ex.left)).v
      rightValue = IntValue.new(evaluate(ex.right)).v

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



# Problems
# 474
p1 = IntConstant.new(474)
puts 'p1'
puts evaluate(p1)

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
puts evaluate(p2)
