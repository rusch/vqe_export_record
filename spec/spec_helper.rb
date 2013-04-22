require 'simplecov'
SimpleCov.start

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'vqe_export_record/version'

def to_binary(data)
  [ data.gsub(/\s+/,'').split(':').join ].pack('H*')
end

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |f| require f }
include TestDescriptions
