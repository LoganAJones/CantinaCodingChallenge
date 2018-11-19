require 'json'
require 'pry'
require 'pp'

json = File.read('/Users/logan/desktop/CantinaCodingChallenge/SystemViewController.json')
@parsedjson = JSON.parse(json)
puts "Hello there! \n \nPlease enter an Identifier, a Class, or Class Name. Your selected views will be printed."

while @userinput == nil
@userinput = gets.chomp

@counter = 0
className = false
identifier = false
rubyClass = false

if @userinput[0] == '.'
  className = true
  @userinput[0] = ''
elsif @userinput[0] == '#'
  identifier = true
  @userinput[0] = ''
else
  rubyClass = true
end

def identifierFunc(userinput, starting, parent)
  starting.each do |subview|
    if subview.class == Array && subview[0] == "identifier" && subview[1] == userinput
      pp starting
      puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
      @counter += 1
      puts "Total view results = #{@counter}"
    elsif subview.class == Hash && subview["identifier"] == userinput
      pp subview
      puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
      @counter += 1
      puts "Total view results = #{@counter}"
      if subview["subviews"] != nil
        identifierFunc(userinput, subview["subviews"], subview)
      end
    else
      if subview.class == Hash && subview["subviews"] != nil
        identifierFunc(userinput, subview["subviews"], subview)
      elsif subview.class == Hash && subview["contentView"] != nil
        identifierFunc(userinput, subview["contentView"]["subviews"], subview)
      elsif subview.class == Hash && subview["control"] != nil
        identifierFunc(userinput, subview["control"], subview)
      elsif subview.class == Array && subview[1].class == Array
        identifierFunc(userinput, subview[1], subview)
      end
    end
  end
end

def rubyClassFunc(userinput, starting, parent)
  starting.each do |subview|
    if subview.class == Array  && subview[0] == "class" && subview[1] == userinput
      pp starting
      puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
      @counter += 1
      puts "Total view results = #{@counter}"
    elsif subview.class == Hash && subview["class"] == userinput
      pp subview
      puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
      @counter += 1
      puts "Total view results = #{@counter}"
     if subview["subviews"] != nil
        rubyClassFunc(userinput, subview["subviews"], subview)
      elsif subview["contentView"] != nil
        rubyClassFunc(userinput, subview["contentView"]["subviews"], subview)
      end
    else
      if subview.class == Hash && subview["subviews"] != nil
        rubyClassFunc(userinput, subview["subviews"], subview)
      elsif subview.class == Hash && subview["contentView"] != nil
        rubyClassFunc(userinput, subview["contentView"]["subviews"], subview)
      elsif subview.class == Hash && subview["control"] != nil
        rubyClassFunc(userinput, subview["control"], subview)
      end
    end
  end
end

def classNameFunc(userinput, starting, parent)
  starting.each do |subview|
    if subview["classNames"] != nil
      if subview["classNames"].include?(userinput)
        pp subview
        puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        @counter += 1
        puts "Total view results = #{@counter}"
        if subview["subviews"] != nil
          classNameFunc(userinput, subview["subviews"], subview)
        elsif subview["contentView"] != nil
          classNameFunc(userinput, subview["contentView"]["subviews"], subview)
        end
      else
        classNameFunc(userinput, subview["subviews"], subview)
      end
    end
  end
end


if identifier == true
  identifierFunc(@userinput, @parsedjson, @parsedjson)
end

if rubyClass == true
  rubyClassFunc(@userinput, @parsedjson["subviews"], @parsedjson)
end
if className == true
  classNameFunc(@userinput, @parsedjson["subviews"], @parsedjson)
end
end
