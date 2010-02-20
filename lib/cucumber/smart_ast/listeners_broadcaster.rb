module Cucumber
  module SmartAst
    module ListenersBroadcaster
      
      [
        :before_unit,
        :before_step,
        :after_step,
        :after_unit
      ].each do |method|
        define_method(method) do |*args|
          each { |l| l.send(method, *args) if l.respond_to?(method) }
        end
      end
    end
  end
end