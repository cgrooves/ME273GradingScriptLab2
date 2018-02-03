%--------------------------------------------------------------
% FILE: gradeLab2.m
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
    animation.codeScore = 10;
    animationFiles = prepareFiles(animation.name);
    
    pythag = Assignment('Pythag','22-Jan-2018 16:00:00');
    pythagFiles = prepareFiles(pythag.name);
    pythag.codeScore = 3;
    
    % get roster
    try
        load('students.mat','students');
    catch
        createStudentDatabase('roster.csv','students.mat');
        load('students.mat','students');
    end
    
    % Add animation assignment to students
    processFiles(students,animationFiles,animation,'animationGrader.m');
    processFiles(students,pythagFiles,pythag,'pythagGrader.m');
        
    % write out student data
    save('students.mat','students');
    
    % get self-evaluation and peer-observation score and feedback
    submissionTable = readtable('TabDelimit.csv','Delimiter','\t');
    submissionCell = table2cell(submissionTable);
    
    % go through each row - i represents submissionCell index
    output = {};
    
    for i = 1:size(submissionCell,1)
       
       % look for a matching student id - j represents student index
       for j = 1:size(students,1)
           
           % Match found
           if students{j}.last4 == str2num(submissionCell{i,3})
               
               % Get score for self-eval and peer-obs
               selfEvalScore = str2num(submissionCell{i,6})/5;
               peerObsScore = str2num(submissionCell{i,5})/5;
               peerObsFeedback = submissionCell{i,11};
               
               section = students{j}.section;
               
               codeScore = 0;
               
               d = {};
               for k = 1:size(students{j}.assignments,2)
                   
                codeScore = codeScore + (students{j}.assignments{k}.codeScore)*.5;
                d{k} = students{j}.assignments{k}.totalFeedback();
               
               end
                
               % Compute total score
               totalScore = (codeScore*.75 + 0.125*(selfEvalScore + peerObsScore));
               
               % Total up the assignment feedback
               c = {};
               c{1} = ' Lab 2 Feedback: ';
               c{2} = strjoin(d);               
               c{3} = ' Self Evaulation: ';
               c{4} = num2str(selfEvalScore*100);
               c{5} = ' %. ';
               c{6} = ' Peer Observation Score: ';
               c{7} = num2str(peerObsScore*100);
               c{8} = ' %. Feedback: ';
               c{9} = peerObsFeedback;
               
               allFeedback = strjoin(c);
               
               % Add all info to output cell
               output{i,1} = students{j}.lastName; % Last name
               output{i,2} = students{j}.firstName; % First name
               output{i,3} = students{j}.email; % email
               output{i,4} = students{j}.BYUID; % BYU ID
               output{i,5} = totalScore*100; % Lab score
               output{i,6} = allFeedback; % Total feedback
           end
       end
    end
    
    % Convert output cell to table
    tableOutput = cell2table(output,'VariableNames',{'LastName','FirstName',...
        'Email','BYUID','Lab2Score','Feedback'});
    % Add headers to table
    % Export table as .csv
    writetable(tableOutput,'lab2grades.csv');     
    

end