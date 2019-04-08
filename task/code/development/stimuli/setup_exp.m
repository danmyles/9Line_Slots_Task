% Setup exp

% This is still a work in progress. 

% see http://www.martinszinte.net/Martin_Szinte/Teaching_files/Prog_c6.pdf
% for a good example

% Close up everything
% Currently this runs at the beginning of setup_screen

sca;
close all;
clear all;

% Start a stopwatch
tic % you can read time elapsed since tic; with toc

% define the path relative to the location of the setup file:
% where setup_exp is the name of the setup file it will locate the path
dir = (which('setup_exp.m'));

% Set the working directory
cd(dir(1:end-11));

% probably want some info laid out about the subject etc

%% THINGS TO ADD DOWN THE LINE:
% HideCursor; To hide the mouse cursor ? but this is annoying when
% debugging
