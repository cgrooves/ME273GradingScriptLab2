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
% NOTES: Not robust yet - not able to catch, for example, if students enter
% characters instead of the last 5 of their student ID after the required
% filename.
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
    
    results{i,1} = str2num(animation_files(i).name(21:24)); % parse last 4 of student ID
    
    try % try clause
        filename = animation_files(i).name; % get the filename
        filetext = fileread(filename); % store file in text
        save('gradingvars.mat'); % save grading script data and variables
        %eval(filetext); % run file text as script
        load('gradingvars.mat'); % re-load grading script data and variables 
        close; clc; % close figure and clear command line
        results{i,2} = input('Score? '); % enable user to enter score
    
    catch ERROR % catch clause
    
        close; clc; % close figure
        load('gradingvars.mat'); % re-load grading script data and variables
        results{i,2} = 0; % give score of 0
        results{i,3} = ERROR.message; % store the stack trace in scores
    
    end % end try

end % end for

%% Pythagorean triangle problem

for i = 1:length(pythagorean_files) % for each pythagorean triangle file
    
    last4 = str2num(pythagorean_files(i).name(28:31)); % get last 4 of student ID
    k = 0; % reset index
    
    clear solution; % clear solution variable
    
    for j = 1:size(results,1) % look for match in scores array
        if results{j,1} == last4 
            k = j; % if match found, use row index
            break;
        end
    end
    
    if k == 0  % else add new row
        k = size(results,1)+1;
    end % endif
        
    try % try clause
        filename = pythagorean_files(i).name; 
        filetext = fileread(filename);
        save('gradingvars.mat');
        eval(filetext); % run the current file
        load('gradingvars.mat');
        
        score = 0;
        a = solution(1);
        b = solution(2);
        c = solution(3);
        
        if a^2 + b^2 == c^2 % test <solution>: a^2+b^2=c^2
            score = score + 1;
        end
        
        if a + b + c == 1000 % a + b + c = 1000
            score = score + 1;
        end
        
        if a <= b && b <= c % a < b < c ?
            score = score + 1;
        end
        
        results{k,4} = score; % record score in scores array
        
    catch ERROR % catch
        
        % store the stack trace in scores array
        load('gradingvars.mat'); % re-load grading script data and variables
        results{k,4} = 0; % give score of 0
        results{k,5} = ERROR.message; % store the stack trace in scores
        
    end% end try
        
end % end for

%% Finalize

% for each row in the scores array
    % compute/store final lab 2 score in scores array
% end for
