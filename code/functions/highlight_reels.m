function [] = highlight_reels(screenInfo, reelInfo)
    % [] = highlight_reels(screenInfo, reelInfo)
    % intersect() finds the locations in which the values of the two
    % vectors are the same.
    % C contains the identities of the matched elements, in our case the
    % symbol or shape code.
    % IA contains indices for argument A where these matches occur.
    % IB does the same for argument B.
    % 'stable' returns the indices in IA and IB in the order that they
    % occur in argument A
    
    [C, IA, IB] = intersect(reelInfo.outcome.dspSymbols(1:3, 1), reelInfo.outcome.dspSymbols(1:3, 3), 'stable');
    
    % We need to add 6 to IB so that we can use it to index gridPos
    IB = IB + 6;
    
    Screen('FrameRect', screenInfo.window, reelInfo.colours(C, :)', screenInfo.gridPos(IA, :)', screenInfo.gridPenWidthPixel.*3);
    Screen('FrameRect', screenInfo.window, reelInfo.colours(C, :)', screenInfo.gridPos(IB, :)', screenInfo.gridPenWidthPixel.*3);
    
    x = [screenInfo.gridPos([IA, IB], 1:2) + (3.*screenInfo.gridPenWidthPixel), screenInfo.gridPos([IA, IB], 3:4) - (3.*screenInfo.gridPenWidthPixel)];
    
    Screen('FrameRect', screenInfo.window, screenInfo.black, x', screenInfo.gridPenWidthPixel);
    
    %% This section only applies when using reelstrips that include repeats
    % The code above will only find the first two matching symbols in reel 1 & 2
    % The code below will find additional matches and also draw them to
    % screen. This second operation is not neccesary when using
    % repeatSymbols = 0
    
    if reelInfo.repeatSymbols ~= 0
        
        if length(unique(A)) < 3
            
            % Find unique values
            [~, ind] = unique(A, 'rows');
            
            % Find indices for duplicates
            duplicate_IA = setdiff(1:size(A, 1), ind);
            
            % Find duplicate values
            duplicate_A = A(duplicate_IA, 1);
            
            if ~isempty(find(ismember(duplicate_A, C), 1))
                
                % Print highlight to screen
                Screen('FrameRect', screenInfo.window, reelInfo.colours(duplicate_A, :)', screenInfo.gridPos(duplicate_IA, :)', screenInfo.gridPenWidthPixel.*3);
                x = [screenInfo.gridPos(duplicate_IA, 1:2) + (3.*screenInfo.gridPenWidthPixel), screenInfo.gridPos(duplicate_IA, 3:4) - (3.*screenInfo.gridPenWidthPixel)];
                Screen('FrameRect', screenInfo.window, screenInfo.black, x', screenInfo.gridPenWidthPixel);
                
            end
            
        end
        
        if length(unique(B)) < 3
            
            % Find unique values
            [~, ind] = unique(B, 'rows');
            
            % Find duplicate indices
            duplicate_IB = setdiff(1:size(B, 1), ind);
            
            % Find indices for duplicates
            duplicate_B = B(duplicate_IB, 1);
            
            if ~isempty(find(ismember(duplicate_B, C), 1))
                % Print highlight to screen
                duplicate_IB = duplicate_IB + 6;
                Screen('FrameRect', screenInfo.window, reelInfo.colours(duplicate_B, :)', screenInfo.gridPos(duplicate_IB, :)', screenInfo.gridPenWidthPixel.*3);
                x = [screenInfo.gridPos(duplicate_IB, 1:2) + (3.*screenInfo.gridPenWidthPixel), screenInfo.gridPos(duplicate_IB, 3:4) - (3.*screenInfo.gridPenWidthPixel)];
                Screen('FrameRect', screenInfo.window, screenInfo.black, x', screenInfo.gridPenWidthPixel);
            end
            
        end
        
    end
    
    % Re-draw shapes and grid 
    draw_grid(screenInfo);
    draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));
    
end

