%% Script to draw a 9 random symbols onscreen
% Slimmed down draw script
% Bibiliogra phy:
% http://peterscarfe.com/ptbtutorials.html

% Call setup scripts
setup_screen;

% Assign number of spins
spins = 1

for i = 1:spins
    
    % Randomise symbols and get reel.Info
    setup_reelInfo; % also sets up grid dimensions
    
    % Draw a grid
    draw_grid;
    
    % Draw shapes
    draw_shapes;
    
    % Flip to the screen
    Screen('Flip', window);
    
    % Wait for a key press
    KbStrokeWait;
    
end

% Clear the screen
sca;