function uistate = uisuspend(fig, setdefaults)
%UISUSPEND suspends all interactive properties of the figure.
%
%   UISTATE=UISUSPEND(FIG) suspends the interactive properties of a 
%   figure window and returns the previous state in the structure
%   UISTATE.  This structure contains information about the figure's
%   WindowButton* functions and the pointer.  It also contains the 
%   ButtonDownFcn's for all children of the figure.
%
%   UISTATE=UISUSPEND(FIG,FALSE) returns the structure as above but leaves
%   the current settings unchanged.
%   
%   See also UIRESTORE.

%   Copyright 1984-2005 The MathWorks, Inc.
%   $Revision: 1.10.4.5 $ $Date: 2005/11/27 22:45:19 $


    if nargin < 2
        setdefaults = true;
    end
    %Turn off any interactive modes that may be on
    scribeclearmode(fig,'');
    chi = findobj(fig);
    % fig can be an array of handles, not necessarily figures
    if ~isa(handle(fig),'figure')
        sz = length(fig);
        if length(fig) > 1
            fig = fig(1);
        end
        fig = ancestor(fig,'figure');
    end

    uistate = struct(...
            'ploteditEnable',        plotedit(fig,'getenabletools'), ...        
            'figureHandle',          fig, ...
            'Children',              chi, ...
            'WindowButtonMotionFcn', Lwrap(get(fig, 'WindowButtonMotionFcn')), ...
            'WindowButtonDownFcn',   Lwrap(get(fig, 'WindowButtonDownFcn')), ...
            'WindowButtonUpFcn',     Lwrap(get(fig, 'WindowButtonUpFcn')), ...
            'KeyPressFcn',           Lwrap(get(fig, 'KeyPressFcn')), ...
            'Pointer',               get(fig, 'Pointer'), ...
            'PointerShapeCData',     get(fig, 'PointerShapeCData'), ...
            'PointerShapeHotSpot',   get(fig, 'PointerShapeHotSpot'), ...
            'ButtonDownFcns',        Lwrap(get(chi, {'ButtonDownFcn'})), ...
            'Interruptible',         Lwrap(get(chi, {'Interruptible'})), ...
            'BusyAction',            Lwrap(get(chi, {'BusyAction'})), ...
            'UIContextMenu',         Lwrap(get(chi, {'UIContextMenu'})) );

    if setdefaults
        % disable plot editing and annotation buttons
        plotedit(fig,'setenabletools','off'); % ploteditEnable
        % do nothing figureHandle
        % do nothing for Children
        set(fig, 'WindowButtonMotionFcn', get(0, 'DefaultFigureWindowButtonMotionFcn'))
        set(fig, 'WindowButtonDownFcn',   get(0, 'DefaultFigureWindowButtonDownFcn'))
        set(fig, 'WindowButtonUpFcn',     get(0, 'DefaultFigureWindowButtonUpFcn'))
        set(fig, 'KeyPressFcn',           get(0, 'DefaultFigureKeyPressFcn'))
        set(fig, 'Pointer',               get(0, 'DefaultFigurePointer'))
        set(fig, 'PointerShapeCData',     get(0, 'DefaultFigurePointerShapeCData'))
        set(fig, 'PointerShapeHotSpot',   get(0, 'DefaultFigurePointerShapeHotSpot'))
        set(chi, 'ButtonDownFcn',         '')
        set(chi, 'Interruptible',         'on');
        set(chi, 'BusyAction',            'Queue')
        % do nothing for UIContextMenu
    end
end

% wrap cell arrays in another cell array for passing to the struct command
function x = Lwrap(x)
    if iscell(x), 
      x = {x}; 
    end
end
