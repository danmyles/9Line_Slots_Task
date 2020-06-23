 function [reelInfo, outputData] = present_trial(reelInfo, screenInfo, outputData)
    % ----------------------------------------------------------------------
    % [reelInfo] = present_trial(reelInfo)
    % ----------------------------------------------------------------------
    % Goal of the function :
    % This function uses the reelInfo iterator to draw out the next reel 
    % stop from the output file and present a trial. Reelstops are used to 
    % index reelstrip 1 and reelstrip 2 to select the symbols
    % to be draw to the screen.
    % Spin animation is handled seperately by the spin functions.
    % 
    %
    % This function then updates the reelInfo.sym_shape matrix with the symbol
    % identities. This information is then passed back to the update_reelInfo
    % function so that position information can be determined for each of the
    % symbols relative to their grid position
    %
    %
    % Symbol codes are loosely assigned by number of sides (exc diam)
    %
    %                       1 = circle
    %                       2 = diamond
    %                       3 = triangle
    %                       4 = rectangle
    %                       5 = pentagon
    %
    % ----------------------------------------------------------------------
    % Input(s) :
    % reelInfo: reelstrips, trialIndex
    % outputData: stop position, win/loss, payout amount
    % ----------------------------------------------------------------------
    % Output(s):
    % reelInfo: provides updated symbol positions to sym_shape
    % outputData: updates shown 0 -> 1
    % ----------------------------------------------------------------------
    % Function created by Dan Myles (dan.myles@monash.edu)
    % Last update : June 2020
    % Project : 9_Line_Slots_Task
    % Version : 2020a
    % ----------------------------------------------------------------------
    
    % ----------------------------------------------------------------------
    %% 
    % ----------------------------------------------------------------------   
    % Update reelInfo iterator
    reelInfo.trialIndex = (reelInfo.trialIndex + 1);
    
    % Get BeginTime
    outputData.BeginTime(reelInfo.trialIndex) = GetSecs;
    
    % Bump previous reelInfo.outcome to reelInfo.previous
    reelInfo.previous = reelInfo.outcome;
    
    % Get payout amount (if win occurs)
    reelInfo.outcome.payout = outputData.payout(reelInfo.trialIndex);
    
    % Get reel position to for each reelstrip
    reelInfo.outcome.stops(1) = outputData.LStop(reelInfo.trialIndex);
    reelInfo.outcome.stops(2) = outputData.RStop(reelInfo.trialIndex);
       
    % Get centre symbol
    reelInfo.outcome.centre = outputData.CS(reelInfo.trialIndex);
    
    % Get win/match T/F value
    reelInfo.outcome.match = outputData.match(reelInfo.trialIndex);
    
    % Find all indices for above and below the stops on reel 1 & 2
    % Then update reel information
    for i = [1, 2]
        reelInfo.outcome.allstops(:, i) = expandStopINDEX(reelInfo, reelInfo.outcome.stops(i), 1, 1);
    end
    
    % Fill out sym_shape from reel w/ allstops
    reelInfo.outcome.dspSymbols(:, 1) = reelInfo.reelstrip(reelInfo.outcome.allstops(:, 1), 1);
    reelInfo.outcome.dspSymbols(2, 2) = reelInfo.outcome.centre;
    reelInfo.outcome.dspSymbols(:, 3) = reelInfo.reelstrip(reelInfo.outcome.allstops(:, 2), 2);
    
    % ----------------------------------------------------------------------
    %% Spin reels
    % ----------------------------------------------------------------------
    
    % Event Marker (Spin Animation Begin)
    
    % Spin reels
    [reelInfo, outputData] = spin(screenInfo, reelInfo, outputData);
    
    % Event Marker (Spin Animation Complete)
    
    % Wait ISI
    WaitSecs(reelInfo.timing.highlight);
        
	% ----------------------------------------------------------------------
    %% Highlight Active Reels Sequentially
    % ----------------------------------------------------------------------
    
    % I have some old code in a function called "highlight reels" if you 
    % want this done simultaneously.
    
    % Check if active
    if reelInfo.highlight == 2 || reelInfo.highlight == 3

    % This required a fair bit a messing about. Easier if we had some extra
    % variables I could toy with
    
    % Reel 1
    A = reelInfo.outcome.dspSymbols(1:3, 1);
    
    % Reel 2
    B = reelInfo.outcome.dspSymbols(1:3, 3);  

    % C contains the identities of the matched elements, in our case the
    % symbol or shape code.
    % intersect() finds the locations in which the values of the two
    % vectors are the same.
    
    [C] = intersect(A, B, 'stable');
    
    % 1st arg contains indices for where these matches occur in argument A .
    % 2nd arg the same for argument B.
    % 'stable' returns the indices in IA and IB in the order that they
    % occur in argument A
    
    % Print highlighted squares to screen one match at a time
    % Uses intersect output to select colour (C = colour) (IA/IB to index grid posistion)
    
    for i = 1:numel(C)
        
        Ai = ismember(A, C(i));
        Bi = ismember(B, C(i));
        
        % Reel 1 Highlights:
        highlight_pos = screenInfo.gridPos(1:3, :);
        Screen('FrameRect', screenInfo.window, reelInfo.colours(C(i), :)', highlight_pos(Ai, :)', screenInfo.gridPenWidthPixel.*3);
        % Place another square on the inside of the highlight square (looks nice)
        highlight_pos = [highlight_pos(Ai, 1:2) + (3.*screenInfo.gridPenWidthPixel), highlight_pos(Ai, 3:4) - (3.*screenInfo.gridPenWidthPixel)];
        Screen('FrameRect', screenInfo.window, screenInfo.black, highlight_pos', screenInfo.gridPenWidthPixel)
        
        % Reel 2 Highlights:
        highlight_pos = screenInfo.gridPos(7:9, :);
        Screen('FrameRect', screenInfo.window, reelInfo.colours(C(i), :)', highlight_pos(Bi, :)', screenInfo.gridPenWidthPixel.*3);
        % Place another square on the inside of the highlight square (looks nice)
        highlight_pos = [highlight_pos(Bi, 1:2) + (3.*screenInfo.gridPenWidthPixel), highlight_pos(Bi, 3:4) - (3.*screenInfo.gridPenWidthPixel)];
        Screen('FrameRect', screenInfo.window, screenInfo.black, highlight_pos', screenInfo.gridPenWidthPixel)
        
        draw_grid(screenInfo);
        draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));
        
        % Flip to the screen
        Screen('Flip', screenInfo.window);
        
        % Event marker (Highlight Appears)
        
        % Wait time between highlighted reels
        WaitSecs(reelInfo.timing.highlight);
        
    end
    
	% Re-draw without highlights
    draw_grid(screenInfo);
    draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));
    
    % Flip to the screen
    Screen('Flip', screenInfo.window);
    
	% Event marker (Highlighting Complete)
    
    end
    
    % Wait ISI
    WaitSecs(reelInfo.timing.highlight);
    
	% ----------------------------------------------------------------------
    %% Fixation cross
    % ----------------------------------------------------------------------
       
    % Draw a fixation cross
    draw_grid(screenInfo);
    draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));
    draw_fixation(screenInfo, reelInfo);
    
    % Flip to the screen
    Screen('Flip', screenInfo.window);

    % Send event marker (Fixation Cross)
    
    % Wait ISI
    WaitSecs(reelInfo.timing.fixationCross + (rand .* reelInfo.timing.jitter));
    
	% ----------------------------------------------------------------------    
    %% Outcome stimulus
    % ----------------------------------------------------------------------
    
    % Draw grid 
    draw_grid(screenInfo);
     
    % Draw shapes
    draw_shapes(screenInfo, reelInfo, reelInfo.pos.All, nonzeros(reelInfo.outcome.dspSymbols));
       
    % Check if win
    if outputData.match(reelInfo.trialIndex) == 1
        
        % Win
        
        if reelInfo.highlight == 1 || reelInfo.highlight == 2
        % Highlight winning grid positions and show payout amount
        highlight_win(screenInfo, reelInfo);
        end
        
        % Display payout
        draw_payout(screenInfo, reelInfo, 1);
        
    else
        
        % Loss
               
        % Display payout shape, but not text
        draw_payout(screenInfo, reelInfo, 0);
        
    end
       
    % Flip to the screen (outcome stimulus, payout, win highlights)
    [~, StimulusOnsetTime] = Screen('Flip', screenInfo.window);
    
    % Send event marker (Outcome Stimulus)
    
    keyDown = 0;
    
    while(~keyDown)
        
        [keyDown, KeyPressTime] = KbCheck(-1);
        WaitSecs(0.001); % delay to prevent CPU hogging
        
    end
    
    % Get PRP time
    PRP = KeyPressTime - StimulusOnsetTime;
    outputData.PRP(reelInfo.trialIndex) = PRP;
    
    % Update outputData w/ 'shown'
    outputData.shown(reelInfo.trialIndex) = 1;
    
    % Outcome Stimulus Onset Time
    outputData.CSTime(reelInfo.trialIndex) = StimulusOnsetTime;
    
    % Wait minimum trial time if neccesary (likely already elapsed)
    while (GetSecs - StimulusOnsetTime) < reelInfo.timing.outcome
        WaitSecs(0.001); % delay to prevent CPU hogging
    end
       
 end

 
 
 
 
 
 
 