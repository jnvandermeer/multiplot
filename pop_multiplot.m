% function fh = pop_plot_alleeg_detail(ALLEEG,varargin{:})
%
% it plots in 1 window several different traces - in order u specify.
% requires some pre-work: preload all the datasets into ALLEEG (!)
%
% varargin =
%   xindices = 1:10;
%   begin_time = 170;
%   time_to_plot = 10;
%   my_yscale = 100;
%   selection_of_ALLEEG = [1 2];
%   colorspecs = {'k','g'};
%   linewidths = [1 1];
%   linestyles = {'-','-'};


function [EEGOUT, command] = pop_multiplot(ALLEEG,varargin)


DEFAULT_LINEWIDTH = 1;
DEFAULT_LINESPECS = {'-','--',':','-.','none'};
DEFAULT_LINECOLORS = {'k','b','r','g','m','c','y','w','grey1','grey2','grey3'};
USE_WHAT_ORDER = ['dontuse' num2cell(num2str((1:numel(ALLEEG))'))'];


% later on: do this a bit more smartly! i.e. by reading if an eegplot
% window is already open and copy/pasting the values from that one.

% get defaults from 1 open window:
if numel(varargin)==0
    if numel(findobj(0,'tag','EEGPLOT')) == 1
        
        
        disp('i found 1 open eegplot window -- I am copying those parameters!');
        
        open_eegplot_fig = findobj(0,'tag','EEGPLOT');
        
        edits = get(findobj(open_eegplot_fig,'type','uicontrol','style','edit'),'string');
        EEGOUT = ALLEEG(1);
        open_eegplot_lhs = findobj(open_eegplot_fig,'type','line','tag','');
        
        % this is (normally) just all of the channels (!!!)
        DEFAULT_CHANNELS = num2str(1:ALLEEG(1).nbchan);
        DEFAULT_PLOT_TIME = num2str(round(numel(get(open_eegplot_lhs(1),'Xdata'))/ALLEEG(1).srate));
        
        if numel(edits)==2
            DEFAULT_YSCALE = edits{1};
            DEFAULT_BEGIN_TIME = edits{2};
        else
            DEFAULT_YSCALE = num2str(100);
            DEFAULT_BEGIN_TIME = num2str(0);
        end

            
        
    else
        disp('i found none or >1 eegplot windows - using some defaults!');
        
        DEFAULT_CHANNELS = num2str(1:10);
        DEFAULT_BEGIN_TIME = num2str(0);
        DEFAULT_PLOT_TIME = num2str(10);
        DEFAULT_YSCALE = num2str(100);
        
    end
    
    % OK - i got the info - now protect my original eeglab figures from
    % being 'noui-ed' by the eeglab('noui') function mater on in
    % m_plot_alleeg_detail.m!
    if numel(findobj(0,'tag','EEGPLOT'))>0
        set(findobj(0,'tag','EEGPLOT'),'tag','BACKUP_EEGPLOT');
    end
    
    
    uilist = {};
    geom = {};
    % draw the GUI!!
    % think about it a bit:
    % some information field
    
    % some fields specifying what you would like!
    geom{end+1} = [0.9];
    uilist{end+1} =  {'Style', 'text', 'string', 'Information about all loaded datasets:', 'fontweight', 'bold'};
    
    for i=1:numel(ALLEEG);
        geom{end+1} = [0.9];
        str = '';
        str = [str sprintf('set: %d\t',i)];
        str = [str sprintf('filename: %s',ALLEEG(i).filename)];
        uilist{end+1} = {'Style', 'edit', 'string', str, 'enable', 'off' };
    end
    
    geom{end+1} = [0.9];
    uilist{end+1} = {};
    
    geom{end+1} = [0.9];
    uilist{end+1} =  {'Style', 'text', 'string', 'Specification channels/time/scale', 'fontweight', 'bold'};
    
    geom{end+1} = [0.4 0.4];
    uilist{end+1} = {'Style', 'text', 'string', 'Which Channels?' };
    uilist{end+1} = {'Style', 'edit', 'string', DEFAULT_CHANNELS, 'enable', 'on'};
    
    geom{end+1} = [0.4 0.4];
    uilist{end+1} = {'Style', 'text', 'string', 'What Beginning Time?'};
    uilist{end+1} = {'Style', 'edit', 'string', DEFAULT_BEGIN_TIME, 'enable', 'on'};
    
    geom{end+1} = [0.4 0.4];
    uilist{end+1} = {'Style', 'text', 'string', 'How Much Time To Plot?'};
    uilist{end+1} = {'Style', 'edit', 'string', DEFAULT_PLOT_TIME, 'enable', 'on'};
    
    geom{end+1} = [0.4 0.4];
    uilist{end+1} = {'Style', 'text', 'string', 'What Value For Y-Scale?'};
    uilist{end+1} = {'Style', 'edit', 'string', DEFAULT_YSCALE, 'enable', 'on'};
    
    geom{end+1} = [0.9];
    uilist{end+1} = {};
    
    geom{end+1} = [0.9];
    uilist{end+1} =  {'Style', 'text', 'string', 'Specification of plotting Details:', 'fontweight', 'bold'};
    
    
    geom{end+1} = [0.15 0.15 0.1 0.1 0.1];
    uilist{end+1} =  {'Style', 'text', 'string', 'set'};
    uilist{end+1} =  {'Style', 'text', 'string', 'plotorder'};
    uilist{end+1} =  {'Style', 'text', 'string', 'linecolor'};
    uilist{end+1} =  {'Style', 'text', 'string', 'linewidth'};
    uilist{end+1} =  {'Style', 'text', 'string', 'linestyle'};
    
    
    
    % put down a bit of information:
    for i=1:numel(ALLEEG)
        geom{end+1} = [0.15 0.15 0.1 0.1 0.1];
        
        % identifier: see above!
        uilist{end+1} = { 'Style', 'edit', 'string',  num2str(i), 'enable','off', 'fontweight', 'bold','horizontalalignment','right'};
        % use & what order?
        uilist{end+1} = { 'Style','popup', 'String', USE_WHAT_ORDER,'value',i+1 };
        % color
        uilist{end+1} = { 'Style','popup', 'String', DEFAULT_LINECOLORS,'value',rem(i,numel(DEFAULT_LINECOLORS)) };
        % linewidth
        uilist{end+1} = { 'Style', 'edit', 'string', DEFAULT_LINEWIDTH, 'enable', 'on' };
        % linestyle
        uilist{end+1} = { 'Style','popup', 'String', DEFAULT_LINESPECS,'value',1 };
        
    end
    
    results = inputgui( 'geometry', geom, 'uilist', uilist, 'title', 'Specify Plotting Characteristics' );
    
    
    
    % now - go through each of the given options to determine stuff.
    for i=1:numel(ALLEEG)
        results(1)=[];
    end
    
    % 'snoep alles van de results af!!
    xindices = results{1}; results(1)=[];
    begin_time = results{1}; results(1)=[];
    time_to_plot = results{1}; results(1)=[];
    my_yscale = results{1}; results(1)=[];
    
    % ok - now i need to think about what to make of this, exactly.
    % TYPECASTING!!
    xindices = str2num(xindices);
    begin_time = str2num(begin_time);
    time_to_plot = str2num(time_to_plot);
    my_yscale = str2num(my_yscale);
    
    % do the other stuff.
    selection_of_ALLEEG = cell2mat(results(2:5:end))-1;
    colorspecs = DEFAULT_LINECOLORS(cell2mat(results(3:5:end)));
    linewidths = str2double(results(4:5:end));
    linestyles = DEFAULT_LINESPECS(cell2mat(results(5:5:end)));
    
    
else
    
    xindices = varargin{1};
    begin_time = varargin{2};
    time_to_plot = varargin{3};
    my_yscale = varargin{4};
    selection_of_ALLEEG = varargin{5};
    colorspecs = varargin{6};
    linewidths = varargin{7};
    linestyles = varargin{8};
    
end


% command for my history:
command='';

command = [command sprintf('EEG = pop_multiplot(ALLEEG, ')];
command = [command sprintf(' [ ') ];
for i=1:numel(xindices)
    command = [command sprintf('%d ',xindices(i))];
end
command = [command sprintf(' ], ')];


command = [command sprintf('%g, ',begin_time)];
command = [command sprintf('%g, ',time_to_plot)];
command = [command sprintf('%g, ',my_yscale)];

command = [command sprintf('[ ')];
for i=1:numel(selection_of_ALLEEG)
    command = [command sprintf('%d ',selection_of_ALLEEG(i))];
end
command = [command sprintf('], ')];

command = [command sprintf('{ ')];
for i=1:numel(colorspecs)
    command = [command sprintf('\''%s\'',',colorspecs{i})];
end
command(end)=[];
command = [command sprintf(' }, ')];

command = [command sprintf('[ ')];
for i=1:numel(linewidths)
    command = [command sprintf('%d ',linewidths(i))];
end
command = [command sprintf('], ')];

command = [command sprintf('{ ')];
for i=1:numel(linestyles)
    command = [command sprintf('\''%s\'',',linestyles{i})];
end
command(end)=[];
command = [command sprintf(' } ')];

command = [command sprintf(' ); ') ];



% keyboard;
% ok - plot it! and yeidl return value
fh=m_plot_alleeg_detail(ALLEEG,xindices,begin_time,time_to_plot,my_yscale,selection_of_ALLEEG,colorspecs,linewidths,linestyles);

% restore original tagging again.
set(findobj(0,'tag','BACKUP_EEGPLOT'),'tag','EEGPLOT');


EEGOUT = ALLEEG(1);