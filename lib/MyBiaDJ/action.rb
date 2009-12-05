#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ


  class Action

    class ParamListFull < IsDrunk
    end

    attr_reader :name, :params
    
    def initialize(name, arguments, &blk)
      @name = name.to_sym
      @arguments = arguments
      @params = []
      @action = blk
    end

    def call(*args)
      p @params
      @action.call(*args)
    end

    
    def <<(obj)
      @params << obj
      raise ParamListFull, "no more params for '#{@name}'"if @params.size > @arguments.size
    end
    
  end
  
  class ActionPool < Hash
    def on(name, *args, &blk)
      self[name.to_sym] = Action.new(name, args, &blk)
    end
  end
  
  module Actions

    @pool = nil
    
    def self.setup(&blk)
      pool = ActionPool.new
      pool.instance_eval(&blk)
      @pool = pool
    end
    
    def self.parse(argv = ARGV.dup)
      cur, run = nil, []
      argv.each_with_index do |arg, i|
        if t = @pool[arg.to_sym]
          cur = t
          run << cur
        else
          cur << arg
        end
      end
      MyBiaDJ::Info "Args: " + run.map{|r| [r.name, r.params]}.inspect
    end
    
  end
  
end


=begin
Local Variables:
  mode:ruby
  fill-column:70
  indent-tabs-mode:nil
  ruby-indent-level:2
End:
=end
