require 'shell'
require 'resque-result'

Shell.def_system_command :brat, "/home/bratuser/bin/brat"

class BratJob
	extend Resque::Plugins::Result

	@queue = "trybrat"

	def expire_meta_in
		7200	
	end

	def self.perform meta_id, code
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
end
