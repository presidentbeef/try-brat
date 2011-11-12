function submit_code(code_box, result_box) {
 		var code = $(code_box).val();
		if(code.replace(/\s/g,"") == "") { $(result_box).text("No code!"); return; }
		$(result_box).text("[Running]");
		return $.post("/run", { code: code }, function(data) {
      if(data == "")
  			$(result_box).text("Execution failed (probably timed out).");
      else
  			$(result_box).text(data);
		})
}

function set_program(program) {
  $("#program").val($("#" + program).text());
}

function clear_it() {
  $("#program").val('');
  $("#result").text('');
}
