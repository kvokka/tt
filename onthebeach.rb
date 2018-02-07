class InfiniteLoop < StandardError;end

def query(jobs={})
  [].tap do |result|
    loop do
      initial_query_size = jobs.size
      jobs.each_pair do |k,v| 
        raise ArgumentError                        if k == v
        (result.push(k) && jobs.delete(k))         unless v
        if ind = result.index(v)
          (result.insert(ind+1, k) && jobs.delete(k))
        end
      end
    break result if jobs.size.zero?  
    raise InfiniteLoop                             if jobs.size == initial_query_size
    end
  end
rescue ArgumentError, InfiniteLoop => error
  error # 'ArgumentError' # <= This thick is made only for easy testing
end

p query a: nil
p query a: nil, b: nil, c: nil
p query a: nil, b: :c,  c: nil
p query a: nil, b: :c,  c: :f, d: :a, e: :b, f: nil
p query a: nil, b: :c,  c: :c
p query a: nil, b: :c,  c: :f, d: :a, e: nil, f: :b