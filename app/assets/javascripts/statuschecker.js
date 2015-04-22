!function($) {
	'use strict';

	$(function() {

		var processResponse = function(data) {
			console.log(data);
			if (!data) {
				data = {
					status : 'No Data'
				};
			}
			
			data.hasError = function(){
				return data.status === 'Error' || data.status === 'No Data';
			}
			
			data.noData = function(){
				return data.status === 'No Data';
			}

			data.serviceStatus = function() {
				return function(service, render) {
					var errors = data.errors;
					for (var i = 0; i < errors.length; i++) {
						if (errors[i] === 'CHECK FAILED: ' + render(service)) {
							return "<span style=\"color:red;\" class=\"glyphicon glyphicon glyphicon-remove\" aria-hidden=\"true\">";
						}
					}

					return "<span style=\"color:green;\" class=\"glyphicon glyphicon glyphicon-ok\" aria-hidden=\"true\">";
				}
			}

			$.get('/mobile-proxy/v1/assets/statusresults.mst', function(template) {
				var rendered = Mustache.render(template, data);
				$('#status-check-progress').hide();
				$('#status-results').html(rendered);
				
			});
		};

		//$.getJSON("/mobile-proxy/v1/status")
		//   .done(function(data, textStatus, jqXHR) {
		//			processResponse(data);})
		//	.fail(function(jqXHR, textStatus, errorThrown) {
		//	        processResponse(jqXHR.responseJSON);
		//     });
	});

}(jQuery)