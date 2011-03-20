Object Proxy
============

**object-proxy** provides proxy objects intended for intercepting calls 
to instance methods. Works as intermediate layer between caller and 
called. Allows to invoke an handler both before method call and adjust 
its  arguments and after call and post-proccess result. Aimed as tool 
for instant adapting the complex objects without complete deriving and 
extending whole classes in cases, where isn't possible to derive them 
as homogenic functional units or where it's simply impractical to 
derive them.

See some slightly stupid example:

        require "object-proxy"


        # OP[...] is shortcut, it creates the proxy object instance
        
        s = OP["1 2 3 4"]
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
