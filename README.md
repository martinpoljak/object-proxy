Object Proxy
============

**object-proxy** provides proxy objects intended for intercepting calls 
to instance methods. It's aimed as tool for instant adapting the complex 
objects without complete deriving and extending whole classes in cases, 
where isn't possible to derive them as homogenic functional units or 
where it's simply impractical to derive them. Provides four base 
proxy types.

*In all examples, object instance proxying is used, but both class objects
and object instances proxying are supported. Simply give object instance
instead of class object to the constructor. Wrapped object instance will 
be returned.*

### Standard Proxy
Works as intermediate layer between caller and called. Allows to invoke 
an handler both before method call and adjust its  arguments and after 
call and post-proccess result. 

See some slightly stupid example:

        require "object-proxy"

        s = OP::proxy("1 2 3 4")
        s.before_split do |args|
            args = [" "]
        end
        s.after_split do |result|
            result.map { |i| i.to_i + 1 }
        end
        
        # This argument will be replaced in handler
        out = s.split(",")
        p out
        
Will print out `[2, 3, 4, 5]`.

### Fake Proxy
Simply fakes interface of an class, but with empty methods. Necessary 
methods can be individually overwritten by custom callbacks. It's 
equivalent to manual deriving class and reseting all its methods 
to nothing.

See some slightly stupid example:

        pr = OP::fake(String, [:kind_of?]) do   # we will use #kind_of? below, 
                                                #   so we need say, we don't want to reset it
                                                
            define_method :to_s do  # let's say, '#to_s' will return
                "alfa beta"         #   fixed value
            end
        end

        pr.to_s == "alfa beta"      # '#to_s' returns fixed value
        pr.inspect.nil?             # '#inspect' and all others are reset
                                    #   and return nil
                                    
        pr.kind_of? String          # but object still seems to be String :-)
        
### Tracking Proxy
It's similar to *standard proxy*, but points all callbacks to single 
callback set (single for before call callbacks and single for after call
callbacks). Also doesn't allow to modify arguments and postprocess 
results.

See some slightly stupid example:
    
        calls = [ ]
        s = OP::track("a,b,c,d")
        
        s.before_call do |name|     # sets 'before_call' handler
            # track call names to array
            calls << name 
        end
        
        s << ",1,2,3"
        s.gsub!(",", " ")
        s.split(" ")
        
        p calls
        
Will print out `[:<<, :gsub!, :split]`.

### Catching Proxy
Catches all method calls and forwards them to the `#method_call` handler which 
calls wrapped object by default, but can be overriden, so calls can be 
fully controlled.

See some slightly stupid example:

        s = OP::catch("foo")
        
        s.method_call do |name, args, block|
            if name == :to_s
                s.wrapped.send(name, *args, &block)
            else
                :nothing
            end
        end
        
        p s.replace("beta")   # will print ":nothing" out
        s.to_s                # will print "foo" out
        
But object still seems to be `String`.

        
Contributing
------------

1. Fork it.
2. Create a branch (`git checkout -b 20101220-my-change`).
3. Commit your changes (`git commit -am "Added something"`).
4. Push to the branch (`git push origin 20101220-my-change`).
5. Create an [Issue][3] with a link to your branch.
6. Enjoy a refreshing Diet Coke and wait.

Copyright
---------

Copyright &copy; 2011 [Martin Kozák][4]. See `LICENSE.txt` for
further details.

[3]: http://github.com/martinkozak/object-proxy/issues
[4]: http://www.martinkozak.net/
