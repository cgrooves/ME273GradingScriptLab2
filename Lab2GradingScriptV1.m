%--------------------------------------------------------------
% FILE: Lab2GradingScript.m
% AUTHOR: Caleb Groves
% DATE: 1/16/18
% 
% PURPOSE: Enable the semi-automatic grading of students' ME 273 Lab 2 
% assignment submissions.
%
%
% INPUT: Execute script in the same file location as two folders containing
% "Animation_plotting_XXXXX.m" and "Pythagorean_triad_problem_XXXXX.m" in
% their title.
%
%
% OUTPUT: Cell array called "scores" that has the following columns:
% 1. Last four digits of student ID
% 2. Animation score
% 3. Error message for animation
% 4. Pythagorean triangle score
% 5. Error message for pythagorean triangle script
% 6. Total weighted score for Lab 2
%
%
% NOTES: 
%
%
% VERSION HISTORY
% V1 - initial release
% V2 - 
% V3 - 
% 
%--------------------------------------------------------------
clc; clear; close; % clear environment

% add file folders to path
animation_path = dir('*_Animation_plotting_*');
addpath(animation_path.name)
pythagorean_path = dir('*_Pythagorean_triad_problem_*');
addpath(pythagorean_path.name)

animation_files = dir('**/Animation_plotting_*.m'); % get all the animation files
pythagorean_files = dir('**/Pythagorean_triad_problem_*.m'); % get all of the pythagorean triangle files

%% Animation problem

for i = 1:length(animation_files) % for each animation file
    
    results{i,1} = animation_files(i).name(21:24); % get last 4 of student ID
    
    try % try clause
        filename = animation_files(i).name; % get the filename
        filetext = fileread(filename); % store file in text
        save('gradingvars.mat'); % save grading script data and variables
        eval(filetext); % run file text as script
        load('gradingvars.mat'); % re-load grading script data and variables
        % pause; 
        % enable user to enter score
        % store score in scores array
    catch % catch clause
        % store the stack trace in scores
    end % end try
end % end for

%% Pythagorean triangle problem

% for each pythagorean triangle file
    % get last 4 of student ID
    % look for match in scores array
        % if match found, use row index
            % else add new row
        % endif
    % try clause
        % run the current file
        % test <solution>: a^2+b^2=c^2
        % a + b + c = 1000
        % a < b < c ?
        % record score in scores array
    % catch
        % store the stack trace in scores array
    % end try
% end for
% for each

%% Finalize

% for each row in the scores array
    % compute/store final lab 2 score in scores array
% end for
