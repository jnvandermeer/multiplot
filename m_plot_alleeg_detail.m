function fh=m_plot_alleeg_detail(ALLEEG,xindices,begin_time,time_to_plot,my_yscale,selection_of_ALLEEG,colorspecs,linewidths,linestyles)

% which datasets are there?
% dataset_titles = 1

% which colors should they have?
% colorspecs =1
% linewidths =1
% linestyles =1
% selection_of_ALLEEG = [];
    

% this should come from GUI:
% xindices =1
% begin_time =1
% time_to_plot =1
% my_yscale =1

% keyboard;
fs=ALLEEG(1).srate;
yindices = round(1 + (begin_time*fs):((begin_time+time_to_plot)*fs - 1));


%
% no need to calculate RMS - for now:
%
% m_for_RMS=EEG_full.data(xindices,yindices);
% RMS = mean(sqrt(sum((m_for_RMS.^2),2)/size(m_for_RMS,2)));

clear fh

for i=1:numel(selection_of_ALLEEG)
    
    % well - when u select to NOT plot anything - things get a bit more
    % iffy. So I allow of value of 0 in the selection_of_ALLEEG and deal
    % with that over here.
    if ~selection_of_ALLEEG(i)==0
        
        % keyboard;
        m=ALLEEG(selection_of_ALLEEG(i)).data(xindices,yindices);
        color = colorspecs{i};
        linewidth = linewidths(i);
        linestyle = linestyles{i};
        
        if ~exist('fh','var')
            % just plot it - and forget about it!
            % this one should not be closed.
            [fh , ~, lh_parent] = my_eegplot(m,color,linewidth,linestyle);
            
            % get rid of annoying buttondownfcn's we don't need.
            set(fh,'WindowButtonDownFcn','');
            set(fh,'WindowButtonMotionFcn','')
            set(fh,'WindowButtonUpFcn','');
            set(fh,'tag','MY_EEGPLOT');
            
        else
            % use nested function to plot a new eegplot window
            % get all the line handles
            % then change the parent to the lh_parent (so it'll add)
            % then close the new eegplot window.
            % it's a cheap, dirty, trick to cut-paste, instead of copy-paste.
            
            [fh_new lh_new] = my_eegplot(m,color,linewidth,linestyle);
            set(lh_new,'parent',lh_parent);
            close(fh_new);
        end
        
        
    end
end





    % well - it's not perfect - but it should work: fs, time_to_plot and
    % y_scale should remain constant throughout this entire function
    % anyway.
    function [out_fh out_lhs out_lhs_parent] = my_eegplot(m,color,linewidth,linestyle)
        % so this is my NESTED function - it plots an eegplot window that
        % i'll query about LINE HANDLES = i just change the parent of that,
        % and close the figure!
        
        
        % plot window...
        % keyboard;
        eegplot(m,'srate',fs,'winlength',time_to_plot);
        out_fh=gcf;
        
        % find the value thingy... and set my scaling thingy inside of that...
        valobj = findobj(out_fh,'Tag','ESpacing');
        set(valobj,'string',num2str(my_yscale));
        
        % then... draw it again!!
        eegplot('draws',0);
        
        % so... and now, do the channels labels!!! - everbody has the same labels.
        
        allchs = {ALLEEG(1).chanlocs.labels};
        allchs = allchs(xindices);
        newyticklabels = allchs;newyticklabels = [newyticklabels {''}];
        set(gca,'yticklabel',newyticklabels(end:-1:1));
        
        
        % does THIS work??
        newxticklabels = {};
        for i=0:round(time_to_plot)
            newxticklabels{end+1} = round(begin_time + i);
        end        
        set(gca,'xticklabel',newxticklabels);
        
        
        
        % remove ui elements.
        eegplot('noui');
        
        % do the color thingy.
        % keyboard;
        switch color
            case 'k'
                my_color = [0 0 0];
            case 'w'
                my_color = [1 1 1];
            case 'b'
                my_color = [0 0 1];
            case 'g'
                my_color = [0 1 0];
            case 'r'
                my_color = [1 0 0];
            case 'c'
                my_color = [0 1 1];
            case 'm'
                my_color = [1 0 1];
            case 'y'
                my_color = [1 1 0];
            case 'grey1'
                my_color = [0.2 0.2 0.2];
            case 'grey2'
                my_color = [0.4 0.4 0.4];
            case 'grey3'
                my_color = [0.6 0.6 0.6];
        
        end
        
        out_lhs = findobj(out_fh,'type','line','tag','');
        set(out_lhs,'color',my_color,'linewidth',linewidth,'linestyle',linestyle);
        
        out_lhs_parent = get(out_lhs(1),'parent');
        
    end




end