= Siren

* http://github.com/jcoglan/siren

Siren is a JSON and JSONQuery interpreter for Ruby. It extends the normal functionality
of JSON-to-Ruby processing with cross-references, automatic typecasting,
and a succinct query language for filtering JSON and Ruby object graphs.


== Installation

  sudo gem install siren


== Usage

As expected, Siren can be used as a basic JSON parser, though if that's all you
want you'll be better off with more performant libraries like the +json+ gem.

  Siren.parse '[{"name": "mike"}]'
  #=> [{"name"=>"mike"}]

The features listed below go beyond standard JSON and are modelled on the feature
set listed in this SitePen article:

  http://www.sitepen.com/blog/2008/07/16/jsonquery-data-querying-beyond-jsonpath/


=== Cross-references

Siren allows JSON objects to be given IDs, and for other objects to make
references back to them from within the same document. This allows for cyclic
data structures and other objects inexpressible in standard JSON.

  data = Siren.parse <<-JSON
          [
              {
                  "id":       "obj1",
                  "name":     "mike"
              }, {
                  "name":     "bob",
                  "friend":   {"$ref": "obj1"}
              }
          ]
  JSON
  
  #=> [ {"name" => "mike", "id" => "obj1"},
        {"name" => "bob", "friend" => {"name" => "mike", "id" => "obj1"} } ]

So +bob+ has a cross-reference to +mike+, which the parser resolves for us. Note
+mike+ is not copied but is referenced by +bob+:

  data[0].__id__              #=> -607191558
  data[1]['friend'].__id__    #=> -607191558

The general syntax for a cross-reference is <tt>{"$ref": ID_STRING}</tt>; the parser
will replace this with the referenced object in the Ruby output.


=== Automatic typecasting

JSON parsers typically output hashes and arrays, these being Ruby's closest analogues
to the JavaScript types that JSON expresses. Siren allows objects to be imbued with
a +type+ attribute, which if present causes the parser to cast the object to an
instance of the named type instead of a hash. Instead of hash keys, the keys in the
JSON object become instance variables of the typed object. To allow the parser to use
a class for casting, it must be extended using <tt>Siren::Node</tt>:

  class PersonModel
    extend Siren::Node
  end
  
  data = Siren.parse <<-JSON
          {
              "type":   "person_model",
              "name":   "Jimmy",
              "age":    25
          }
  JSON
  
  #=> #<PersonModel @type="person_model", @age=25, @name="Jimmy">


== JSONQuery

JSONQuery is a language designed for filtering and transforming JSON-like object graphs.
Queries may be run against Ruby objects of any type, and may also be used as values in
JSON documents to generate data during parsing. For example:

  # Run a filter against an array
  adults = Siren.query "$[? @.age >= 18 ]", people
  
  # Embed the query for expansion by the parser
  people = Siren.parse <<-JSON
          {
              "people": [
                  {"name":  "John",   "age":  23},
                  {"name":  "Paul",   "age":  21},
                  {"name":  "George", "age":  12},
                  {"name":  "Ringo",  "age":  17}
              ],
              
              "adults": {"$ref": "$.people[? @.age >= 18 ]"}
          }
  JSON
  
As for IDs, queries are embedded using the <tt>$ref</tt> syntax. Parsing the above
yields the following Ruby object:

  { "adults" => [ {"name"=>"John", "age"=>23},
                  {"name"=>"Paul", "age"=>21}
                ],
    "people" => [ {"name"=>"John", "age"=>23},
                  {"name"=>"Paul", "age"=>21},
                  {"name"=>"George", "age"=>12},
                  {"name"=>"Ringo", "age"=>17}
                ]
  }

Siren supports the following sections of the JSONQuery language. A query is composed of
an object selector followed by zero or more filters.


=== Object selectors

An object selector is either a valid object ID, or the special symbols <tt>$</tt>
or <tt>@</tt>.

* An object ID is a letter followed by zero or more letters, numbers or underscores.
  Use of an ID produces a reference to the object with that +id+ property, as illustrated
  above.
* <tt>$</tt> represents the root object the query is being run against, or the root of
  the JSON document currently being parsed.
* <tt>@</tt> represents the current object in a looping operation, such as a map, sort
  or filter.


=== Expressions

Expressions are used within filters to generate data and perform comparisons. They work
in a similar fashion to JavaScript expressions, and may contain strings (enclosed in single
quotes), numbers, +true+, +false+, +null+ or other JSONQuery expressions. The following
operators are supported:

* Arithmetic: <tt>+</tt>, <tt>-</tt>, <tt>*</tt>, <tt>/</tt>, <tt>%</tt>
* Comparison: <tt><</tt>, <tt><=</tt>, <tt>></tt>, <tt>>=</tt>
* Equality: <tt>=</tt> for equality, <tt>!=</tt> for inequality
* String matching: <tt>=</tt> for case-sensitive matching, <tt>~</tt> for case-insensitive
* Logic: <tt>&</tt> for boolean AND, <tt>|</tt> boolean OR (not bitwise)
* Subexpressions are delimited using parentheses <tt>(</tt> and <tt>)</tt>


=== String matching

The <tt>=</tt> and <tt>~</tt> operators, when used with strings, perform case-sensitive
and case-insensitive matching respectively. Within a string, <tt>*</tt> matches zero or
more characters of any type, and <tt>?</tt> matches a single character.

  Siren.query "$[? @ = 'b*']", %w[foo bar baz]
  #=> ["bar", "baz"]
  
  Siren.query "$[? @ = 'b?']", %w[foo bar baz]
  #=> []
  
  Siren.query "$[? @ ~ 'BA?']", %w[foo bar baz]
  #=> ["bar", "baz"]


=== Field access filter

A field access filter selects a named field from an object. Fields are accessed using the
dot notation, or the bracket notation with an expression evaluating to a string or an integer.
This filter does one of the following based on the object's type:

* If the object is a +Hash+, the value for the named key is produced.
* If the object is an +Array+, the value at the given index is produced.
* If the object has the named method, the value of that method call is returned.
* Otherwise, the value of the named instance variable is produced.

    data = {
      "key"   => "foo",
      "name"  => { "foo" => "bar" }
    }
    
    Siren.query "$.key", data
    #=> "foo"
    
    Siren.query "$[1]", %w[foo bar whizz]
    #=> "bar"
    
    Siren.query "$.name[ $.key ]", data
    #=> "bar"
    
    Siren.query "$.size", [3,4,5]
    #=> 3

Fields can also be accessed recursively; the syntax <tt>..symbol</tt> returns an array
of all the values in the object with the property name +symbol+.

  data = {"rec" => 6, "key" => {"rec" => 7}}
  
  Siren.query "$..rec", data
  #=> [6, 7]


=== Array slice filter

The array slice filter selects a subset of values from an array. The syntax is <tt>[a:b:s]</tt>,
where +a+ is the start index, +b+ the end index and +s+ the step amount. The step may be
omitted (as in <tt>[a:b]</tt>), in which case the step defaults to <tt>1</tt>.

  Siren.query "$[1:5:2]", %w[a b c d e f g h]
  #=> ["b", "d", "f"]


=== Selection filter

The selection filter extracts a subset of an array using a predicate condition.
Predicates are enclosed in <tt>[? ... ]</tt>, and within this block the symbol <tt>@</tt>
refers to each member of the array in turn. For example:

  Siren.query "$.strings[? @.length > 3]", {'strings' => %w[the quick brown fox]}
  #=> ["quick", "brown"]
  
  Siren.query "$[? @ > 2 & @ <= 5]", [9,2,7,3,8,5]
  #=> [3, 5]

Selections can be made recursively by prefixing the filter with two dots (<tt>..</tt>).
This will search the filtered object recursively for any properties that match the
predicate expression, and return them as a flat array.

  data = [
      8,2,5,7,3,
      {
          'foo' => 12,
          'bar' => 7,
          'whizz' => [9,2,6,4]
      }
  ]
  
  Siren.query "$..[? @ % 4 = 0]", data
  #=> [8, 4, 12]


=== Mapping filter

Mappings work like Ruby's <tt>Enumerable#map</tt> method, producing a new array by
applying some expression to the members of another. Mappings are expressed by enclosing
the mapping expression in <tt>[= ... ]</tt>

  Siren.query "$[= @[ 'upcase' ] ]", %w[the quick brown fox]
  #=> ["THE", "QUICK", "BROWN", "FOX"]
  
  Siren.query "$[= @.length + 2]", %w[the quick brown fox]
  #=> [5, 7, 7, 5]

Just like other types of filters, mapping filters may use subqueries inside the
main query:

  Siren.query "$[= @[? @ > 4] ]", [ [2,9,4,3], [5,8,2], [3,6] ]
  #=> [[9], [5, 8], [6]]
  
  Siren.query "$[= @[? @ > 4][0] + @.size ]", [ [2,9,4,3], [5,8,2], [3,6] ]
  #=> [13, 8, 8]


=== Sorting filter

The sorting filter returns a sorted version of the array it is operating on. The sort
must contain one or more comma-separated expressions to use to compare the items in the
array, and each expression must specify ascending (<tt>/</tt>) or descending (<tt>\\</tt>)
order. Expressions are prioritized from left to right. For example, the following sorts
the people in the list in ascending order by last name, then in descending order by first
name for people with the same last name:

  people = Siren.parse <<-JSON
          [
              {"first": "Thom",   "last": "Yorke"},
              {"first": "Jonny",  "last": "Greenwood"},
              {"first": "Ed",     "last": "O'Brien"},
              {"first": "Colin",  "last": "Greenwood"},
              {"first": "Phil",   "last": "Selway"}
          ]
  JSON
  
  Siren.query "$[ /@.last, \\@.first ]", people
  
  #  => [ { "last"=>"Greenwood",  "first"=>"Jonny"},
  #       { "last"=>"Greenwood",  "first"=>"Colin"},
  #       { "last"=>"O'Brien",    "first"=>"Ed"},
  #       { "last"=>"Selway",     "first"=>"Phil"},
  #       { "last"=>"Yorke",      "first"=>"Thom"} ]


== License

(The MIT License)

Copyright (c) 2009 James Coglan

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
