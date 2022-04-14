function [] = check_serial(s)
% ----------------------------------------------------------------------
% [] = check_serial(s, eventCode)
% ----------------------------------------------------------------------
% Goal of the function :
% Sends a cascading pulse of event codes.
% Used when debugging to test triggers
% ----------------------------------------------------------------------
% Input(s) :
% s: serialport object
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : April 2022
% Project : 9_Line_Slots_Task
% Version : 2021a
% ----------------------------------------------------------------------

pulse = [2.^([0:7, 7:-1:0])];

for i = repmat(pulse, 1, 50)
    write(s, i, 'uint8')
    WaitSecs(0.002)
end

end

