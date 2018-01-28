function processFiles(studentDatabase,files,masterAssignment,gradingFunction)

    % for each animation file
    for i = 1:length(files)
        file = files(i);
        fileLast4 = parseLastFour(file.name);
        
        % Try and match last 4 in file to student in database
        for j = 1:length(studentDatabase)
            
            if fileLast4 == studentDatabase{j}.last4
                
                % check to see if assignment exists and has already been
                % graded
                gradeFile = true;
                fileFound = false;
                
                % can you find the assignment?
                for k = 1:length(studentDatabase{j}.assignments)
                    
                    % check for filename match
                    if studentDatabase{j}.assignments{k}.name == masterAssignment.name
                        
                        fileFound = true;
                        
                        % is the file's timestamp the same as the
                        % assignments?                        
                        if file.date == studentDatabase{j}.assignments{k}.file.date
                            gradeFile = false;
                            break;
                        else
                            assignment = studentDatabase{j}.assignments{k}; % keep reference to assignment
                        end
                        
                        
                    end  % end filename match                  
                    
                end % end looking through student's assignments
                
                if fileFound == false
                    % add file
                    studentDatabase{j}.addAssignment(masterAssignment.name,masterAssignment.dueDate);
                    assignment = studentDatabase{j}.assignments{end};
                else
                    if gradeFile == false
                        break;
                    end
                end
                
                % increment occurrences and grade file
                assignment.addOccurrence(file);
                
                % grade file
                eval(['[score, fileFeedback] = ',gradingFunction(1:end-2),'(file);']);
                
                % update database
                assignment.pointsEarned = score;
                assignment.feedback = fileFeedback;
                
            end
        end
    end
    
end

