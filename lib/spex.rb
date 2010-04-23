begin
  require 'facter'
rescue LoadError
  abort "Requires 'facter'"
end

module Spex
  autoload :Check,         'spex/check'
  autoload :CLI,           'spex/cli'
  autoload :Execution,     'spex/execution'
  autoload :FileCheck,     'spex/checks/file_check'
  autoload :Runner,        'spex/runner'
  autoload :Scenario,      'spex/scenario'
  autoload :Script,        'spex/script'
end
