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

% Last Modified by GUIDE v2.5 22-Aug-2013 12:19:37

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

% compute speed/velocity
speed = aux_velocity(handles.rawdata,handles.Framerate,...
    handles.MarkerIndex,handles.smoothpnts);
handles.speed = speed;
raw_qualisys = baby_qualisys_speed(speed);
handles.raw_qualisys = raw_qualisys;

% get settings of criteria
minvelocity = handles.minVelo;   
minpauseframes = handles.minPause;
minpeaksinunit = handles.minPeaks;
minunitframes = handles.minFrames;


 % sequencing % states: 1:false, 2:true
 [seq_qs,qs_statenames] = baby_velocitypeaks(raw_qualisys,minvelocity,minpauseframes,minpeaksinunit,minunitframes);
 % TO DO check this one! esp. 'emptymatch' (probably version too old)
 [seq_qs,qs_statenames] = baby_seq_statenames_order(seq_qs,qs_statenames,{'','x'},{'^\s*$'},{'[xX]'});
handles.seq_qs = seq_qs;
handles.qs_statenames = qs_statenames;

% Update handles structure
guidata(hObject, handles);

% send data to resultstable
fillOutputpanel(hObject, handles);
%set(handles.uitableresults,'Data',seq_qs);
handles = guidata(hObject);

% Update handles structure
guidata(hObject, handles);

function fillOutputpanel(hObject, handles)
% FILLOUTPUTPANEL
%
% fills the outputpanel table with the data (as specified by ...)
% sets up the file summary and initializes the export options

% ADD choice between frames/ms
%% fill Table with data
% DataColumnNames
var_names = {'Startframes','Endframes','Eventbla'};
% Data
startframes = handles.seq_qs(1:end-1,1);
endframes = handles.seq_qs(2:end,1)-1;
eventstates = handles.seq_qs(1:end-1,2);
% ADD make into cellarray
%eventcell = num2cell(eventstates);

tabledata = [startframes endframes eventstates];
set(handles.uitableresults,'Data',tabledata);

% add to handles NOTE: necessary???
handles.tabledata = tabledata;
handles.var_names = var_names;
handles.startframes = startframes;
handles.endframes = endframes;
handles.eventstates = eventstates;

%% show file summary
% make cell arrays for properties and their respective names
filesum_propertynames = {'Pathname', 'Filename','Original Path and Filename' ...
    'Framerate', 'Frames','', 'MarkerLabel', 'Smoothingpoints','',...
    'Minimum Velocity', 'Minimum Pause', 'Minimum Peaks', 'Minimum Frames'};
filesum_properties = {handles.PathName, handles.FileName, handles.rawdata.File, ...
    num2str(handles.Framerate), num2str(handles.Frames),'', handles.MarkerLabel,...
    num2str(handles.smoothpnts),'',num2str(handles.minVelo),...
    num2str(handles.minPause), num2str(handles.minPeaks), num2str(handles.minFrames)};

% display on outputpanel

set(handles.textfilesummarypropertynames,'String',filesum_propertynames([2 4:end]));    % (2:end) to leave out pathname
set(handles.textfilesummaryproperties,'String',filesum_properties([2 4:end]));          % dto.

% save for exportfile
handles.filesummary = [filesum_propertynames; filesum_properties]';

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

% load selected file (later:incl load-options)
rawdata = load([PathName FileName]); 
FileName_short = FileName(1:end-4); % discarding the '.mat'
eval(['rawdata = rawdata.' FileName_short]);

% NOTE: ADD check for No/ invalid file, later

% save info in handles struct
handles.rawdata = rawdata;
handles.PathName = PathName;
handles.FileName = FileName;
handles.FileName_short = FileName_short;
handles.Framerate = rawdata.FrameRate;
handles.Frames = rawdata.Frames;
% NOTE! Ignoring Unlabeled/Discarded for now
handles.NrOfMarkers = rawdata.Trajectories.Labeled.Count;
handles.MarkerLabels = rawdata.Trajectories.Labeled.Labels;


% show selected file, framerate and number of frames in textfields
set(handles.textfname,'String',handles.FileName_short);
set(handles.textfilefs,'String',[num2str(handles.Framerate) '/s']);
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

% enable pushbuttoncompute
set(handles.pushbuttonExport,'Enable','on');

% pass on data to GUI
guidata(hObject,handles);
% execute Compute callback when a new file is loaded
pushbuttoncomp_Callback(hObject, eventdata, handles);


function editMinVelo_Callback(hObject, eventdata, handles)
% hObject    handle to editMinVelo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMinVelo as text
%        str2double(get(hObject,'String')) returns contents of editMinVelo as a double

 val = str2double(get(hObject,'String'));

if val<=0
    msgbox('Must be positive','Input error');
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

if val<0
    msgbox('Must be positive','Input error');
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

if val<=0
    msgbox('Must be positive','Input error');
elseif ~isinteger(val)
    msgbox('Must be integer','Input error');
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

if val<=0
    msgbox('Must be positive','Input error');
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

if 0 % save as .mat
elseif 1 % save as .xls
    
% ADD change to 'dataset' have input for 'event' (3rd column) as text
handles.exportdata = dataset({handles.tabledata,...
    'Startframe', 'Endframe', 'Event'});
    % handles.var_names});
fname = [handles.FileName_short '_' handles.MarkerLabel '.xls']; % ADD criteria¨smooth settings
[fname,path] = uiputfile('*.xls', 'Select File to Write',[handles.PathName fname]);
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
% change names of the worksheets
xlsheets({'Data','Properties'}, [path fname]);
warning on MATLAB:xlswrite:AddSheet;
end

% pass on data to GUI
guidata(hObject,handles);
