// JavaScript for DailyCaption

function updateVotes(caption_dom_id,votes){
  $('votes_count_' + caption_dom_id).setTextValue(votes);
  $('votes_' + caption_dom_id).setTextValue("Voted!");
}



function update_count(str,message_id) { 
  len=str.length; 
  if (len < 200) { 
    $(message_id).setInnerXHTML("<span style='color: green'>"+ 
    (200-len)+" remaining</span>"); 
  } else { 
    $(message_id).setInnerXHTML("<span style='color: red'>"+ 
    "Comment too long. Only 200 characters allowed.</span>"); 
  } 
}

/*
pg 141
// use Dialog.DIALOG_POP for a popup 
var d = new Dialog(Dialog.DIALOG_CONTEXTUAL ); 
// Setting the context is only 
// necessary for contextual dialogs 
d.setContext($('comment')); 
d.onconfirm = function() { 
$('comment').setTextValue(""); 
}; 
// Show a message with only one button 
d.showMessage(title,message,button_name); 
// Or, show a message with two buttons 
d.showChoice(title,message,confirm_name,cancel_name) 

*/