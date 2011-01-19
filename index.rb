require "rubygems"
require "sinatra"
require_relative "brat_job"

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
