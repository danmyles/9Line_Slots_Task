% While loop to allow user to repeat instructions if desired.
keyCode = 38;

while keyCode == 38
    
    keyCode = 0;
    
    % View these instructions again?
    DrawFormattedText(screenInfo.window,'To view these instructions again press the 9 key\n\nOtherwise press any key to continue', 'center', screenInfo.yCenter);
    Screen('Flip', screenInfo.window);
	[~, keyCode] = KbWait(-1, 2);
    
    % set key down and wait for user to make key press   
    keyCode = find(keyCode);
    
end
