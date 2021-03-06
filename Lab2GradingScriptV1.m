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
% Next time, check specifically for Nathan Woolley's Pythag grade; it
% seems like it should have worked but the auto-grader didn't like it.
%
%
% VERSION HISTORY
% V1 - initial release
% V2 - 
% V3 - 
% 
%--------------------------------------------------------------
clc; clear; close; % clear environment

results = {};

%% Animation problem

animation_files = prepareFiles('Animation'); % get all the animation files

for i = 1:length(animation_files) % for each animation file
    
    results{i,1} = parseLastFour(animation_files(i).name); % parse last 4 of student ID
    
    try % try clause
        filename = animation_files(i).name; % get the filename
        filetext = fileread(filename); % store file in text
        save('gradingvars.mat'); % save grading script data and variables
        eval(filetext); % run file text as script
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

restoredefaultpath; % restore default path

% Pythagorean triangle problem

pythagorean_files = prepareFiles('Pythag'); % get all of the pythagorean triangle files

for i = 1:length(pythagorean_files) % for each pythagorean triangle file
    
    last4 = parseLastFour(pythagorean_files(i).name); % get last 4 of student ID
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
        results{k,1} = last4;
    end % endif
        
    try % try clause
        filename = pythagorean_files(i).name; 
        filetext = fileread(filename);
        save('gradingvars.mat');
        run(filename); % run the current file
        load('gradingvars.mat');
        
        score = 0;
        
        if exist('solution')
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
        else
            results{k,5} = 'Could not find vector <solution>: see lab instructions';
        end
        
        results{k,4} = score; % record score in scores array
        
    catch ERROR % catch
        
        store the stack trace in scores array
        load('gradingvars.mat'); % re-load grading script data and variables
        results{k,4} = 0; % give score of 0
        results{k,5} = ERROR.message; % store the stack trace in scores
        
    end% end try
        
end % end for

%% Finalize Grading

for i = 1:size(results,1) % for each row in the scores array
    % compute/store final lab 2 score in scores array
    animation_score = results{i,2}/10; 
    pythag_score = results{i,4}/3;
    
    results{i,6} = 0.5*(animation_score + pythag_score); % weighted score
    
end % end for

%% Append scores to roster for Learning Suite Upload

roster = readtable('roster.csv'); % read in the current roster
students = table2cell(roster);

numCols = size(students,2);

% for each row in graded
for i = 1:size(results,1)
    for j = 1:size(students,1) % for each row in roster
        % if the last 4 match
        if results{i,1} == students{j,numCols}
            % append the scores and errors to the roster table
            students(j,numCols+1:(numCols+5)) = results(i,2:end);
        end % end if
    end % end for
end % end for

% export the roster as graded assignment, ready to submit
graded = cell2table(students,'VariableNames',{'LastName','FirstName',...
    'NetID','Email','BYUID','Last4','Animation','Error1','Pythagorean',...
    'Error2','Score'}); % change cell array to table

writetable(graded,'lab2graded.csv')