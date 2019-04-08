%% Script to draw a 9 random symbols onscreen
% Slimmed down draw script
% Bibiliography:
% http://peterscarfe.com/ptbtutorials.html

% Call setup scripts
setup_screen;

% Create reel.Info struct
[reelInfo] = create_reelInfo();

% Fill reel.Info struct with current spin info
update_reelInfo; % also sets up grid dimensions

% Draw a grid
draw_grid;

% Draw shapes
% draw_shapes(1:9, reelInfo);
draw_shapes;

% Flip to the screen
Screen('Flip', window);

% Wait for a key press
KbStrokeWait;
   
% Clear the screen
sca;