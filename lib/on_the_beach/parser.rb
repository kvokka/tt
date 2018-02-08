module OnTheBeach
  class Parser
    attr_reader :jobs

    def initialize(jobs = {})
      @jobs = JobsList.new jobs
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      neat_loop do |job, depencency|
        result.push(job) && jobs.delete(job) unless depencency
        ind = result.index(depencency)
        next unless ind
        result.insert(ind + 1, job) && jobs.delete(job)
      end
    end

    private

    attr_writer :jobs

    def neat_loop(&blk)
      loop do
        jobs.neat_each(&blk)
        break result.dup if jobs.empty?
      end
    ensure
      self.jobs = JobsList.new jobs.restore
      result.clear
    end

    def result
      @result ||= []
    end
  end
end
