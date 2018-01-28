%--------------------------------------------------------------
% FILE: Lab2GradingScript.m
% AUTHOR: Caleb Groves
% DATE: 1/16/18
% 
% PURPOSE: To grade assignments and store the grading data for students. 
%
%
% INPUT: Name of the file containing the matlab Student data (roster), the
% filename of the output .csv file to be uploaded to Google/Learning Suite.
%
%
% OUTPUT: 
%
%
% NOTES: 
% 
%--------------------------------------------------------------

function gradeLab2
    
    % setup 
    animation = Assignment('Animation','22-Jan-2018 16:00:00');
    animation.pointsPossible = 10;
    animationFiles = prepareFiles(animation.name);
    
    pythag = Assignment('Pythag','22-Jan-2018 16:00:00');
    pythagFiles = prepareFiles(pythag.name);
    pythag.pointsPossible = 3;
    
    % get roster
    try
        load('students.mat','students');
    catch
        createStudentDatabase('roster.csv','students.mat');
        load('students.mat','students');
    end
    
    % Animation-----------------
    % for each animation file
    for i = 1:length(animationFiles)
        file = animationFiles(i);
        fileLast4 = parseLastFour(file.name);
        
        % Try and match last 4 in file to student in database
        for j = 1:length(students)
            
            if fileLast4 == students{j}.last4
                
                % check to see if assignment exists and has already been
                % graded
                gradeFile = true;
                fileFound = false;
                
                % can you find the assignment?
                for k = 1:length(students{j}.assignments)
                    
                    % check for filename match
                    if students{j}.assignments{k}.name == animation.name
                        
                        fileFound = true;
                        
                        % is the file's timestamp the same as the
                        % assignments?                        
                        if file.date == students{j}.assignments{k}.file.date
                            gradeFile = false;
                            break;
                        else
                            assignment = students{j}.assignments{k}; % keep reference to assignment
                        end
                        
                        
                    end  % end filename match                  
                    
                end % end looking through student's assignments
                
                if fileFound == false
                    % add file
                    students{j}.addAssignment(animation.name,animation.dueDate);
                    assignment = students{j}.assignments{end};
                else
                    if gradeFile == false
                        break;
                    end
                end
                
                % increment occurrences and grade file
                assignment.addOccurrence(file);
                
                % grade file
                try % try clause
                    save('gradingvars.mat'); % save grading script data and variables
                    run(file.name); % run file text as script
                    load('gradingvars.mat'); % re-load grading script data and variables 
                    close; clc; % close figure and clear command line
                    assignment.pointsEarned = input('Score? '); % enable user to enter score

                catch ERROR % catch clause

                    close; clc; % close figure
                    load('gradingvars.mat'); % re-load grading script data and variables
                    assignment.pointsEarned = 0; % give score of 0
                    assignment.feedback = ERROR.message; % store the stack trace in scores

                end % end try
                                
            end
        end
    end
    
    % write out student data
    save('students.mat','students');

end