function [score, fileFeedback] = animationGrader(file)

    try % try clause
        filename = file.name; % get the filename
        save('gradingvars.mat'); % save grading script data and variables
        run(filename); % run file text as script
        load('gradingvars.mat'); % re-load grading script data and variables 
        close; clc; % close figure and clear command line
        score = input('Score? '); % enable user to enter score
        fileFeedback = '';
        score = score/10;
    
    catch ERROR % catch clause
    
        close; clc; % close figure
        load('gradingvars.mat'); % re-load grading script data and variables
        score = 0; % give score of 0
        fileFeedback = ERROR.getReport; % store the stack trace in scores
    
    end % end try

end