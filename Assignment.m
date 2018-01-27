classdef Assignment < handle
    
    properties
        name
        occurrences
        file
        pointsPossible
        pointsEarned
        feedback
        dueDate
    end
    
    methods
        % Constructor -------------------------------
        function self = Assignment(name, dueDate)
            
            self.name = name;
            self.dueDate = dueDate;
            self.occurrences = 0;
            
        end
        %--------------------------------------------
        function self = addOccurrence(self,newFile)
            
            self.occurrences = self.occurrences + 1;
            self.file = newFile;
        
        end
        %--------------------------------------------
        
    end
    
end