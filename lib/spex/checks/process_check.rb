module Spex
  class ProcessCheck < Check

    def pattern
      @pattern ||= target.is_a?(Regexp) ? target : Regexp.new(target)
    end
    
    def ps_executable
      ps = Facter.value(:ps)
      if ps && !ps.empty?
        ps
      else
        abort "Facter does not support 'ps' fact."
      end
    end

    def current_pid
      table = IO.popen(ps_executable) { |ps| ps.readlines }
      table.each do |line|
        if pattern.match(line)
          return line.sub(/^\s+/, '').split(/\s+/)[1]
        end
      end
      nil
    end

  end
end
