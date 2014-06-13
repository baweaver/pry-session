# Pry-Session

(Save and load) http://showterm.io/b8d9f8e6ec11b76f6aea0

Save a session:
```
[2] pry(main)> a = 1
=> 1
[3] pry(main)> Person = Struct.new(:name, :age)
=> Person
[4] pry(main)> brandon = Person.new 'brandon', 23
=> #<struct Person name="brandon", age=23>
[5] pry(main)> save-session person
[6] pry(main)> exit
```

Reload a session in a new Pry session:
```
[1] pry(main)> brandon
NameError: undefined local variable or method `brandon' for main:Object
from (pry):1:in `__pry__'
[2] pry(main)> load-session person
[4] pry(main)> a = 1

[5] pry(main)> Person = Struct.new(:name, :age)

[6] pry(main)> brandon = Person.new 'brandon', 23

=> #<struct Person name="brandon", age=23>
[7] pry(main)> brandon
=> #<struct Person name="brandon", age=23>
[8] pry(main)> # MAGIC!
[9] pry(main)> exit

```

List your sessions: http://showterm.io/9b843c6f8bfd8057f0d5e
```
[1] pry(main)> list-sessions
test                     6 bytes 2014-06-11 01:19:43 -0500
testing                 33 bytes 2014-06-11 01:20:45 -0500
person                 102 bytes 2014-06-11 01:25:05 -0500
[2] pry(main)> list-sessions test
test                     6 bytes 2014-06-11 01:19:43 -0500
[3] pry(main)> list-sessions -g te
test                     6 bytes 2014-06-11 01:19:43 -0500
testing                 33 bytes 2014-06-11 01:20:45 -0500
[5] pry(main)> list-sessions -g te -s name:desc
testing                 33 bytes 2014-06-11 01:20:45 -0500
test                     6 bytes 2014-06-11 01:19:43 -0500
[6] pry(main)> list-sessions -g te -s size:desc
testing                 33 bytes 2014-06-11 01:20:45 -0500
test                     6 bytes 2014-06-11 01:19:43 -0500
[7] pry(main)> list-sessions -g te -s date:desc
test                     6 bytes 2014-06-11 01:19:43 -0500
testing                 33 bytes 2014-06-11 01:20:45 -0500
```

Edit a session: http://showterm.io/a6ef896322bd8fab71a85
```
[1] pry(main)> edit-session test  
```

## To Do

* Add output silencers by default on session loads
* Add a new-session option to reset the current session history counters

## Installation

Add this line to your application's Gemfile:

    gem 'pry-session'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pry-session

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( http://github.com/baweaver/pry-session/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
