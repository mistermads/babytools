function varargout = prototype1(varargin)
% PROTOTYPE1 M-file for prototype1.fig
%      PROTOTYPE1, by itself, creates a new PROTOTYPE1 or raises the existing
%      singleton*.
%
%      H = PROTOTYPE1 returns the handle to a new PROTOTYPE1 or the handle to
%      the existing singleton*.
%
%      PROTOTYPE1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROTOTYPE1.M with the given input arguments.
%
%      PROTOTYPE1('Property','Value',...) creates a new PROTOTYPE1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before prototype1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to prototype1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help prototype1

% Last Modified by GUIDE v2.5 26-Aug-2013 14:31:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @prototype1_OpeningFcn, ...
                   'gui_OutputFcn',  @prototype1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before prototype1 is made visible.
function prototype1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to prototype1 (see VARARGIN)

% Choose default command line output for prototype1
handles.output = hObject;

% General properties
    handles.precision = 2;      % number of decimal places in frame2msec conversion 
    handles.WANDfactor = 1;     % default value for WAND correction factor 

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes prototype1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = prototype1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbuttoncomp.
function pushbuttoncomp_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttoncomp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%  % disable pushbuttoncompute
%   set(handles.pushbuttoncomp,'Enable','off');

% compute speed/velocity
speed = aux_velocity(handles.rawdata,handles.Framerate,...
    handles.MarkerIndex,handles.smoothpnts);
% WAND correction factor for miscalibrated data
speed = speed/handles.WANDfactor;
handles.speed = speed;
raw_qualisys = baby_qualisys_speed(speed);
handles.raw_qualisys = raw_qualisys;
% save velocity per frame
handles.frame_velo = raw_qualisys.A;


% get settings of criteria
minvelocity = handles.minVelo;   
minpauseframes = handles.minPause;
minpeaksinunit = handles.minPeaks;
minunitframes = handles.minFrames;


 % sequencing % states: 1:false, 2:true
 [seq_qs,qs_statenames,handles.peakIdxs, handles.dipIdxs] =...
    baby_velocitypeaks(raw_qualisys,minvelocity,minpauseframes,minpeaksinunit,minunitframes);
 % TO DO check this one! 
 [seq_qs,qs_statenames] = baby_seq_statenames_order(seq_qs,qs_statenames,{'','x'},{'^\s*$'},{'[xX]'});
handles.seq_qs = seq_qs;
handles.qs_statenames = qs_statenames;
handles.totalNrUnits = length(seq_qs);
handles.trueUnitsIdxs = find(seq_qs(:,2)==2);
handles.trueNrUnits = length(handles.trueUnitsIdxs);

% compute start- and end frames
handles.startframes = handles.seq_qs(1:end,1);
handles.endframes = [handles.seq_qs(2:end,1)-1; handles.Frames];

% compute additional unit statistics
% Nr of Peaks and average height of peaks per unit
[nrPeaks,avgPeak] = findPointsPerUnit(handles.startframes(handles.trueUnitsIdxs),...
    handles.endframes(handles.trueUnitsIdxs),handles.peakIdxs,raw_qualisys.A);
% Nr of Dips and average height of dips per unit
[nrDips,avgDip] = findPointsPerUnit(handles.startframes(handles.trueUnitsIdxs),...
    handles.endframes(handles.trueUnitsIdxs),handles.dipIdxs,raw_qualisys.A);

handles.nrPeaks = nrPeaks;
handles.avgPeak = avgPeak;
handles.nrDips = nrDips;
handles.avgDip = avgDip;
handles.avgNrPeaks = sum(nrPeaks)/handles.trueNrUnits;
handles.avgAvgPeak = sum(avgPeak)/handles.trueNrUnits;
handles.avgNrDips = sum(nrDips)/handles.trueNrUnits;
handles.avgAvgDip = sum(avgDip)/handles.trueNrUnits;

% Update handles structure
guidata(hObject, handles);

% send data to OutputPanel
fillOutputpanel(hObject, handles);
%set(handles.uitableresults,'Data',seq_qs);
handles = guidata(hObject);

% % reenable pushbutton
% set(handles.pushbuttoncomp,'Enable','on');

% Update handles structure
guidata(hObject, handles);



% --- Executes on selection change in popupmenumarker.
function popupmenumarker_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenumarker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenumarker contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenumarker
contents = cellstr(get(hObject,'String'));
handles.MarkerLabel = contents{get(hObject,'Value')};
handles.MarkerIndex = strmatch(handles.MarkerLabel,handles.MarkerLabels);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenumarker_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenumarker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.MarkerIndex = 1;
% pass on data to GUI
guidata(hObject,handles);

% --- Executes on button press in pushbuttonload.
function pushbuttonload_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% open dialog box for file retrieval
[FileName,PathName,FilterIndex] = uigetfile('*.mat','Choose a File','../data');

if FileName ~= 0 % check if a file is selected
    
    % load selected file
    [FileName_short, FileEnding] = strtok(FileName,'.');  % split into name and file ending
    if strcmp(FileEnding,'.mat')~=1
        warndlg('Please choose a .mat File!', 'Wrong File Type');
    else
        rawdata = load([PathName FileName]);
        if ~isfield(rawdata, FileName_short)
            warndlg('File needs to be a consistent struct!', 'Wrong File Format');
        else
            eval(['rawdata = rawdata.' FileName_short]);
            
            % check for valid file with a consistent struct
            % --> a dozen of isfields...
            
            if ~isfield(rawdata, {'File','Frames','FrameRate','Trajectories'})
                warndlg('File needs to be a consistent struct!', 'Wrong File Format');
            else
                
                if ~isfield(rawdata.Trajectories, {'Labeled','Unidentified','Discarded'})
                    warndlg('File needs to be a consistent struct!', 'Wrong File Format');
                else
                    
                    if ~isfield(rawdata.Trajectories.Labeled, {'Count','Labels','Data'})
                        warndlg('File needs to be a consistent struct!', 'Wrong File Format');
                    else
                        
                        if ~isfield(rawdata.Trajectories.Unidentified, 'Count')
                            warndlg('File needs to be a consistent struct!', 'Wrong File Format');
                        else
                            
                            if ~isfield(rawdata.Trajectories.Discarded, 'Count')
                                warndlg('File needs to be a consistent struct!', 'Wrong File Format');
                            else
                                
                                % save info in handles struct
                                handles.rawdata = rawdata;
                                handles.PathName = PathName;
                                handles.FileName = FileName;
                                handles.FileName_short = FileName_short;
                                handles.Framerate = rawdata.FrameRate;
                                handles.Frames = rawdata.Frames;
                                % Checking for Unlabeled/Discarded markers
                                handles.Unidentified = rawdata.Trajectories.Unidentified.Count;
                                handles.Discarded = rawdata.Trajectories.Discarded.Count;
                                if (handles.Unidentified~=0 || handles.Discarded~=0)
                                    warningstring = ['Data contains ' num2str(handles.Unidentified)...
                                        ' unidentified and ' num2str(handles.Discarded) ' discarded markers!'];
                                    % warndlg(warningstring);       % No warning, just a textoutput
                                    set(handles.textdisc_unident_markers,'String',warningstring);
                                else
                                    set(handles.textdisc_unident_markers,'String','');
                                end
                                handles.NrOfMarkers = rawdata.Trajectories.Labeled.Count;
                                handles.MarkerLabels = rawdata.Trajectories.Labeled.Labels;
                                
                                
                                % show selected file, framerate and number of frames in textfields
                                set(handles.textfname,'String',handles.FileName_short);
                                set(handles.textfilefs,'String',[num2str(handles.Framerate) ' fps']);
                                set(handles.textfileframes,'String',handles.Frames);
                                handles.minPausemsec = frames2msec(handles.minPause, handles.Framerate, handles.precision);
                                set(handles.textMinPausemseconds,'String',[num2str(handles.minPausemsec) ' ms']);
                                handles.minFramesmsec = frames2msec(handles.minFrames, handles.Framerate, handles.precision);
                                set(handles.textMinFramesmseconds,'String',[num2str(handles.minFramesmsec) ' ms']);
                                
                                
                                % set up and enable popupmenumarker
                                set(handles.popupmenumarker,'Enable','on');
                                set(handles.popupmenumarker,'String',handles.MarkerLabels);
                                % for first loaded file, set to first element
                                if ~isfield(handles, 'MarkerLabel')
                                    handles.MarkerLabel = handles.MarkerLabels{handles.MarkerIndex};
                                else
                                    % match marker label of last file, if existing
                                    handles.MarkerIndex = strmatch(handles.MarkerLabel, handles.MarkerLabels);
                                    % if no matching label found, set to first element
                                    if isempty(handles.MarkerIndex)
                                        handles.MarkerIndex = 1;
                                        handles.MarkerLabel = handles.MarkerLabels{handles.MarkerIndex};
                                    end
                                    handles.MarkerLabel = handles.MarkerLabels{handles.MarkerIndex};
                                    set(handles.popupmenumarker,'Value',handles.MarkerIndex);
                                end
                                
                                % enable pushbuttoncompute
                                set(handles.pushbuttoncomp,'Enable','on');
                                
                                % enable pushbuttonExport
                                set(handles.pushbuttonExport,'Enable','on');
                                
                                % pass on data to GUI
                                guidata(hObject,handles);
                                % execute Compute callback when a new file is loaded
                                pushbuttoncomp_Callback(hObject, eventdata, handles);
                            end
                        end
                    end
                end
            end
        end
    end
end


function editMinVelo_Callback(hObject, eventdata, handles)
% hObject    handle to editMinVelo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMinVelo as text
%        str2double(get(hObject,'String')) returns contents of editMinVelo as a double

 val = str2double(get(hObject,'String'));
if isnan(val)
    errordlg('You must enter a numeric value','Bad Input','modal')
    uicontrol(hObject)
    return
elseif val<=0
    errordlg('You must enter a positive value','Bad Input','modal')
    uicontrol(hObject)
    return
else
handles.minVelo = val;
end
% pass on data to GUI
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function editMinVelo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMinVelo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.minVelo = str2double(get(hObject,'String'));
% pass on data to GUI
guidata(hObject,handles);



function editMinPause_Callback(hObject, eventdata, handles)
% hObject    handle to editMinPause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMinPause as text
%        str2double(get(hObject,'String')) returns contents of editMinPause as a double
 val = str2double(get(hObject,'String'));

 if isnan(val)
     errordlg('You must enter a numeric value','Bad Input','modal')
     uicontrol(hObject)
     return
 elseif val<0
     errordlg('You must enter a positive value','Bad Input','modal')
     uicontrol(hObject)
     return
 elseif (mod(val,1)~=0)
     errordlg('You must enter an integer value','Bad Input','modal')
     uicontrol(hObject)
     return
 else
     handles.minPause = val;
     handles.minPausemsec = frames2msec(val, handles.Framerate, handles.precision);
     set(handles.textMinPausemseconds,'String',[num2str(handles.minPausemsec) ' ms']);
     
 end
% pass on data to GUI
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function editMinPause_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMinPause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.minPause = str2double(get(hObject,'String'));
% pass on data to GUI
guidata(hObject,handles);


function editMinPeaks_Callback(hObject, eventdata, handles)
% hObject    handle to editMinPeaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMinPeaks as text
%        str2double(get(hObject,'String')) returns contents of editMinPeaks as a double
val = str2double(get(hObject,'String'));

if isnan(val)
    errordlg('You must enter a numeric value','Bad Input','modal')
    uicontrol(hObject)
    return
elseif val<=0
    errordlg('You must enter a positive value','Bad Input','modal')
    uicontrol(hObject)
    return
elseif (mod(val,1)~=0)
    errordlg('You must enter an integer value','Bad Input','modal')
    uicontrol(hObject)
    return
else
    handles.minPeaks = val;
end
% pass on data to GUI
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function editMinPeaks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMinPeaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.minPeaks = str2double(get(hObject,'String'));
% pass on data to GUI
guidata(hObject,handles);


function editMinFrames_Callback(hObject, eventdata, handles)
% hObject    handle to editMinFrames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMinFrames as text
%        str2double(get(hObject,'String')) returns contents of editMinFrames as a double
 val = str2double(get(hObject,'String'));

 if isnan(val)
    errordlg('You must enter a numeric value','Bad Input','modal')
    uicontrol(hObject)
    return
elseif (mod(val,1)~=0)
    errordlg('You must enter an integer value','Bad Input','modal')
    uicontrol(hObject)
    return
 elseif val<=0
    errordlg('You must enter a positive value','Bad Input','modal')
    uicontrol(hObject)
    return
else
handles.minFrames = val;
handles.minFramesmsec = frames2msec(val, handles.Framerate, handles.precision);
set(handles.textMinFramesmseconds,'String',[num2str(handles.minFramesmsec) ' ms']);

end
% pass on data to GUI
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function editMinFrames_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMinFrames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.minFrames = str2double(get(hObject,'String'));
% pass on data to GUI
guidata(hObject,handles);



% --- Executes on selection change in popupmenusmoothpnts.
function popupmenusmoothpnts_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenusmoothpnts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenusmoothpnts contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenusmoothpnts
contents = cellstr(get(hObject,'String'));
handles.smoothpnts = str2num(contents{get(hObject,'Value')});

% pass on data to GUI
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popupmenusmoothpnts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenusmoothpnts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
contents = cellstr(get(hObject,'String'));
handles.smoothpnts = str2num(contents{get(hObject,'Value')});
% pass on data to GUI
guidata(hObject,handles);


% --- Executes on button press in pushbuttonExport.
function pushbuttonExport_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%


% ADD change to 'dataset' have input for 'event' (3rd column) as text
handles.exportdata = dataset({handles.tabledata,...
    handles.var_names{:}});

fname = [handles.FileName_short '_' handles.MarkerLabel ...
    '_smooth_' num2str(handles.smoothpnts) '_minVelo_' num2str(handles.minVelo) ...
    '_minPause_' num2str(handles.minPause) '_minPeaks_' num2str(handles.minPeaks) ...
    '_minFrames_' num2str(handles.minFrames) '.xls'];
[fname,path] = uiputfile('*.xls', 'Select File to Write',[handles.PathName fname]);
if fname~=0 % check if a filename is chosen
    % check if .xls
    [~, fending] = strtok(fname,'.');  % split into name and file ending
    if strcmp(fending,'.xls')~=1
        warndlg('Please save as a .xls File!', 'Wrong File Type');
    else
        if exist([path fname],'file')
            delete([path fname]);
        end
        % ADD delete old file, if existing % ALT turn on overwrite
        % if exist([path fname],'file')
        %
        % end
        % write file
        export(handles.exportdata,'XLSfile',[path fname],'Sheet',1);
        % turn of warning  % NOTE maybe there is a better place to do this?
        warning off MATLAB:xlswrite:AddSheet;
        % add worksheets with properties
        xlswrite([path fname], handles.filesummary, 2);
        % add worksheet with 'raw' data
            % convert to cell array first, to keep the 'nan''s
                seqcell = num2cell(handles.seq_qs);
                seqcell(isnan(handles.seq_qs)) ={'NaN'};
        xlswrite([path fname], seqcell, 3);
        % change names of the worksheets
        xlsheets({'Unit Data','Properties','SEQ Data'}, [path fname]);
        warning on MATLAB:xlswrite:AddSheet;
    end
end

% pass on data to GUI
guidata(hObject,handles);

% --- Executes on button press in checkboxWANDcorr.
function checkboxWANDcorr_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxWANDcorr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxWANDcorr

val = get(hObject,'Value');

if val==0
   handles.WANDfactor = 1; 
else
   handles.WANDfactor = 2.5;    % CHECK Is it always 2.5? Any way to check this?     
end

% pass on data to GUI
guidata(hObject,handles);

% --- Executes when selected object is changed in buttongroupdatatab.
function buttongroupdatatab_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in buttongroupdatatab
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'radiobuttonnicedata'
        
        % set 'framedata' table to invisible
        set(handles.uitableresultsframe,'Visible','off');
        % set 'rawdata' table to invisible
        set(handles.uitableresultsraw,'Visible','off');
        
        % set 'nicedata' table to visible
        set(handles.uitableresults,'Visible','on');
        
        
    case 'radiobuttonframedata'
        % set 'nicedata' table to invisible
        set(handles.uitableresults,'Visible','off');
        % set 'rawdata' table to invisible
        set(handles.uitableresultsraw,'Visible','off');
        
        % set 'framedata' table to visible
        set(handles.uitableresultsframe,'Visible','on');
        
    case 'radiobuttonrawdata'
        % set 'nicedata' table to invisible
        set(handles.uitableresults,'Visible','off');
        % set 'framedata' table to invisible
        set(handles.uitableresultsframe,'Visible','off');
        
        % set 'rawdata' table to visible
        set(handles.uitableresultsraw,'Visible','on');
    otherwise
        % Code for when there is no match.
end


% pass on data to GUI
guidata(hObject,handles);
