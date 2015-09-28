function myGUI
height = 200;
h.f = figure('name','Choose actions','position',[500,500,400,height],'menu','none');

% Checkboxes
h.c(1) = uicontrol('style','checkbox','position',[10,height-30,300,20],'string','Store frames to png images');
h.c(2) = uicontrol('style','checkbox','position',[10,height-2*30,300,20],'string','Create new eye-tracking data');    
h.c(3) = uicontrol('style','checkbox','position',[10,height-3*30,300,20],'string','Show available eye-tracking data');
h.c(4) = uicontrol('style','checkbox','position',[10,height-4*30,300,20],'string','Extract ROIs');
h.c(5) = uicontrol('style','checkbox','position',[10,height-5*30,300,20],'string','Show extracted ROIs');

% OK-button   
h.p = uicontrol('style','pushbutton','position',[40,5,70,20],'string','OK',...
                'callback',@p_call);
            
    function p_call(varargin)
        vals = get(h.c,'Value');
%         assignin('base','vals',vals);
        checked = find([vals{:}]);
        if isempty(checked)
            checked = 'none';
        end
        disp(checked)
    end

end