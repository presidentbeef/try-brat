require "rubygems"
require "sinatra"
require "sinatra/streaming"
require "shell"
require "base64"
require_relative "github_hook"

Shell.def_system_command :brat, "/home/bratuser/bin/brat"

def run_brat code
  code = <<-BRAT
includes :eval :base64 "parser/brat2lua"

decoded = base64.decode "#{Base64.encode64(code).strip}"
parsed = brat2lua.start_interactive.run decoded
result = eval.run_parsed parsed
p "-" * 40
p "Return value: \#{->result}"
  BRAT

  File.open("/var/www/try-brat/logit", "w") do |f|
    f.puts code
  end

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
  headers "Content-Type" => "application/javascript"

  if params[:callback]
    "#{params[:callback]}( { status: #{File.read("/var/www/try-brat/tmp/brat/status").gsub("\n", "").inspect } })"
  else
    "Error"
  end
end
