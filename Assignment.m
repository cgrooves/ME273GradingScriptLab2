classdef Assignment < handle
    
    properties
        name
        dueDate
        occurrences
        file
        
        codeScore
        feedback
    end
    
    methods
        % Constructor -------------------------------
        function self = Assignment(name, dueDate)
            
            self.name = name;
            self.dueDate = dueDate;
            self.occurrences = 0;
            self.feedback = '';
            
        end
        %--------------------------------------------
        function self = addOccurrence(self,newFile)
            
            self.occurrences = self.occurrences + 1;
            self.file = newFile;
        
        end
        %--------------------------------------------
        function totalScore = computeScore(self,section)
            
            totalScore = self.lateWeight(section)*self.codeScore;
            
        end
        %---------------------------------------------
        function displayFeedback = totalFeedback(self)
            
            c = {};
            c{1} = self.name;
            c{2} = ': ';
            c{3} = ' Code Score: ';
            c{4} = num2str(self.codeScore*100);
            c{5} = ' %. ';
            c{6} = ' Feedback: ';
            c{7} = self.feedback;
            
            displayFeedback = strjoin(c);
            
        end
        %----------------------------------------------
        function lateWeight = computeLateWeight(self,sectionNo)
            
            % get difference (in hours) between dueDate and submission time
            adjustedDate = self.dueDate + sectionNo - 1; % adjust for section number
            d = self.file.date - adjustedDate;
            
            if d > duration(96,0,0)
                lateWeight = 0;
            elseif d > duration(72,0,0)
                lateWeight = 0.2;
            elseif d > duration(48,0,0)
                lateWeight = 0.4;
            elseif d > duration(24,0,0)
                lateWeight = 0.6;
            elseif d > duration(0,0,0)
                lateWeight = 0.8;
            else
                lateWeight = 1;
            end
            
        end
        %----------------------------------------------
        
    end
    
end