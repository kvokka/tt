require 'test_helper'

module OnTheBeach
describe JobsList do
  describe 'should parse string into hash' do
    before { @default_hash = {:a=>nil, :b=>:c, :c=>nil} }
    
    it '3 elements string' do
      assert_equal(@default_hash, JobsList.new("a=> \n b => c\n c =>").jobs)
    end

    it 'should raise with cellular dependency' do
      assert_raises ArgumentError, &-> { JobsList.new("a=>a") }
    end

    it 'should return hash if hash ginen' do
      assert_equal(@default_hash, JobsList.new(@default_hash).jobs)
    end

    it 'should restore jobs' do
      list = JobsList.new(@default_hash)
      list.jobs[:foo] = :bar
      list.restore
      assert_equal(@default_hash, list.jobs)
    end

    it 'should raise with infinite loop' do
      assert_raises InfiniteLoop, &-> { JobsList.new("a=>b,b=>c,c=>a").neat_each{|_job| } }
    end

    it 'do have #any?',     &->{ assert JobsList.new(@default_hash).any?   }
    it 'dont have #empty?', &->{ refute JobsList.new(@default_hash).empty? }
  end
end
end
