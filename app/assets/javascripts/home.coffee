# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
	$('#code').wysihtml5()
	$('.sample').click ->
 		$('._8051').toggle 'fast', ->
    		# Animation complete.
    	$('.sparc').toggle 'fast', ->
    		# Animation complete.
    
 	$('.show-hide').click ->
 		id = $(this).attr("name")	
 		if $(this).html() == "SHOW"
 			$(this).html("HIDE")
 		else
 			$(this).html("SHOW")
 			
 		$('#'+id).toggle 'fast',->

 	$('#cover').click ->
 		$(this).slideUp 'slow'
 	$("input[name='machine']").change ->	
	 	if $('#machine_binary').is ':checked'
	 		$("#group-machine").show 'fast'
	 		$("#inputs_dropwdown").show 'fast'
	 		$('#code').removeAttr 'required'
	 	else 
	 		$("#group-machine").hide 'fast'
	 		$("#inputs_dropwdown").hide 'fast'
	 		$('#code').prop 'required', true

	$("#binary_machine").change ->
		val = $("#binary_machine").val()
		if !$("#default_option").is(':selected')
			$.ajax
				url: "load_inputs"
				type: 'GET'
				dataType: 'JSON'
				data: {value: val }
				success: (data, textStatus, jqXHR) ->
					txt = ""
					for i in [0..data.length-1] 
					    path = data[i]["path"]
					    name = data[i]["name"]
					    txt += "<option value='#{path}'>#{name}</option>"
					$("#inputs").html(txt)
					$("#temp_value").attr("value", $("#inputs").val())

				error: (jqXHR, textStatus, errorThrown) ->
					alert(textStatus)
					
	$("#inputs").change ->
		$("#temp_value").attr("value", $("#inputs").val())

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).ajaxStart ->
	$('#processing').show();
$(document).ajaxStop ->
	$('#processing').hide();
   			