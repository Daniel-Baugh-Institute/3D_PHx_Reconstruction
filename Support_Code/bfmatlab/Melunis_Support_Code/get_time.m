%% Justin Melunis, PhD
% Thomas Jefferson University

function time = get_time(Path)
    %This function is designed with a specific folder design. Finds the
    %folder storing the timepoint information, and reports what the time is
    %in hours
    
    %finds the folder
    a = strsplit(Path,'\');
    a = a{end-3};
    
    %converts whatever time is stated on the folder to hours and reports
    %how many hours is within that timepoint
    time = Convert_time(a,'hr');
end

