function files = prepareFiles(folderIdentifier)

% Get folder dir and add to path
newPath = dir(strcat('*',folderIdentifier,'*'));
addpath(newPath.name);

% get old files
files = dir(strcat(newPath.name,'/*.m'));

% remove spacing from name and save
for i = 1:length(files)
    oldName = files(i).name;
    newName = strcat(matlab.lang.makeValidName(oldName),'.m');
    
    % before trying to move file, check to see if this
    % has already been done (can't move onto itself)
    if (size(oldName,2) ~= size(newName,2)) || ~any(oldName ~= newName)
        movefile(strcat(newPath.name,'/',oldName),strcat(newPath.name,'/',newName));
    end
    %end
    
end

files = dir(strcat(newPath.name,'/','*.m'));

end