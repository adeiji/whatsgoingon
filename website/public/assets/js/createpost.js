$(document).ready(function  () {
	$('input[type=combodate]').combodate({
    	minYear: 2014,
    	maxYear: 2015,
    	minuteStep: 10
	});  

	$('.dropdown-menu li > a').click(function(e){

		var parent = $(this).parent().parent().parent();
		var button = $(parent).children('button');
		var text = this.innerHTML;
		//The innerHTML contains < and > symbols as &lt; and &gt; so we have to replace these values with < and >.
		text = text.replace('&lt;','<').replace('&gt;', '>');
        button.text( text + " " );
        button.append( '<span class="caret"></span>' );

    });
})