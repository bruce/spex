begin
  require 'facter'
rescue LoadError
  abort "Requires 'facter'"
end

module Spex
  autoload :Assertion,     'spex/assertion'
  autoload :CLI,           'spex/cli'
  autoload :Execution,     'spex/execution'
  autoload :FileAssertion, 'spex/assertions/file_assertion'
  autoload :Runner,        'spex/runner'
  autoload :Scenario,      'spex/scenario'
  autoload :Script,        'spex/script'
end
