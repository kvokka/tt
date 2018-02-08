require 'json'

module OnTheBeach
  class JobsList
    attr_reader :jobs

    def initialize str
      @jobs = parse(str)
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

    def parse hash_or_str
      return hash_or_str.dup if hash_or_str.respond_to?(:to_hash)
      hash_or_str.split(/[\n|,]/).
          reject(&:empty?).
          map{ |el| el.split('=>').map(&:strip).reject(&:empty?).map(&:to_sym).tap{|arr| arr.push(nil) if arr.size == 1 }}.
          to_h
    end
  end
end