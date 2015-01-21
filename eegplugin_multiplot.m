function vers = eegplugin_multiplot( fig, try_strings, catch_strings)

vers = 'MultiPlot 0.01';


toolsmenu = findobj(fig, 'tag', 'tools');


commando1 = [ try_strings.no_check '[EEG LASTCOM] = pop_multiplot( ALLEEG );' catch_strings.add_to_hist ];
submenu_multiplot=uimenu(toolsmenu,'label','multiplot','tag','multiplot','callback',commando1);




