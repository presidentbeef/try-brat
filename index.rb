require "rubygems"
require "sinatra"
require "sinatra/streaming"
require "shell"
require "base64"
require_relative "github_hook"

Shell.def_system_command :brat, "/home/bratuser/bin/brat"

def run_brat code
  code = <<-BRAT
  result$ = {
  #{code}
  }()
  p "-" * 40
  p "Return value: \#{->result$}"
  BRAT

  Shell.new.transact do
    echo(code) | brat("-")
  end.to_s
end

get '/' do
	erb :index
end

post '/run' do
  if params[:code] and not params[:code].empty?
    run_brat params[:code]
  else
    "No code given: #{params[:code]}"
  end
end

get '/run/:code' do
  if params[:code] and not params[:code].empty?
    run_brat Base64.decode64 params[:code]
  else
    "No code given"
  end
end

post "/tests/#{GITHUB_HOOK}" do
  fork do
    exec "/var/www/try-brat/test_brat.sh"
  end

  "Alright"
end

get '/status' do
  if params[:callback]
    "#{params[:callback]}( { status: #{File.read("/var/www/try-brat/tmp/brat/status").gsub("\n", "").inspect } })"
  else
    "Error"
  end
end
