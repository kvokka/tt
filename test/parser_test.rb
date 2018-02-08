require 'test_helper'

module OnTheBeach
describe Parser do
  describe 'should parse query' do
    it 'empty test' do
      assert_equal %i[], Parser.()
    end

    it 'a =>' do
      assert_equal %i[a], Parser.(a: nil)
      assert_equal %i[a], Parser.('  a  => ')
    end

    it "a=> \n b => \n c =>" do
      assert_equal %i[a b c], Parser.(a: nil, b: nil, c: nil)
      assert_equal %i[a b c], Parser.("a=>  \n  b => , c =>")
    end

    it "a=> \n b => c\n c =>" do
      assert_equal %i[a c b], Parser.(a: nil, b: :c, c: nil)
      assert_equal %i[a c b], Parser.("a=> \n b => c\n c =>")
    end

    it "a=> \n b => c\n c => f\n d => a\n e => b\n f =>" do
      assert_equal %i[a d f c b e], Parser.(a: nil, b: :c,  c: :f, d: :a, e: :b, f: nil)
      assert_equal %i[a d f c b e], Parser.("a=> \n b => c\n c => f\n d => a\n e => b\n f =>")
    end
      
    it "a=> \n b => c\n c => c" do
      assert_raises ArgumentError do 
        Parser.("a=> \n b => c\n c => c")
      end
    end

    it "a=> \n b => c\n c => f \n d => a \n e => \n f => b" do
      assert_raises InfiniteLoop do 
        Parser.("a=> \n b => c\n c => f \n d => a \n e => \n f => b")
      end
    end

    it 'return clean result with multiple run' do
      parser  = Parser.new("a=>  \n  b => , c =>")
      parser.()
      assert_equal %i[a b c], parser.()
    end
  end
end
end
