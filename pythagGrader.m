function [score, fileFeedback] = pythagGrader(file)

    try % try clause
        clear solution;
        
        score = 0;
        fileFeedback = '';
        
        filename = file.name; % get the filename
        save('gradingvars.mat'); % save grading script data and variables
        run(filename); % run file text as script
        load('gradingvars.mat'); % re-load grading script data and variables 
        close; clc; % close figure and clear command line
        
        % scoring algorithm
        
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
            fileFeedback = 'Could not find vector <solution>: see lab instructions';
        end
        
        score = score / 3;
                    
    catch ERROR % catch clause
    
        close; clc; % close figure
        load('gradingvars.mat'); % re-load grading script data and variables
        score = 0; % give score of 0
        fileFeedback = ERROR.getReport; % store the stack trace in scores
    
    end % end try

end