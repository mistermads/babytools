function fillOutputpanel(hObject, handles)
% FILLOUTPUTPANEL
%
% fills the outputpanel table with the data (as specified by ...)
% and sets up the file summary

% ADD choice between frames/ms?
%% fill 'niceData' Table with Unit data
% DataColumnNames
var_names = {'Startframe','Endframe','Starttime_ms','Endtime_ms','Event'};
% Unit Start/End points
starttimes = frames2msec(handles.startframes, handles.Framerate, handles.precision);
endtimes = frames2msec(handles.endframes, handles.Framerate, handles.precision);
% Unit or Pause
eventstates = handles.seq_qs(1:end-1,2);
% convert to cell array
eventcell = cell(size(eventstates));
 eventcell(eventstates == 1) = {'Pause'};
 eventcell(eventstates == 2) = {'Unit'};
 eventcell(isnan(eventstates)) = {'Missing'};

 % putting the data together
tabledata = [num2cell(handles.startframes),num2cell(handles.endframes),....
    num2cell(starttimes),num2cell(endtimes),eventcell];
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
seq_frame = baby_seq_expand(handles.seq_qs);
eventcellframe = cell(length(seq_frame),1);
 eventcellframe(seq_frame(:,2) == 1) = {'Pause'};
 eventcellframe(seq_frame(:,2) == 2) = {'Unit'};
 eventcellframe(isnan(seq_frame(:,2))) = {'Missing'};
peaksndipscell = cell(length(seq_frame),1);
peaksndipscell(handles.peakIdxs) = {'Peak'};
peaksndipscell(handles.dipIdxs) = {'Dip'};
% compute percentage of missing, unit and pause data
perc_missing = sum(isnan(seq_frame(:,2)))/handles.Frames;
perc_pause = sum((seq_frame(:,2) == 1))/handles.Frames;
perc_unit = sum((seq_frame(:,2) == 2))/handles.Frames;
tabledata_frame = [num2cell(seq_frame(:,1)) eventcellframe num2cell(handles.frame_velo) peaksndipscell];
set(handles.uitableresultsframe,'Data',tabledata_frame);
set(handles.uitableresultsframe,'ColumnName',var_names_frame);

handles.tabledata_frame = tabledata_frame;
handles.var_names_frame = var_names_frame;

%% fill 'rawdata' table with unprocessed data
set(handles.uitableresultsraw,'Data',handles.seq_qs);

%% show file summary
% make cell arrays for properties and their respective names and units
filesum_propertynames = {'Pathname', 'Filename','Original Path and Filename' ...
    'Framerate', 'Frames','', 'MarkerLabel', 'Smoothingpoints',...
    'Minimum Velocity', 'Minimum Pause', 'Minimum Peaks', 'Minimum Unit Length', 'WAND correction',...
    '','Nr of Units','Missing','Pause','Unit','Average Nr of Peaks','Average Peak',...
    'Average Nr of Dips','Average Dip'};
filesum_properties = {handles.PathName, handles.FileName, handles.rawdata.File, ...
    num2str(handles.Framerate), num2str(handles.Frames),'', handles.MarkerLabel,...
    num2str(handles.smoothpnts),num2str(handles.minVelo),...
    num2str(handles.minPause), num2str(handles.minPeaks), num2str(handles.minFrames),...
    num2str(handles.WANDfactor),'',num2str(handles.trueNrUnits),...
    num2str(perc_missing), num2str(perc_pause), num2str(perc_unit), num2str(handles.avgNrPeaks),num2str(handles.avgAvgPeak),...
    num2str(handles.avgNrDips),num2str(handles.avgAvgDip)};
filesum_propertyunits = {'','','',' fps',' Frame(s)','', '',' Frame(s)',...
    ' mm/s',' Frame(s)',' per Unit',' Frame(s)','','','',' %',' %',' %',' per Unit',' mm/s',' per Unit',' mm/s'};
% concatenate 'properties' and 'units' strings
filesum_propertieswithunits = strcat(filesum_properties,filesum_propertyunits);

% display on outputpanel
set(handles.textfilesummarypropertynames,'String',filesum_propertynames([2 4:end]));    % (2 4:end) to leave out pathname and original path
set(handles.textfilesummaryproperties,'String',filesum_propertieswithunits([2 4:end]));          % dto.

% save for exportfile
handles.filesummary = [filesum_propertynames; filesum_properties; filesum_propertyunits]';

% Update handles structure
guidata(hObject, handles);