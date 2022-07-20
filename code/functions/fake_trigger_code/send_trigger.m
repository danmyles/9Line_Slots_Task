function [] = send_trigger(s, eventCode, pulseDuration)
% ----------------------------------------------------------------------
% [] = send_trigger(s, eventCode)
% ----------------------------------------------------------------------
% Goal of the function :
% For debugging (when MMBT box not connected)
% ----------------------------------------------------------------------
% Input(s) :
% s: []
% eventCode: integer betwen 0 and 255, see eventCode dictionary
% pulseDuration: []
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : July 2022
% Project : 9_Line_Slots_Task
% Version : 2021a
% ----------------------------------------------------------------------

% eventCode
fprintf(['Skipped trigger: ' num2str(eventCode) '\n']);

end