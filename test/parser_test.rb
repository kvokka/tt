require 'test_helper'

module OnTheBeach
  describe Parser do
    describe 'should parse query' do
      it 'empty test' do
        assert_equal %i[], Parser.call
      end

      it 'a =>' do
        assert_equal %i[a], Parser.call(a: nil)
        assert_equal %i[a], Parser.call('  a  => ')
      end

      it "a=> \n b => \n c =>" do
        assert_equal %i[a b c], Parser.call(a: nil, b: nil, c: nil)
        assert_equal %i[a b c], Parser.call("a=>  \n  b => , c =>")
      end

      it "a=> \n b => c\n c =>" do
        assert_equal %i[a c b], Parser.call(a: nil, b: :c, c: nil)
        assert_equal %i[a c b], Parser.call("a=> \n b => c\n c =>")
      end

      it "a=> \n b => c\n c => f\n d => a\n e => b\n f =>" do
        result = %i[a d f c b e]
        hash = { a: nil, b: :c, c: :f, d: :a, e: :b, f: nil }
        string = "a=> \n b => c\n c => f\n d => a\n e => b\n f =>"
        assert_equal result, Parser.call(hash)
        assert_equal result, Parser.call(string)
      end

      it "a=> \n b => c\n c => c" do
        assert_raises ArgumentError do
          Parser.call("a=> \n b => c\n c => c")
        end
      end

      it "a=> \n b => c\n c => f \n d => a \n e => \n f => b" do
        assert_raises InfiniteLoop do
          Parser.call("a=> \n b => c\n c => f \n d => a \n e => \n f => b")
        end
      end

      it 'return clean result with multiple run' do
        parser = Parser.new("a=>  \n  b => , c =>")
        parser.call
        assert_equal %i[a b c], parser.call
      end
    end
  end
end
