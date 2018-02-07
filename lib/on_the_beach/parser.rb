module OnTheBeach
  class Parser
    attr_reader :jobs

    def initialize **jobs
      @jobs = JobsList.new jobs
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      loop do
        jobs.neat_each do |k,v| 
          (result.push(k) && jobs.delete(k))         unless v
          if ind = result.index(v)
            (result.insert(ind+1, k) && jobs.delete(k))
          end
        end 
        break result if jobs.empty?
      end
    ensure
      @jobs = jobs.restore
    end

    private

    def result
      @result ||= []
    end
  end
end
