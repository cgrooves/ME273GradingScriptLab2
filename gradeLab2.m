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

    % get list of files submitted
    animationFiles = prepareFiles('Animation');
    pythagFiles = prepareFiles('Pythag');
    
    % setup 
    animation = Assignment('Animation','22-Jan-2018 16:00:00');
    animation.pointsPossible = 10;
    
    % get roster
    load('students.mat','students')
    
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
                            assignment = students(j).assignments{k}; % keep reference to assignment
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
                
            end
        end
    end
    
    % write out student data
    save('students.mat','students');

end