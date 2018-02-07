module OnTheBeach
  class JobsList
    attr_reader :jobs

    def initialize **jobs
      @jobs = jobs
      @jobs_backup = jobs.dup
      check_consistency!
    end

    def neat_each &blk
      init_size = jobs.size
      jobs.each &blk 
      raise InfiniteLoop  if any? && init_size == jobs.size
      self
    end

    def size_changes?
      initial_size != jobs.size
    end

    def empty?
      jobs.empty?
    end

    def any?
      !empty?
    end

    def delete(*args)
      jobs.delete(*args)
    end

    def restore
      @jobs = @jobs_backup.dup
    end

    private

    def check_consistency!
      raise ArgumentError if self.jobs.any?{|k,v| k == v }
      true
    end
  end
end