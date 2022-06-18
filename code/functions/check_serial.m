function [] = check_serial(s, eventInfo, pulseDuration, N)
% ----------------------------------------------------------------------
% [] = check_serial(s, eventInfo, N)
% ----------------------------------------------------------------------
% Goal of the function :
% Sends a cascading pulse of event codes.
% Used when debugging to test triggers
% ----------------------------------------------------------------------
% Input(s) :
% s - serialport object
% eventInfo - struct containing all named event codes
% N - number of iterations
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : April 2022
% Project : 9_Line_Slots_Task
% Version : 2021a
% ----------------------------------------------------------------------

% Flatted structure to col vector:
A = struct2cell(eventInfo);
C = [];
for i=1:numel(A)  
    if(isstruct(A{i}))
        C = [C; struct2cell(A{i})];
    else
        C = [C; A{i}];
    end
end


codes = [];
for i=1:numel(C)  
    codes = [codes; C{i}(:)];
end

% repeat cycle N times
for ii = 1:N
    for i = 1:numel(codes)
        
        write(s, codes(i), 'uint8');
        WaitSecs(pulseDuration);
        write(s, 0, 'uint8');
        WaitSecs(pulseDuration);
        
        % WaitSecs(.125);
    end
end

% print codes to check 
codes

end

