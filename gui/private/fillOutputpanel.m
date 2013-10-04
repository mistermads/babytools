function fillOutputpanel(hObject, handles)
% FILLOUTPUTPANEL
%
% fills the outputpanel table with the data (as specified by ...)
% and sets up the file summary

% ADD choice between frames/ms?
%% fill 'niceData' Table with Unit data
% DataColumnNames
var_names = {'Startframe','Endframe','Starttime_ms','Endtime_ms','Event',...
    'Avg_Velocity','Nr_Peaks','Average_Peak','Nr_Dips','Average_Dip'};
% Unit Start/End points
starttimes = frames2msec(handles.startframes, handles.Framerate, handles.precision);
endtimes = frames2msec(handles.endframes, handles.Framerate, handles.precision);
% Unit or Pause
eventstates = handles.seq_qs(1:end,2);
% convert to cell array
eventcell = cell(size(eventstates));
 eventcell(eventstates == 1) = {'Pause'};
 eventcell(eventstates == 2) = {'Unit'};
 eventcell(isnan(eventstates)) = {'Missing'};

 % putting the data together
tabledata = [num2cell(handles.startframes),num2cell(handles.endframes),....
    num2cell(starttimes),num2cell(endtimes),eventcell,...
    num2cell(handles.avgVelo_perUnit),...
    num2cell(handles.nrPeaks),num2cell(handles.avgPeak),...
    num2cell(handles.nrDips),num2cell(handles.avgDip)];
set(handles.uitableresults,'Data',tabledata);
set(handles.uitableresults,'ColumnName',var_names);

% add to handles NOTE: necessary???
handles.tabledata = tabledata;
handles.var_names = var_names;
handles.starttimes = starttimes;
handles.endtimes = endtimes;
handles.eventstates = eventstates;

%% fill 'framedata' table with data of each single frame
var_names_frame = {'Frame', 'Event', 'Velocity','Extrema'};
% expand the seq unit-wise data to frame-wise data (the nan's at the end
% are discarded!)
seq_frame = baby_seq_expand(handles.seq_qs);  
eventcellframe = cell(length(seq_frame),1);
 eventcellframe(seq_frame(:,2) == 1) = {'Pause'};
 eventcellframe(seq_frame(:,2) == 2) = {'Unit'};
 eventcellframe(isnan(seq_frame(:,2))) = {'Missing'};
peaksndipscell = cell(length(seq_frame),1);
peaksndipscell(handles.peakIdxs) = {'Peak'};
peaksndipscell(handles.dipIdxs) = {'Dip'};

% compute percentage of missing, unit and pause data
perc_missing = sum(isnan(handles.frame_velo))/handles.Frames; % use frame_velo, since it has still all nan's
perc_pause = sum((seq_frame(:,2) == 1))/handles.Frames;
perc_unit = sum((seq_frame(:,2) == 2))/handles.Frames;

% shorten frame_velo to fit with expanded seq (which is shorter because of
% the discarded nan's)
handles.frame_velo = handles.frame_velo(1:length(seq_frame),1);
tabledata_frame = [num2cell(seq_frame(:,1)) eventcellframe num2cell(handles.frame_velo) peaksndipscell];
set(handles.uitableresultsframe,'Data',tabledata_frame);
set(handles.uitableresultsframe,'ColumnName',var_names_frame);

handles.tabledata_frame = tabledata_frame;
handles.var_names_frame = var_names_frame;

% ADD change to 'dataset' have input for 'event' (3rd column) as text
handles.exportdata = dataset({handles.tabledata,...
    handles.var_names{:}});
handles.exportdata_frame = dataset({handles.tabledata_frame,...
    handles.var_names_frame{:}});

%% fill 'rawdata' table with unprocessed data
set(handles.uitableresultsraw,'Data',handles.seq_qs);

%% fill 'Statistics' table with summary statistics


col_names_statistics = {'Units','Pauses','All'};
numClasses = 3; % Units/Pause/All

% Table with general statistics
row_names_statistics = {'Nr_Blocks','Percentage'};
numStats = length(row_names_statistics);
NrBlocks = [handles.trueNrUnits handles.totalNrUnits-handles.trueNrUnits-2 handles.totalNrUnits];
%statistics = nan(numClasses,numStats);
statistics = [NrBlocks; perc_unit perc_pause 1];
% display on outputpanel
set(handles.uitablestatistics,'Data',statistics);   
set(handles.uitablestatistics,'ColumnName',col_names_statistics);
set(handles.uitablestatistics,'RowName',row_names_statistics);

% Table with Averages over Blocks
row_names_statistics_blocks = {'Nr_Peaks','Avg_Peak','Nr_Dips','Avg_dip','Avg_Velocity'};
numStats = length(row_names_statistics_blocks);           
statistics_blocks = nan(numStats,numClasses);
NrBlocks = [handles.trueNrUnits handles.totalNrUnits-handles.trueNrUnits-2 handles.totalNrUnits];
len = length(handles.seq_qs);
Idx1 = find(handles.seq_qs(:,2)==2);
Idx2 = find(handles.seq_qs(:,2)==1);
Idx3 = (1:len)';
Idxs = [[Idx1; ones(len-length(Idx1),1)] [Idx2 ; ones(len-length(Idx2),1)] Idx3];
for kk=1:numClasses
    statistics_blocks(1,kk) = sum(handles.nrPeaks(Idxs(:,kk)))/NrBlocks(kk);
    statistics_blocks(2,kk) = nansum(handles.avgPeak(Idxs(:,kk)))/NrBlocks(kk);
    statistics_blocks(3,kk) = sum(handles.nrDips(Idxs(:,kk)))/NrBlocks(kk);
    statistics_blocks(4,kk) = nansum(handles.avgDip(Idxs(:,kk)))/NrBlocks(kk);
    statistics_blocks(5,kk) = nansum(handles.avgVelo_perUnit(Idxs(:,kk)))/NrBlocks(kk);
end

% display on outputpanel
set(handles.uitablestatistics_block,'Data',statistics_blocks);   
set(handles.uitablestatistics_block,'ColumnName',col_names_statistics);
set(handles.uitablestatistics_block,'RowName',row_names_statistics_blocks);
      
handles.exportdata_statistics = dataset({[statistics; statistics_blocks],col_names_statistics{:}},...
     'ObsNames',{row_names_statistics{:} row_names_statistics_blocks{:}});

%% show file summary
%format = '%6.4f';
% make cell arrays for properties and their respective names and units
filesum_propertynames = {'Pathname', 'Filename','Original Path and Filename' ...
    'Framerate', 'Frames','', 'MarkerLabel', 'Smoothingpoints',...
    'Minimum Velocity', 'Minimum Pause', 'Minimum Peaks', 'Minimum Unit Length', 'WAND correction'}; %,...
%     '','Nr of Units','Missing','Pause','Unit','Average Nr of Peaks','Average (of Average) Peak',...
%     'Average Nr of Dips','Average (of Average) Dip','Average (of Average) Velocity'};
filesum_properties = {handles.PathName, handles.FileName, handles.rawdata.File, ...
    handles.Framerate, handles.Frames,'', handles.MarkerLabel,...
    handles.smoothpnts,handles.minVelo,...
    handles.minPause, handles.minPeaks, handles.minFrames,...
    handles.WANDfactor}; %,'',handles.trueNrUnits,...
%     perc_missing, perc_pause, perc_unit, handles.avgNrPeaks,handles.avgAvgPeak,...
%     handles.avgNrDips,handles.avgAvgDip,handles.avgAvgVelo_perUnit};
% convert to string and concatenate with unit strings for display in GUI
filesum_properties_gui = cell(1,length(filesum_properties));
for kk=1:length(filesum_properties)
    if isnumeric(filesum_properties{kk})
    filesum_properties_gui{kk} = num2str(filesum_properties{kk});
    else
        filesum_properties_gui(kk) = filesum_properties(kk);
    end
end
filesum_propertyunits = {'','','',' fps',' Frame(s)','', '',' Frame(s)',...
    ' mm/s',' Frame(s)',' per Unit',' Frame(s)',''}; %,'','',' %',' %',' %',' per Unit',' mm/s',' per Unit',' mm/s',' mm/s'};
% concatenate 'properties' and 'units' strings
filesum_propertieswithunits = strcat(filesum_properties_gui,filesum_propertyunits);

% display on outputpanel
set(handles.textfilesummarypropertynames,'String',filesum_propertynames([2 4:end]));    % (2 4:end) to leave out pathname and original path
set(handles.textfilesummaryproperties,'String',filesum_propertieswithunits([2 4:end]));          % dto.

% save for exportfile
handles.filesummary = [filesum_propertynames; filesum_properties; filesum_propertyunits]';



% Update handles structure
guidata(hObject, handles);