# -*- coding: utf-8 -*-
require 'colorize'

module QueenCheck
  class Result
    def initialize(properties, is_success, exception = nil)
      @properties = properties
      @is_success = is_success == true
      unless exception.nil?
        @exception = exception
        @is_success = false
      end
    end
    attr_reader :properties

    def is_success?; @is_success; end
    def is_failure?; !@is_success; end
    def is_exception?; !@exception.nil?; end
  end

  class ResultReport < Array
    alias :tests :length

    def initialize(*args)
      super(*args)
      @labels = {}
    end

    def pretty_report
      justify = count(:all).to_s.size
      label_justify = @labels.keys.map{|label| label.size}.max
      [
        "Tests: ".green + count(:all).to_s.colorize(count(:all) == count(:success) ? :green : :red),
        "  ✓ Successes  : #{count(:success).to_s.rjust(justify)}#{
          (@labels.empty? ?  '' : "\n") + @labels.keys.map { |label|
            "    #{label.ljust(label_justify)} : #{count(label, successes).to_s.rjust(justify)}"
          }.join("\n")
        }".green,
        "  ✗ Failures   : #{count(:failures).to_s.rjust(justify)}#{
          (@labels.empty? ?  '' : "\n") + @labels.keys.map { |label|
            "    #{label.ljust(label_justify)} : #{count(label, failures).to_s.rjust(justify)}"
          }.join("\n")
        }".yellow,
        "  ✷ Exceptions : #{count(:exception).to_s.rjust(justify)}#{
          (@labels.empty? ?  '' : "\n") + @labels.keys.map { |label|
            "    #{label.ljust(label_justify)} : #{count(label, exceptions).to_s.rjust(justify)}"
          }.join("\n")
        }".red
      ].join("\n")
    end

    def report(with_label = true)
      [
        ["tests", count(:all)],
        ["success", count(:success)],
        ["failure", count(:failure)],
        ["exception", count(:exception)]
      ] + (
        if with_label
          report_label
        else
          []
        end
      )
    end

    def report_label
      @labels.keys.map { | label |
        [label, count(label)]
      }
    end

    def count(label = :all, list = self)
      case label
      when :all, :tests
        self.size
      when :success, :successes
        self.successes.size
      when :failure, :failures
        self.failures.size
      when :exception, :exceptions
        self.exceptions.size
      else
        raise ArgumentError, "`#{label}` is not valid label" if !@labels.has_key?(label)
        list.reject {|result|
          !@labels[label].call(*result.properties)
        }.size
      end
    end

    def labeling(label, &block)
      @labels[label] = block
    end

    def successes
      self.reject{|result| result.is_failure? }
    end

    def failures
      self.reject{|result| result.is_success? }
    end

    def exceptions
      self.reject{|result| !result.is_exception? }
    end
  end
end
