classdef Student < handle
   
    properties
       firstName
       lastName
       BYUID
       last4
       netID
       email
       assignments
       section
    end
    
    methods
        % Constructor ------------------------------
        function self = Student
            self.assignments = {};
        end
        %--------------------------------------------
        function self = addAssignment(self,name,dueDate)
            self.assignments{end+1} = Assignment(name,dueDate);
        end
        %--------------------------------------------
        function late = computeLateWeight(self)
            
            
            
        end
        %--------------------------------------------
    end
    
end