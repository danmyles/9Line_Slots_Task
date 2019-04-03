%% SCRIPT TO SET UP THE reelInfo DATA STRUCTURE
% This script should be run following the setup_screen script

%% SET UP reelInfo DATA STRUCTURE
reelInfo.reel_ID = cell(3); % Contains Reel ID Row x Reel
reelInfo.sym_position = cell(3); % Contains Screen Position in pixels
reelInfo.sym_shape = cell(3); % Will contain the symbol to display
reelInfo.sym_col = cell(3); % Contains the symbol RGB values
reelInfo.grid_position = cell(3);

%% RANDOMLY ASSIGN SHAPES
% This is a place holder for the actual game script

reel_symbols = ["circ"; "tri"; "rect"; "diam"; "pent"];

for i = 1:9
reelInfo.sym_shape{i} = randsample(reel_symbols,1,true);
end

%% ASSIGN COLOURS
colours.circ = [238/255, 000/255, 001/255];
colours.tri  = [229/255, 211/255, 103/255];
colours.rect = [152/255, 230/255, 138/255];
colours.diam = [000/255, 162/255, 255/255];
colours.pent = [141/255, 038/255, 183/255];

for i = 1:9
    switch(reelInfo.sym_shape{i})
        case "circ"
            reelInfo.sym_col{i} = colours.circ;
        case "tri"
            reelInfo.sym_col{i} = colours.tri;
        case "rect"
            reelInfo.sym_col{i} = colours.rect;
        case "diam"
            reelInfo.sym_col{i} = colours.diam;
        case "pent"
            reelInfo.sym_col{i} = colours.pent;
    end   
end


