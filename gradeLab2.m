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
    
    % Add animation assignment to students
    processFiles(students,animationFiles,animation);
        
    % write out student data
    save('students.mat','students');

end