function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
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
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 04-Mar-2016 20:11:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in read_image.
function read_image_Callback(hObject, eventdata, handles)
% hObject    handle to read_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Read Image

global im
[fn,pn,~]=uigetfile('*.jpg','Choose Image');
im = imread([pn fn]);


%use the first axes 
axes(handles.axes1);
imshow(im);title('Original Image');

handles.image = im;

guidata(hObject, handles);



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);


% --- Executes on button press in process_image.
function process_image_Callback(hObject, eventdata, handles)
% hObject    handle to process_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global im

x = str2double(get(handles.Input2,'String'));
[f,g] = size(im);

[Im]=ya(im, f, g, x);

NM = str2double(get(handles.Input1,'String'));

hold on
L = size(Im);
height = x;
width = x;
max_row = floor(L(1) /height);  
max_col = floor(L(2) /width);
seg = cell(max_row,max_col);
com_seg = cell(max_row,max_col);
m_image = cell(max_row,max_col);
%??
for row = 1:max_row   
    for col = 1:max_col        
    seg(row,col)= {Im((row-1)*height+1:row*height,(col-1)*width+1:col*width,:)};  
    end
end 


for i=1:max_row*max_col
    [m_image{i}, com_seg{i}] = linear_reconstruction(seg{i}, NM);
    
end

for row = 1:max_row      
   for col = 1:max_col        
    new_image((row-1)*height+1:row*height,(col-1)*width+1:col*width,:) = m_image{row,col} ;  
    new_com((row-1)*height+1:row*height,(col-1)*width+1:col*width,:) = com_seg{row,col} ;  
    end
end 


hold off

H=im2double(new_image);

new_IM=imresize(H,[f g/3]);
H1 = im2double(new_com);
nn_com = imresize(H1, [f g/3]);

M_H = im2double(im);
im = imresize(M_H,[f,g/3]);

global similarity
similarity = ssim(im, new_IM);

axes(handles.axes2);
imshow(new_IM);title('Reconstructed Image');
axes(handles.axes3);
imshow(nn_com); title('Combine Pattern');
set(handles.edit_simi,'string',num2str(similarity));
guidata(hObject, handles);





function Input1_Callback(hObject, eventdata, handles)
% hObject    handle to Input1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Input1 as text
%        str2double(get(hObject,'String')) returns contents of Input1 as a double
input = get(handles.Input1,'String'); %get teh input from the edit text field
input = str2double(input); %change from string to number
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Input1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Input2_Callback(hObject, eventdata, handles)
% hObject    handle to Input2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Input2 as text
%        str2double(get(hObject,'String')) returns contents of Input2 as a double
input = get(handles.Input2,'String'); %get teh input from the edit text field
input = str2double(input); %change from string to number
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Input2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_simi_Callback(hObject, eventdata, handles)
% hObject    handle to edit_simi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_simi as text
%        str2double(get(hObject,'String')) returns contents of edit_simi as a double

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_simi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_simi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

guidata(hObject, handles);
