function [] = send_pulse(s)
% ----------------------------------------------------------------------
% [] = send_trigger(s, eventCode)
% ----------------------------------------------------------------------
% Goal of the function :
% To send 8-bit trigger code to MMBT trigger box
% ----------------------------------------------------------------------
% Input(s) :
% s: serialport object
% eventCode: integer betwen 0 and 255, see eventCode dictionary
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : April 2022
% Project : 9_Line_Slots_Task
% Version : 2021a
% ----------------------------------------------------------------------

write(s, 255, 'uint8');

write(s, 0, 'uint8');

end