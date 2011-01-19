function get_result(result_id) {
		$.get("/job/" + result_id + "/result", function(response, status) {
			if(response == "") response = "Execution timed out."
			$("#result").val(response);
		});
		$(':submit').attr('disabled', '');
}

function wait_on(result_id) {
		var url = "/job/" + result_id + "/status";

		$.poll(function(retry){
			$.get(url, function(response, status) {
				if (response != 'finished')
					retry();
				else
					get_result(result_id);
				})
			})
}

function submit_code() {
		var code = $("#program").val();
		if(code.replace(/\s/g,"") == "") return;
		$(':submit').attr('disabled', 'disabled');
		$.post("/", { program: code }, function(data) {
			$("#result").text("[Running]");
			wait_on(data);
		})
}

$("#code_box").submit(function() {
	submit_code();
	return false;
})
