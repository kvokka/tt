require 'test_helper'

describe OnTheBeach::Parser do
  describe 'should parse query' do
    it 'a =>' do
      assert_equal %i[a], OnTheBeach::Parser.call(a: nil)
    end

    it "a=> \n b => \n c =>" do
      assert_equal %i[a b c], OnTheBeach::Parser.call(a: nil, b: nil, c: nil)
    end

    it "a=> \n b => c\n c =>" do
      assert_equal %i[a c b], OnTheBeach::Parser.call(a: nil, b: :c, c: nil)
    end

    it "a=> \n b => c\n c => f\n d => a\n e => b\n f =>" do
      assert_equal %i[a d f c b e], OnTheBeach::Parser.call(a: nil, b: :c,  c: :f, d: :a, e: :b, f: nil)
    end
      
    it "a=> \n b => c\n c => c" do
      assert_raises ArgumentError do 
        OnTheBeach::Parser.call(a: nil, b: :c, c: :c)
      end
    end

    it "a=> \n b => c\n c => f \n d => a \n e => \n f => b" do
      assert_raises OnTheBeach::InfiniteLoop do 
        OnTheBeach::Parser.call(a: nil, b: :c,  c: :f, d: :a, e: nil, f: :b)
      end
    end
  end
end
