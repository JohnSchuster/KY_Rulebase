// 	--- xRulz Client Side Code Development ---
// 	--- See DesignGuidelinesReadMe.txt ---
// 	---	SD, 2013-05-26
$(function() {  // jQuery Ready Idiom	
	// Asynchronous jQuery Bindings
	 $( "#xr03_buttonset" ).buttonset();
	// Bind the handler to the "Continue" button's click event
/*	$( submit ).on( "click", continue_click );	*/
	
	// Synchronous Event Handler
	function continue_click( event ) {
		var delimiter = ", ";
		var temp="";
		$( ":checked" ).each(function(index, element) {
			if (""==temp) {// First Pass, no delimiter
				temp = temp +  $(element).attr("id");
			} else {//All other passes, adds delimiter between elements
				temp = temp + delimiter;
				temp = temp +  $(element).attr("id");
			}
		});
		fpr_physical_limitations = temp;		
		// Assign temp result to target (converting to expanded state name?)
		// Possibly add confirmation dialog here
		// POST Form
	}
	
});
