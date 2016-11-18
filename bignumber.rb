#!/usr/bin/ruby

class BigNumberOperate
  attr_accessor :bignum1, :bignum2, :sign1, :sign2, :bigArray1, :bigArray2, :sign

  def initialize(bignum1, bignum2)
    @bignum1 = bignum1
    @bignum2 = bignum2   

    if bignum1.instance_of? Array
      self.initialize_array(@bignum1, @bignum2)
    else
      self.initialize_string(@bignum1, @bignum2)    
    end

    removeUnusedZero(@bigArray1)
    removeUnusedZero(@bigArray2)
  end

  def initialize_array(bigArray1, bigArray2)   
    @bigArray1 = Array.new
    @bigArray2 = Array.new 
    @bigArray1 = bigArray1
    @bigArray2 = bigArray2
  
    # -1.1. Remove +, - sign from big num, store into @sign1, @sign2
    # -1.2. If bignum dont have sign , add sign '+'
    if ['+', '-'].include? @bigArray1[0]      
      @sign1 = @bigArray1[0] == '+' ? 1 : -1
      @bigArray1.shift
    else
      @sign1 = 1
    end

    if ['+', '-'].include? @bigArray2[0]
      @sign2 = @bigArray2[0] == '+' ? 1 : -1
      @bigArray2.shift
    else
      @sign2 = 1
    end          

  end

  def initialize_string(bignum1, bignum2) 
    @bigArray1 = Array.new
    @bigArray2 = Array.new

    @sign = 1

    # -1.1. Remove +, - sign from big num, store into @sign1, @sign2
    # -1.2. If bignum dont have sign , add sign '+'
    if ['+', '-'].include? @bignum1.chars.first
      @sign1 = @bignum1.chars.first == '+' ? 1 : -1
      @bignum1[0] = ''
    else
      @sign1 = 1
    end

    if ['+', '-'].include? @bignum2.chars.first
      @sign2 = @bignum2.chars.first == '+' ? 1 : -1
      @bignum2[0] = ''
    else
      @sign2 = 1
    end      

    # 0. Push string characters into arrays
    @bignum1.split("").each do |i|
      @bigArray1.push(i.to_s)
    end
    
    @bignum2.split("").each do |i|
      @bigArray2.push(i.to_s)
    end
  end
  
  def removeUnusedZero(bigArray)
    # -2. Remove 0 at first
    # TODO: optimize
    while (bigArray[0] == '0' && bigArray.length > 0) do
        bigArray.shift
      end
  end
  
  def compare
    @bigArray1.each_with_index {|val, index| 
      if val == @bigArray2[index]
        next
      end

      if val > @bigArray2[index]
        return 1
      else
      	return -1
      end
    }
    return 0
  end

  def makeEqualLength(bigArray1, bigArray2)
  	diff = (bigArray1.length - bigArray2.length).abs
    
    if diff > 0
      if bigArray1.length > bigArray2.length
      	diff.downto(1) do |i|
        # puts i
          bigArray2.unshift('0')
        end
      else
      	diff.downto(1) do |i|
        # puts i
          bigArray1.unshift('0')
        end
      end
    end    
  end

  def plus    
    # 1. Make two arrays length equal    
    self.makeEqualLength(@bigArray1, @bigArray2)

    # puts "Converted array"
    # puts bigArray1.inspect
    # puts bigArray2.inspect
    # puts "---------------------------------------------------"

    # 2. Plus bignum1[i] with bignum2[i]

    # 2.1 The number has bigger absolute value always have positive sign
    if self.compare > 0       
      @sign = @sign1        
      @sign2 = @sign2 * @sign
      @sign1 = 1
    else
      @sign = @sign2
      @sign1 = @sign1 * @sign
      @sign2 = 1
    end

    puts "------------------------"
    puts @sign1
    puts @sign2
    puts @sign
    puts "------------------------"

    remainder = 0
    @bigResult = Array.new  
    while @bigArray1.length > 0 do
      tmp = @bigArray1.pop.to_i * @sign1 + @bigArray2.pop.to_i * @sign2 + remainder
      # puts "tmp = "
      # puts tmp
      if tmp < 0      	
      	remainder = -1
        @bigResult.unshift((tmp + 10).to_s)
      else
      	remainder = tmp/10
        @bigResult.unshift((tmp - remainder * 10).to_s)
      end
    end

    if remainder > 0
      @bigResult.unshift(remainder.to_s)
    end
    
    # 3. return result
        # puts "---------------------------------------------------"
        # puts "plus result"
        # puts bigResult
        # puts "sign"
        # puts @sign
        # puts "---------------------------------------------------"
    if @sign == 1
      @bigResult = ['+'] + @bigResult
    else
      @bigResult = ['-'] + @bigResult
    end
    return @bigResult
  end
   
  def multiple_single_bit(bigArray1, bigArray2)
    arr = Array.new
    result = bigArray1[0].to_i * bigArray2[0].to_i

    if result >= 0
      arr = ['+']
    else
      arr = ['-']
    end

    result.to_s.split("").each do |i|
      arr.push(i.to_s)
    end

    return arr
  end
  
  def multiple    
    result = self.multiple_recursive(@bigArray1, @bigArray2)    
    result.shift
    if @sign1 == @sign2
      result.unshift('+')
    else
      result.unshift('-')
    end
    puts "final-result"
    puts result.inspect
    puts "final-result"
  end

  def multiple_recursive (bigArray1, bigArray2)
    if ['+', '-'].include? bigArray1[0]      
      # sign1 = bigArray1[0] == '+' ? 1 : -1
      bigArray1.shift
    # else
    #   sign1 = 1
    end

    if ['+', '-'].include? bigArray2[0]
      # sign2 = bigArray2[0] == '+' ? 1 : -1
      bigArray2.shift
    # else
    #   sign2 = 1
    end

    removeUnusedZero(bigArray1)
    removeUnusedZero(bigArray2)

    # multiple with 0 -> return 0
    if bigArray1 == ['0'] || bigArray2 == ['0']
      return ['0']
    end

    # sign = sign1 == sign2 ? 1 : -1    
    
  	# Use Karatsuba algorithm to calculate
    # 1. Make two arrays length equal
    self.makeEqualLength(bigArray1, bigArray2)

    puts bigArray1.inspect
    puts bigArray2.inspect

    # 2. Base case
    n = bigArray1.length

    case n
    when 0
      # puts "bigArray1.length == 0"
      puts "------------------ ended a loop --------------------------"      
      puts "result ['0']"
      puts "-------------"
      return ['0']
    when 1
      puts "------------------ ended a loop --------------------------"
      puts bigArray1.inspect
      puts bigArray2.inspect
      puts "result"
      puts self.multiple_single_bit(bigArray1, bigArray2).inspect
      puts "-------------"
      return self.multiple_single_bit(bigArray1, bigArray2)
    else

    # 3. Split to two array with lengh Ceil(n/2) and Floor(n/2)
    first = n/2
    second = n - n/2

    xl = Array.new
    xr = Array.new
    yl = Array.new
    yl = Array.new

    xl = bigArray1[0, first]
    xr = bigArray1[first, n - first]
    yl = bigArray2[0, first]
    yr = bigArray2[first, n - first]
    

    p1 = Array.new
    p2 = Array.new
    p3 = Array.new
    p11 = Array.new    
    p21 = Array.new
    
    p1 = multiple_recursive(xl, yl)    
    p2 = multiple_recursive(xr, yr)

    puts "xl, xr, yl, yr"
    puts xl.inspect, xr.inspect, yl.inspect, yr.inspect
    puts "-------------"
    puts "self.plus(xl, xr)"
    plus1 = Array.new
    plus2 = Array.new
    plus1 = BigNumberOperate.new(xl, xr).plus
    puts "self.plus(yl, yr)"
    plus2 = BigNumberOperate.new(yl, yr).plus
      puts "plus1, plus2"
    puts plus1.inspect
    puts plus2.inspect
    
    p3 = multiple_recursive(plus1, plus2)

    puts "calculated p3"
  
    puts "p1"
    puts p1.inspect
    puts "p2"
    puts p2.inspect
    puts "p3"
    puts p3.inspect
    puts multiple_recursive(plus1, plus2).inspect
    puts "---"

    if p1[0] == '+'      
      p11 = ['-'] + p1 - ['+']      
    else
      p11 = ['+'] + p1 - ['-']      
    end

    if p2[0] == '+'      
      p21 = ['-'] + p2 - ['+']      
    else
      p21 = ['+'] + p2 - ['-']      
    end
    
    puts "-p21, p11-"
    puts p21.inspect
    puts p11.inspect
    puts "---"

    p3 = BigNumberOperate.new(p3, p11).plus

    puts "p31"
    puts p3.inspect
    puts p21.inspect
    puts "---"

    p3 = BigNumberOperate.new(p3, p21).plus

    puts "p32"
    puts p3.inspect
    puts "---"

    # P5 = 
    # puts p4
    (second * 2).downto(1) do
      p1.push('0')
    end

    puts "p11"
    puts p1.inspect
    puts "---"
    
    second.downto(1) do
      p3.push('0')
    end

    puts "p33"
    puts p3.inspect
    puts "---"

    p1 = BigNumberOperate.new(p1, p3).plus
    puts "p12"
    puts p1.inspect
    puts "---"

    puts "------------------ ended a loop --------------------------"
    puts bigArray1.inspect
    puts bigArray2.inspect
    
    result = Array.new
    result = BigNumberOperate.new(p1, p2).plus      

    puts result.inspect
    puts "------------------------------------------------------------------------"
    return result
    end
  end
end