//SETTING UP OUR POPUP
//0 means disabled; 1 means enabled;
var popupStatus = 0;

//loading popup with jQuery magic!
function loadPopup(popUpDivQuery,popUpBackgroundQuery){
	//loads popup only if it is disabled
	if(popupStatus==0){
		popUpBackgroundQuery.css({
			"opacity": "0.7"
		});
		popUpBackgroundQuery.fadeIn("slow");
		popUpDivQuery.fadeIn("slow");
		popupStatus = 1;
	}
}

//disabling popup with jQuery magic!
function disablePopup(popUpDivQuery,popUpBackgroundQuery){
	//disables popup only if it is enabled
	if(popupStatus==1){
		popUpBackgroundQuery.fadeOut("slow");
		popUpDivQuery.fadeOut("slow");
		popupStatus = 0;
	}
}

//centering popup
function centerPopup(popUpDivQuery,popUpBackgroundQuery,is_centered){
	//request data for centering
    var w = (document.documentElement.clientWidth/4);
    var h = (document.documentElement.clientHeight/4);
    var w2 = w/2;
    var h2 = h/2;
	var windowWidth = document.documentElement.clientWidth-(w*2);
	var windowHeight = document.documentElement.clientHeight-(h*2);
	var popupHeight = popUpDivQuery.height();
	var popupWidth = popUpDivQuery.width();
	//centering
	popUpDivQuery.css({
		"position": "absolute",
		"top": ((is_centered) ? h2 : 0)+"px",
		"left": ((is_centered) ? w2 : 0)+"px"
	});
	//only need force for IE6
	
	popUpBackgroundQuery.css({
        "position": "absolute",
        "top": ((is_centered) ? h2 : 0)+"px",
        "left": ((is_centered) ? w2 : 0)+"px",
		"height": windowHeight,
        "width": windowWidth
	});
	
}

