function [fileInfo] = setup_file(fileInfo)
% -------------------------------------------------------------------------
% setup_file(fileInfo)
% -------------------------------------------------------------------------
% Goal of the function :
% add remaining directories to MATLAB path
% Specify output location
% -------------------------------------------------------------------------
% Input(s) :
% fileInfo
% -------------------------------------------------------------------------
% Output(s):
% fileInfo - Updated directory information and output path
% -------------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : 24 July 2019
% Project : 9_Line_Slots_Task
% Version : 2019a
% -------------------------------------------------------------------------
[fileInfo.fun] = [fileparts(which("setup_file.m")) filesep]; %functions subfolder
fileInfo.path = fileInfo.fun(1:end-10); % head directory subfolder
fileInfo.config = [fileInfo.path 'config' filesep]; % config subfolder
fileInfo.instructions = [fileInfo.config 'instructions' filesep]; % participant instructions subfolder
fileInfo.input = [fileInfo.config 'inputData' filesep]; % empty participant data structures with outcome information
fileInfo.output = [fileInfo.path(1:end-5) 'output' filesep]; % output subfolder

cd(fileInfo.path); % Change working directory
end

