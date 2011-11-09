require "rubygems"
require "sinatra"
require "shell"
require_relative "brat_job"

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

post '/' do
	code = params[:program]
	job = BratJob.enqueue code
	job.meta_id
end

get '/job/:code_id/status' do
	job = BratJob.get_meta(params[:code_id])
	if job
		if job.succeeded?
			"finished"
		elsif job.failed?
			"failed"
		else
			"working"
		end
	else
		"invalid"
	end
end

get '/job/:code_id/result' do
	job = BratJob.get_meta(params[:code_id])
	if job
		if job.succeeded?
			job.result
		elsif job.failed?
			"[Failed]"
		else
			"[Processing]"
		end
	else
		"No such job!"
	end
end

post '/run' do
  if params[:code] and not params[:code].empty?
    run_brat params[:code]
  else
    "No code given: #{params[:code]}"
  end
end
