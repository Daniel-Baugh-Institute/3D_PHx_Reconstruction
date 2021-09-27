function Collect_Gui(v,Path_List,In_Path)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    if v == 1
        Collect_Gui_Bile(Path_List,In_Path)
        Collect_Gui_Sinu(Path_List,In_Path)
        Collect_Gui_Cell(Path_List,In_Path)
        Collect_Gui_Volume(Path_List,In_Path)
    elseif v == 2
        Collect_Gui_Sinu(Path_List,In_Path)
    elseif v == 3
        Collect_Gui_Bile(Path_List,In_Path)
    elseif v == 4
        Collect_Gui_Cell(Path_List,In_Path)
    elseif v == 5
        Collect_Gui_Volume(Path_List,In_Path)
    else
    end
end

