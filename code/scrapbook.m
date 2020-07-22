screenL = screenInfo.windowRect;
screenL(3) = screenL(3)/2;
screenR = [screenL(3), 0, screenInfo.windowRect(3:4)];

rect = screenL * 0.65;

% Left Rect
[x, y] = RectCenter(screenL);           % Get centre of left side of screen
rectL = CenterRectOnPoint(rect, x, y);  % Get rect coords for FrameRect
textL = InsetRect(rectL, 75, 75);       % Inset smaller box for text draws

% Right Rect (as above)
[x, y] = RectCenter(screenR);
rectR = CenterRectOnPoint(rect, x, y);
textR = InsetRect(rectR, 75, 75);

Screen('FrameRect', screenInfo.window, screenInfo.black, rectR, screenInfo.gridPenWidthPixel);
Screen('FrameRect', screenInfo.window, screenInfo.black, rectL, screenInfo.gridPenWidthPixel);

DrawFormattedText2('Bet High', ... 
                   'win', screenInfo.window, ...
                   'winRect', textL, ...
                   'sx', 'center', 'sy', 'top', ...
                   
                  )

Screen('Flip', screenInfo.window);