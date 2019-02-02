# frozen_string_literal: true

module Docker
  class ParseOutput
    def self.log_output(body)
      parse_output(body) do |item|
        if item['stream']
          puts item['stream']
        elsif item['errorDetail']
          puts item['errorDetail']['message']
        end
      end
    end

    def self.parse_output(body, &block)
      if body.include?('}{')
        body.split('}{').each do |line|
          line = "{#{line}" unless line =~ /\A{/
          line = "#{line}}" unless line =~ /}\z/
          yield Docker::Util.parse_json(line)
        end
      else
        body.each_line { |line| block.call(Docker::Util.parse_json(line)) }
      end
    end
  end
end
