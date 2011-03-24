# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

require "hash-utils/symbol" # >= 0.13.0
require "hash-utils/object" 

##
# Main ObjectProxy class.
#

module ObjectProxy

    ##
    # Creates proxy object. "Proxy object" means, it calls handler
    # if defined before and after each method call.
    #
    # @param [Object] object proxied object 
    # @return [Class] anonymous proxy class with before and after 
    #   handlers functionality
    # @since 0.2.0
    #

    def self.proxy(object)
        cls = Class::new(object.class)
        cls.instance_eval do
        
            # Eviscerates instances methods and replace them by
            #   before and after handlers invoker
            public_instance_methods.each do |method|
                if not method.in? [:object_id, :__send__]
                    define_method method do |*args, &block|
                        before = method.prepend("before_")
                        after = method.prepend("after_")
                        
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
    
    ##
    # Alias for +ObjectProxy::proxy+.
    # @since 0.2.0
    #
    
    def self.[](object)
        self::proxy(object)
    end
        
    ##
    # Alias for +ObjectProxy::proxy+.
    # @since 0.1.0
    #
    
    def self.create(object)
        self::proxy(object)
    end
    
    ##
    # Creates fake object. "Fake object" means, all methods are replaced
    # by empty functions or defined bodies.
    #
    # Original class public instance functions are aliased to form: 
    # +native_<name of function>+.
    #
    # @param [Class] cls class for fake
    # @param [Proc] block block with definitions of custom methods 
    #   which will be run in private context of the faked class
    # @return [Class] anonymous class faked object
    # @since 0.2.0
    #
    
    def self.fake(cls, &block)
        cls = Class::new(cls)
        cls.instance_eval do
            # Eviscerates instances methods and replace them by
            #   before and after handlers invoker
            public_instance_methods.each do |method|
                if not method.in? [:object_id, :__send__]
                    alias_method method.prepend("native_"), method
                    define_method method do |*args, &block| end
                end
            end
        end
        
        if not block.nil?
            cls.instance_eval(&block)
        end
        
        return cls::new
    end
    
    ##
    # Creates "tracker object". Works by similar way as standard proxy
    # objects, but rather than invoking individual handlers for each 
    # method call invokes single handler before and single after call
    # which receives except arguments or result the method name.
    #
    # Also doesn't support customizing the arguments or result.
    #
    # @param [Object] object proxied object 
    # @return [Class] anonymous proxy class with before and after 
    #   handlers functionality
    # @since 0.2.0
    #
    
    def self.track(object)
        cls = Class::new(object.class)
        cls.instance_eval do
        
            # Eviscerates instances methods and replace them by 
            # +#on_method+ invoker
            
            public_instance_methods.each do |method|
                if not method.in? [:object_id, :__send__]
                    define_method method do |*args, &block| 
                        if not @before_call.nil?
                            @before_call.call(method, args, block)
                        end
                        
                        result = @wrapped.send(method, *args, &block)
                        
                        if not @after_call.nil?
                            @after_call.call(method, result)
                        end
                        
                        return result
                    end
                end
            end
            
            # Adds constructor
            
            define_method :initialize do |wrapped|
                @wrapped = wrapped
                @before_call = nil
                @after_call = nil
            end
            
            # Defines handler assigners
            
            define_method :before_call do |&block|
                @before_call = block
            end
            
            define_method :after_call do |&block|
                @after_call = block
            end
            
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
    # @since 0.1.0
    #
    
    def self.[](object)
        ObjectProxy::proxy(object)
    end

    ##
    # Alias for +ObjectProxy#create+.
    # @see ObjectProxy
    # @since 0.2.0
    #
    
    def self.proxy(object)
        ObjectProxy::proxy(object)
    end

    ##
    # Alias for +ObjectProxy#fake+.
    # @see ObjectProxy
    # @since 0.2.0
    #
    
    def self.fake(cls, &block)
        ObjectProxy::fake(cls, &block)
    end
    
    ##
    # Alias for +ObjectProxy#track+.
    # @see ObjectProxy
    # @since 0.2.0
    #
    
    def self.track(obj)
        ObjectProxy::track(obj)
    end
    
end
