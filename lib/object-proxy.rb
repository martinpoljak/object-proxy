# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

require "hash-utils/symbol"
require "hash-utils/object"

##
# Main ObjectProxy class.
#

module ObjectProxy

    ##
    # Creates proxy object.
    #
    # @param [Object] object proxied object 
    # @return [Class] anonymous proxy class with before and after 
    #   handlers functionality
    #

    def self.create(object)
        cls = Class::new(object.class)
        cls.instance_eval do
        
            # Eviscerates instances methods and replace them by
            public_instance_methods.each do |method|
                if not method.in? [:object_id, :__send__, :initialize]
                    define_method method do |*args, &block|
                        before = ("before_" << method.to_s).to_sym
                        after = ("after_" << method.to_s).to_sym
                        
                        # before handler
                        if @handlers.include? before
                            args, block = @handlers[before].call(args, block)
                        end
                        
                        # call
                        result = @wrapped.send(method, *args, &block)
                        
                        # after handler
                        if @handlers.include? after
                            result = @handlers[after].call(result)
                        end
                        
                        return result
                    end
                end
            end
            
            # Adds constructor
            define_method :initialize do |wrapped|
                @wrapped = wrapped
                @handlers = { }
            end
            
            # Event handlers assigning interceptor
            define_method :method_missing do |name, *args, &block|
                if name.start_with? "before_", "after_"
                    self.register_handler(name, block)
                end
            end
            
            # Assigns event handler
            define_method :register_handler do |name, &block|
                @handlers[name] = block
            end
            
            attr_accessor :wrapped
        end
        
        return cls::new(object)
    end
end

##
# Shortcut module to [ObjectProxy].
#
    
module OP

    ##
    # Alias for +ObjectProxy#create+.
    # @see ObjectProxy
    #
    
    def self.[](object)
        ObjectProxy::create(object)
    end
    
end
