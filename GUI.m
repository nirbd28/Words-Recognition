function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 30-Apr-2019 16:38:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% paths
global project_path;
global MFCC_GMM_path;
global records_path;
%%%
project_path = pwd;
MFCC_GMM_path=strcat(project_path,'\','MFCC-GMM'); 
records_path=strcat(project_path,'\','Records'); 

%%%%%%%%%% add paths
addpath(strcat(project_path,'\','Feature_Extraction'));
addpath(strcat(project_path,'\','Function_Old')); 
addpath(MFCC_GMM_path);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% arrays
global name_train_arr;% train set
global name_test_arr;% test set
global words_arr;
global words_index_arr;
%%%
name_train_arr={'nir' 'avishai' 'guy' 'riki' 'ilan' 'noam' 'orit' 'shosh'  'eli' 'gali' 'avi' 'amit'};
name_test_arr={  'roy' 'gili' 'tal' 'gabi' 'dan'};
%%%
words_arr={'ahat' 'shtaim' 'shalosh' 'arba' 'hamesh' 'one' 'two' 'three' 'four' 'five'};
words_index_arr={'1. ahat' '2. shtaim' '3. shalosh' '4. arba' '5. hamesh' '6. one' '7. two' '8. three' '9. four' '10. five'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% VAD parameters
global frame_time;
global frame_lap;
global silence_trsh;
global slide;
%%%
frame_time = 16e-3; frame_lap = frame_time/2;
silence_trsh=0.001;
slide=6;

%%%%%%%%%% MFCC parameters
global alpha;
global coeffs_num;
%%% 
alpha= 0.97;
coeffs_num= 13;

%%%%%%%%%% GMM parameters
global options;
global k_gaussians;
global Regularize;
%%%
options = statset('MaxIter',300,'Display','final');
k_gaussians = 14;
Regularize = 1e-7;

%%%%% GMM model
global GMM_struct;
%%% load GMM
try
    file_name_gmm_final=strcat(MFCC_GMM_path,'\','GMM.mat');
    load(file_name_gmm_final,'-mat');
catch
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Statistics parameters
global count;
global count_success;
%%%
count=0;
count_success=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%% plot
cla reset;
axis([0 2 -10  10]);

%%%%%%%%%% listbox
for i=1:length(words_arr)
    listbox_words{i} = strcat(num2str(i),'.', words_arr{i});
end
set(handles.listbox_words, 'String', listbox_words);
%%%
global selected_word;
%%%
listboxItems = get(handles.listbox_words, 'string');
selectedItems = get(handles.listbox_words, 'value');
selected_word = listboxItems(selectedItems);
selected_word = strsplit(selected_word{1},'.');
selected_word = selected_word{length(selected_word)};

%%%%%%%%%% pop up menu
set(handles.popupmenu_train_test, 'String', {'Test' 'Train'});
%%%
global test_or_train;
%%%
listboxItems = get(handles.popupmenu_train_test, 'string');
selectedItems = get(handles.popupmenu_train_test, 'value');
test_or_train = listboxItems(selectedItems);
test_or_train = strsplit(test_or_train{1},'.');
test_or_train = test_or_train{length(test_or_train)};

%%%%%%%%%% other handles
set(handles.div_audio,'enable','off')
%%%
set(handles.txt_v,'BackgroundColor','white');
set(handles.txt_x,'BackgroundColor','white');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% unused handles functions


function txt_recognized_word_Callback(hObject, eventdata, handles)
% hObject    handle to txt_recognized_word (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_recognized_word as text
%        str2double(get(hObject,'String')) returns contents of txt_recognized_word as a double


% --- Executes during object creation, after setting all properties.
function txt_recognized_word_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_recognized_word (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function txt_count_succes_Callback(hObject, eventdata, handles)
% hObject    handle to txt_count_succes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_count_succes as text
%        str2double(get(hObject,'String')) returns contents of txt_count_succes as a double


% --- Executes during object creation, after setting all properties.
function txt_count_succes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_count_succes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function txt_name_Callback(hObject, eventdata, handles)
% hObject    handle to txt_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_name as text
%        str2double(get(hObject,'String')) returns contents of txt_name as a double


% --- Executes during object creation, after setting all properties.
function txt_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_success_rate_Callback(hObject, eventdata, handles)
% hObject    handle to txt_success_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_success_rate as text
%        str2double(get(hObject,'String')) returns contents of txt_success_rate as a double


% --- Executes during object creation, after setting all properties.
function txt_success_rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_success_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function txt_count_Callback(hObject, eventdata, handles)
% hObject    handle to txt_count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_count as text
%        str2double(get(hObject,'String')) returns contents of txt_count as a double


% --- Executes during object creation, after setting all properties.
function txt_count_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% used handle functions

% --- Executes on selection change in listbox_words.
function listbox_words_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_words (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_words contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_words

global selected_word;
%%%
listboxItems = get(handles.listbox_words, 'string');
selectedItems = get(handles.listbox_words, 'value');
selected_word = listboxItems(selectedItems);
selected_word = strsplit(selected_word{1},'.');
selected_word = selected_word{length(selected_word)};

% --- Executes during object creation, after setting all properties.
function listbox_words_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_words (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_train_test.
function popupmenu_train_test_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_train_test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_train_test contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_train_test

global test_or_train;
%%%
listboxItems = get(handles.popupmenu_train_test, 'string');
selectedItems = get(handles.popupmenu_train_test, 'value');
test_or_train = listboxItems(selectedItems);
test_or_train = strsplit(test_or_train{1},'.');
test_or_train = test_or_train{length(test_or_train)};

% --- Executes during object creation, after setting all properties.
function popupmenu_train_test_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_train_test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in div_audio.
function div_audio_Callback(hObject, eventdata, handles)
% hObject    handle to div_audio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%
global speech;
global fs;
%%%

[speech, fs, file_name, path]=LoadFile();

slide=10; 
silence_trsh=0.001;
DivAudio(speech, fs, file_name, path, slide, silence_trsh);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in record.
function record_Callback(hObject, eventdata, handles)
% hObject    handle to record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%
global speech;
global fs;
%%%
global frame_time;
global frame_lap;
global silence_trsh;
global slide;
%%%
global coeffs_num;
global alpha;
%%%
global GMM_struct;
%%%
global selected_word;
%%%
global count;
global count_success;
%%%
global words_arr;
%%%

set(handles.record,'enable','off')
try
fs= 8000;
record_time=2;
speech = Record(fs, record_time);

speech_old=speech;
[speech, start_time, end_time] = CutSilence_StartEnd(speech, fs, frame_time, frame_lap, silence_trsh, slide);
PlotVad(speech_old, fs, start_time, end_time, 'Record')

sound(speech,fs)

[recognized_word]=WordsRecognition(speech, fs,frame_time, frame_lap, alpha, coeffs_num, GMM_struct, words_arr);
set(handles.txt_recognized_word,'string',recognized_word);

[count, count_success, success_rate, recognition]=Statistics(recognized_word, selected_word, count, count_success);

if recognition
    set(handles.txt_v,'BackgroundColor','green');
    set(handles.txt_x,'BackgroundColor','white');
else
    set(handles.txt_v,'BackgroundColor','white');
    set(handles.txt_x,'BackgroundColor','red');   
end

set(handles.txt_name,'string',' ');
set(handles.txt_count,'string',count);
set(handles.txt_count_succes,'string',count_success);
set(handles.txt_success_rate,'string',success_rate);

catch
end
set(handles.record,'enable','on')


% --- Executes on button press in load_file.
function load_file_Callback(hObject, eventdata, handles)
% hObject    handle to load_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%
global speech;
global fs;
%%%
global frame_time;
global frame_lap;
global silence_trsh;
global slide;
%%%
global coeffs_num;
global alpha;
%%%
global GMM_struct;
%%%
global selected_word;
%%%
global count;
global count_success;
%%%
global words_arr;
%%%

[speech, fs, file_name, ~]=LoadFile();
name = GetNameOfSpeaker(file_name);

speech_old=speech;
[speech, start_time, end_time] = CutSilence_StartEnd(speech, fs, frame_time, frame_lap, silence_trsh, slide);
PlotVad(speech_old, fs, start_time, end_time, file_name)

sound(speech, fs);

[recognized_word]=WordsRecognition(speech, fs,frame_time, frame_lap, alpha, coeffs_num, GMM_struct, words_arr);
set(handles.txt_recognized_word,'string',recognized_word);

[count, count_success, success_rate, recognition]=Statistics(recognized_word, selected_word, count, count_success);

if recognition
    set(handles.txt_v,'BackgroundColor','green');
    set(handles.txt_x,'BackgroundColor','white');
else
    set(handles.txt_v,'BackgroundColor','white');
    set(handles.txt_x,'BackgroundColor','red');   
end

set(handles.txt_name,'string',name);
set(handles.txt_count,'string',count);
set(handles.txt_count_succes,'string',count_success);
set(handles.txt_success_rate,'string',success_rate);


% --- Executes on button press in save_file.
function save_file_Callback(hObject, eventdata, handles)
% hObject    handle to save_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%
global speech;
global fs;
%%%
SaveFile(speech, fs)

% --- Executes on button press in sound.
function sound_Callback(hObject, eventdata, handles)
% hObject    handle to sound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%
global speech;
global fs;
%%%
sound(speech, fs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in test_speaker.
function test_speaker_Callback(hObject, eventdata, handles)
% hObject    handle to test_speaker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%
global frame_time;
global frame_lap;
global coeffs_num;
global alpha;
%%%
global words_arr;
%%%
global selected_word;
%%%
global GMM_struct;
%%%

[~, ~, file_name, path]=LoadFile();
[success_rate, count_success, count, name]=TestSpeaker(frame_time, frame_lap, alpha, coeffs_num, path, file_name, GMM_struct, selected_word, words_arr);
set(handles.txt_name,'string',name);
set(handles.txt_count,'string',count);
set(handles.txt_count_succes,'string',count_success);
set(handles.txt_success_rate,'string',success_rate);

set(handles.txt_v,'BackgroundColor','white');
set(handles.txt_x,'BackgroundColor','white');
set(handles.txt_recognized_word,'string','');


% --- Executes on button press in test_all_speaker.
function test_all_speaker_Callback(hObject, eventdata, handles)
% hObject    handle to test_all_speaker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%
global frame_time;
global frame_lap;
global coeffs_num;
global alpha;
%%%
global words_arr;
global name_train_arr;
global name_test_arr;
%%%
global selected_word;
%%%
global GMM_struct;
%%%
global test_or_train;
%%%

[~, ~, ~, path]=LoadFile();
[success_rate, count_success, overall_count]=TestAllSpeakers(frame_time, frame_lap, alpha, coeffs_num, path, GMM_struct, selected_word, words_arr, name_train_arr, name_test_arr, test_or_train);
set(handles.txt_name,'string',test_or_train);
set(handles.txt_count,'string',overall_count);
set(handles.txt_count_succes,'string',count_success);
set(handles.txt_success_rate,'string',success_rate);

set(handles.txt_v,'BackgroundColor','white');
set(handles.txt_x,'BackgroundColor','white');
set(handles.txt_recognized_word,'string','');

% --- Executes on button press in test_all_words.
function test_all_words_Callback(hObject, eventdata, handles)
% hObject    handle to test_all_words (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%
global frame_time;
global frame_lap;
global coeffs_num;
global alpha;
%%%
global records_path;
%%%
global words_arr;
global words_index_arr;
global name_train_arr;
global name_test_arr;
%%%
global GMM_struct;
%%%
global test_or_train;

struct=TestAllWords(frame_time, frame_lap, alpha, coeffs_num, GMM_struct, words_arr, words_index_arr, name_train_arr, name_test_arr, test_or_train, records_path);;


% --- Executes on button press in reset_statistics.
function reset_statistics_Callback(hObject, eventdata, handles)
% hObject    handle to reset_statistics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%
global count;
global count_success;
%%%

count=0;
count_success=0;

cla reset;
axis([0 2 -10  10]);

set(handles.txt_name,'string','');
set(handles.txt_count,'string',count);
set(handles.txt_count_succes,'string',count_success);
set(handles.txt_success_rate,'string','');

set(handles.txt_v,'BackgroundColor','white');
set(handles.txt_x,'BackgroundColor','white');

set(handles.txt_recognized_word,'string','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in mfcc_all_words.
function mfcc_all_words_Callback(hObject, eventdata, handles)
% hObject    handle to mfcc_all_words (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%
global name_train_arr;
global words_index_arr;
%%%
global MFCC_GMM_path;
global records_path;
%%%
global frame_time;
global frame_lap;
global coeffs_num;
global alpha;
%%%

set(handles.txt_tic,'string','0');
tic;
clc;
MFCC_AllWords(frame_time, frame_lap, alpha, coeffs_num, name_train_arr, words_index_arr, MFCC_GMM_path, records_path);
disp('Finish MFCC')
timerVal = toc;
set(handles.txt_tic,'string',timerVal);


% --- Executes on button press in create_gmm.
function create_gmm_Callback(hObject, eventdata, handles)
% hObject    handle to create_gmm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%
global options;
global k_gaussians;
global Regularize;
%%%
global words_index_arr;
%%%
global MFCC_GMM_path;
%%%
global GMM_struct;
%%%

set(handles.txt_tic,'string','0');
tic;
clc;
GMM_struct = CreateGMM_struct(MFCC_GMM_path, k_gaussians, options, words_index_arr, Regularize);
disp('Finish GMM')
timerVal = toc;
set(handles.txt_tic,'string',timerVal);

% --- Executes on button press in load_gmm.
function load_gmm_Callback(hObject, eventdata, handles)
% hObject    handle to load_gmm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%
global GMM_struct;
%%%

[file_name, path] = uigetfile('.mat');
filename_final = strcat(path, file_name);
load(filename_final,'-mat');

