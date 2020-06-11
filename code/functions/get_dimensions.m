function [output_dim] = get_dimensions(screenInfo, position, shape, baseRect)
% ----------------------------------------------------------------------
% get_dimensions(screenInfo, position, shape)
% ----------------------------------------------------------------------
% Goal of the function :
% Update reelInfo with values from last spin
% ----------------------------------------------------------------------
% Input(s) :
% screenInfo = basic information about the screen 
%
% position = a integer to identify the grid position to draw to
%
% Position codes:
%   1   4   7
%   2   5   8
%   3   6   9
%
%  ** Alternatively position can be set using a two point vector [x, y]
%  *** Function can take scalar, 1-by-n vector, n-by-1 vectorm or 2-by-n
%  vector of X & Y values.
%
% shape = takes a value between 1 and 5 to identify the shape to be drawn
%
% Symbol codes are loosely assigned by number of sides (exc diam)
%
%                       1 = circle
%                       2 = diamond
%                       3 = triangle
%                       4 = rectangle
%                       5 = pentagon
% ----------------------------------------------------------------------
% Output(s):
% reelInfo - overwrites and updates reelInfo values in the base workspace 
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : 8th April 2019, August 2019
% Project : 9_Line_Slots_Task
% Version : 2019a
% ----------------------------------------------------------------------  
% For more information see documentation inside function

% baseRect contains dimensions in pixels we use to draw each of our shapes
% See setup_reelInfo for how this is done, also done for gridRect = size of
% grid vector (also defined using screen dimensions).

if ~exist('baseRect')
    baseRect = screenInfo.windowRect;
    baseRect(3:4) = screenInfo.windowRect(4) / 9;
end

% The FillPoly command takes a radius input to determine the size of the
% shapes. The corners of the polygon are positioned at this radius value
% from the central point. It is also neccesary to define the angle of each
% corner from this central point. This is done below as we require the
% number of sides in order to compute the angle.

% Three options for polygon size:

% 1) Use pythagorean theorem to find lenth of the diagonals of the baseRect.
% This can be used to create a polygon in which uses a radius length that
% is half the diagonal of our baseRect.
%radius = (sqrt(2 .* max(baseRect)^2))/2;

% 2) You may prefer to radius to be the same as the edge of the baseRect
%radius = max(baseRect)/2;

% 3) Or 1.5 in the event you want to go for what "looks" about even.
radius = max(baseRect)/1.5;

% This next script computes the screen positions that each shape will be
% drawn using. This was a little tricky as FillPoly takes a different
% input format to FillRect and FillOval.

% To get around this I've used a number of switch statments. These split
% the flow so that the output is prepared as appropriate for
% FillPoly/Rect/Oval.

% I also used a switch statment to assign the number of sides
% to each poly shape. This can then be used to assign the appropriate
% set of positions/dimensions.

% We have to figure out a way to tell the function whether we are passing
% position codes or X/Y values.

if position(1) <= 9
    % If position variable is less than 9 treat values as position codes.
    % We won't be using X values lower than screenInfo.splitpos(1) so this
    % should work fine.
    
    if size(position, 1) == 1
        position = position';
    end
        
    for j = 1:length(shape)
        
        switch(shape(j))
            case {3, 2, 5} % tri, diam, pent
                
                switch(shape(j))
                    case 3 % tri
                        numSides = 3;
                    case 2 % diam
                        numSides = 4;
                    case 5 % pent
                        numSides = 5;
                end
                
                anglesDeg = linspace(0, 360, numSides + 1 ) - 90;
                anglesRad = anglesDeg * (pi / 180);
                
                xPosVector = cos(anglesRad) .* radius + screenInfo.splitpos(position(j), 1);
                yPosVector = sin(anglesRad) .* radius + screenInfo.splitpos(position(j), 2);
                
                output_dim = [xPosVector; yPosVector]';
                
            case {1, 4} % circ or rect
                
                output_dim = ...
                    CenterRectOnPointd(baseRect, ...
                    screenInfo.splitpos(position(j), 1), ...
                    screenInfo.splitpos(position(j), 2))';
        end
        
    end
    
else % If position should contain X & Y value
    
    for j = 1:length(shape)
        
        switch(shape(j))
            case {3, 2, 5} % tri, diam, pent
                
                switch(shape(j))
                    case 3 % tri
                        numSides = 3;
                    case 2 % diam
                        numSides = 4;
                    case 5 % pent
                        numSides = 5;
                end
                
                anglesDeg = linspace(0, 360, numSides + 1 ) - 90;
                anglesRad = anglesDeg * (pi / 180);
                
                xPosVector = cos(anglesRad) .* radius + position(1);
                yPosVector = sin(anglesRad) .* radius + position(2);
                
                output_dim = [xPosVector; yPosVector]'; 
                
            case {1, 4} % circ or rect
                
                output_dim = ...
                    CenterRectOnPointd(baseRect, ...
                    position(1), ...
                    position(2))'; 
        end
        
    end
        
end



