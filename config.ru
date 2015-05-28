require File.expand_path('../root.rb', __FILE__)
use Rack::ShowExceptions
run MyApp.new