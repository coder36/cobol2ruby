require 'pry'

######### Memory management

class Mem

  def initialize
    @data = ""
    @layout = {}
  end

  def create_ws ws
    ws.mem_index = @data.size
    @layout[ws.name ]= ws
    @data << (" " * ws.size)
    if ws.value != nil
      self[ws.name] = ws.value
    end

    if ws.children.size != 0
      ws.children.each do |c|
        create_ws c
      end
    end
  end

  def real_size ws
    return ws.size if ws.size != 0 
    s = 0
    ws.children.each do |c|
      s += real_size( c )
    end
    s
  end

  def [] (name)
    c = @layout[name]
    @data[c.mem_index, real_size(c)]
  end

  def []=(name,val)
    c = @layout[name]
    size = real_size(c)
    val += " " * size
    (0...size).each do |n|
      @data[c.mem_index+n] = val[n]
    end
  end

end

class WS

  attr_accessor :mem_index, :children, :PIC, :name, :value, :size

  def initialize( params = {} )
    @pic = params[:PIC] 
    @size = calc_size @pic
    @name = params[:name]
    @children = params[:children] || []
    @value = params[:value]
  end

  def calc_size pic
    return 0 if pic == nil
    pic.match(/X\((\d+)\)/)[1].to_i
  end

end


########### DSL

def WORK_STORAGE(arg, &block)

  def ws(name, params = {}, &child)
    params[:name] = name
    if child != nil
      params[:children] = [*child.call]
    end

    WS.new( params )

  end

  @mem = Mem.new
  elems = block.call
  elems = [elems] if !elems.is_a? Array
  elems.each { |ws| @mem.create_ws( ws ) }
end

def PROCEDURE(arg, &block)

  def DISPLAY arg
    if arg.is_a? Symbol
      res = @mem[arg]
    else
      res = arg
    end
    puts res
  end

  def MOVE arg, params = {}
    if arg.is_a? Symbol
      res = @mem[arg]
    else
      res = arg
    end
    @mem[params[:to]] = arg
  end

  def ACCEPT arg, params = {}
    if arg.is_a? Symbol
      @mem[arg] = gets
    end
  end

  def STRING 
  end

  block.call

end

# Example

WORK_STORAGE :SECTION do
  [ws( :CONTEXT ) {[
    ws( :NAME, :PIC => "X(10)" ),
    ws( :ADDRESS ) {[
      ws( :ADDRESS1, :PIC => "X(10)" ),
      ws( :ADDRESS2, :PIC => "X(10)" ),
      ws( :ADDRESS3, :PIC => "X(10)" ),
      ws( :POSTCODE, :PIC => "X(10)" )
    ]}
  ]}]
end

PROCEDURE :DIVISION do
  DISPLAY "What is your name? "
  ACCEPT :NAME
  DISPLAY :CONTEXT
end
