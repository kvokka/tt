require 'on_the_beach/version'
require 'on_the_beach/parser'
module OnTheBeach
  class InfiniteLoop < StandardError;end
end

# p query a: nil
# p query a: nil, b: nil, c: nil
# p query a: nil, b: :c,  c: nil
# p query a: nil, b: :c,  c: :f, d: :a, e: :b, f: nil
# p query a: nil, b: :c,  c: :c
# p query a: nil, b: :c,  c: :f, d: :a, e: nil, f: :b