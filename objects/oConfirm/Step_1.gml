/// @description Click
if active&&(selected||hover)&&buttonPressed(control.confirm)&&string_length(oKeyboard.str)>0
{
	letterClicked();
	oPopup.exiting=true;
	with oKeyboard processInput();
}