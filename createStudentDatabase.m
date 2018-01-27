% Load database of students: Takes in a file with a roster of students
% (.csv file) and uses the Student class to create a database, saved as a
% .mat file, of the students and their information, to be used in grading
% assignments and keeping track of submissions.

function createStudentDatabase(rosterFile,outputFile)

    % import roster file (.csv)
    rosterTable = readtable(rosterFile);
    rosterCell = table2cell(rosterTable); % convert to cell array
    
    numStudents = size(rosterCell,1);
    
    students = cell(numStudents,1);
    
    % for each row
    for i = 1:numStudents
        % load each student's column into a Student object
        students{i} = Student;
        students{i}.lastName = rosterCell{i,1};
        students{i}.firstName = rosterCell{i,2};
        students{i}.BYUID = rosterCell{i,5};
        students{i}.last4 = rosterCell{i,6};
        students{i}.netID = rosterCell{i,3};
        students{i}.email = rosterCell{i,4};
        students{i}.section = rosterCell{i,9};
        
    end % next row
    
    % save the Student object array
    save(outputFile,'students');

end