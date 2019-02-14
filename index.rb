require "shell"
require "base64"
require "sinatra"

Shell.def_system_command :brat, "/home/brat/run_brat.sh"

def run_brat code
  code = <<-BRAT
includes :eval :base64 "parser/brat2lua"

decoded = base64.decode "#{Base64.encode64(code).strip.gsub("\n", "")}"
parsed = brat2lua.start_interactive.run decoded
result = eval.run_parsed parsed
p "-" * 40
p "Return value: \#{->result}"
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
