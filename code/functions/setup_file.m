function [fileInfo] = setup_file(fileInfo)
% ----------------------------------------------------------------------
% setup_file()
% ----------------------------------------------------------------------
% Goal of the function :
% add remaining directories to MATLAB path
% Specify output location
% ----------------------------------------------------------------------
% Input(s) :
% fileInfo
% ----------------------------------------------------------------------
% Output(s):
% fileInfo - Updated directory information and output path
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : 24 July 2019
% Project : 9_Line_Slots_Task
% Version : 2019a
% ----------------------------------------------------------------------
    
addpath([fileInfo.Path filesep 'config' filesep]);
fileInfo.outputPath = [fileInfo.Path(1:end-4) 'output' filesep];
end

