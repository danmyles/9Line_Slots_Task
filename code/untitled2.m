width = 39; % horizontal dimension of display (cm)
dist = 60; % viewing distance (cm)

colorOval = [0 0 0]; % color of the two circles [R G B]
colorCross = [255 255 255]; % color of the Cross [R G B]

d1 = 0.6; % diameter of outer circle (degrees)
d2 = 0.2; % diameter of inner circle (degrees)

screen = 0;

[w, rect] = Screen('OpenWindow', screen, [], []);
[cx, cy] = RectCenter(rect);
ppd = pi * (rect(3)-rect(1)) / atan(width/ dist/2) / 360; % pixel per degree

HideCursor;

WaitSecs(2);

Screen('FillOval', w, colorOval, [cx-d1/2 * ppd, cy-d1/2 * ppd, cx+d1/2 * ppd, cy+d1/2 * ppd], d1 * ppd);
Screen('DrawLine', w, colorCross, cx-d1/2 * ppd, cy, cx+d1/2 * ppd, cy, d2 * ppd);
Screen('DrawLine', w, colorCross, cx, cy-d1/2 * ppd, cx, cy+d1/2 * ppd, d2 * ppd);
Screen('FillOval', w, colorOval, [cx-d2/2 * ppd, cy-d2/2 * ppd, cx+d2/2 * ppd, cy+d2/2 * ppd], d2 * ppd);
Screen(w, 'Flip');

WaitSecs(2);

Screen('Close', w);