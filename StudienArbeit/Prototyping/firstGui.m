
%*****************************Generate Test Data*****************************%

function varargout = firstGui(varargin)
% FIRSTGUI MATLAB code for firstGui.fig
%      FIRSTGUI, by itself, creates a new FIRSTGUI or raises the existing
%      singleton*.
%
%      H = FIRSTGUI returns the handle to a new FIRSTGUI or the handle to
%      the existing singleton*.
%
%      FIRSTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIRSTGUI.M with the given input arguments.
%
%      FIRSTGUI('Property','Value',...) creates a new FIRSTGUI or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before firstGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to firstGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help firstGui

% Last Modified by GUIDE v2.5 04-Feb-2019 01:25:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @firstGui_OpeningFcn, ...
                   'gui_OutputFcn',  @firstGui_OutputFcn, ...
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

% --- Executes just before firstGui is made visible.
function firstGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to firstGui (see VARARGIN)

% Choose default command line output for firstGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes firstGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = firstGui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function n_charger_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n_charger (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function n_charger_Callback(hObject, eventdata, handles)
% hObject    handle to n_charger (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of n_charger as text
%        str2double(get(hObject,'String')) returns contents of n_charger as a double
N_charger = str2num(get(hObject, 'String'));
if isnan(N_charger)
    set(hObject, 'String', 0);
end
disp('number of chargers');
% Save the new n_charger value
handles.nChargers = N_charger;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function volume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function volume_Callback(hObject, eventdata, handles)
% hObject    handle to volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of volume as text
%        str2double(get(hObject,'String')) returns contents of volume as a double
volume = str2double(get(hObject, 'String'));
if isnan(volume)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new volume value
handles.metricdata.volume = volume;
guidata(hObject,handles)

% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mass = handles.metricdata.density * handles.metricdata.volume;
set(handles.mass, 'String', mass);

% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

initialize_gui(gcbf, handles, true);

% --- Executes when selected object changed in unitgroup.
function unitgroup_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in unitgroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (hObject == handles.english)
    set(handles.text4, 'String', 'lb/cu.in');
    set(handles.text5, 'String', 'cu.in');
    set(handles.text6, 'String', 'lb');
else
    set(handles.text4, 'String', 'kg/cu.m');
    set(handles.text5, 'String', 'cu.m');
    set(handles.text6, 'String', 'kg');
end

% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'metricdata') && ~isreset
    return;
end

handles.metricdata.density = 0;
handles.metricdata.volume  = 0;






% Update handles structure
guidata(handles.figure1, handles);


% --- Executes on button press in show_soc_sim.
function show_soc_sim_Callback(hObject, eventdata, handles)
% hObject    handle to show_soc_sim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Innenwiderstand einer Zelle in mOhm  x-> Soc | y -> T

% --- Executes on button press in ShowSched.
function ShowSched_Callback(hObject, eventdata, handles)
% hObject    handle to ShowSched (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function step_dt_Callback(hObject, eventdata, handles)
% hObject    handle to step_dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
disp('slider moves');
set(hObject, 'Value', round(get(hObject,'Value')));
get(hObject,'Value')
hdt=findall(0,'tag','dtt');
set(hdt,'String',round(get(hObject,'Value')))
handles.dtt=round(get(hObject,'Value'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function step_dt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step_dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'min', 1);
set(hObject, 'max', 60);
set(hObject, 'Value', 30);
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in sec.
function sec_Callback(hObject, eventdata, handles)
% hObject    handle to sec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sec
disp('unit set to s');
val = get(hObject,'Value');
if(val)
   handles.unit='s';
   writeWithTag('min','Value',0);
   writeWithTag('hrs','Value',0);
end
guidata(hObject,handles);
%disp(get(hObject,'Value'))

% --- Executes on button press in min.
function min_Callback(hObject, eventdata, handles)
% hObject    handle to min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of min
disp('unit set to min')
val = get(hObject,'Value');
if(val)
   handles.unit='min';
   writeWithTag('sec','Value',0);
   writeWithTag('hrs','Value',0);
end
guidata(hObject,handles);

% --- Executes on button press in hrs.
function hrs_Callback(hObject, eventdata, handles)
% hObject    handle to hrs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hrs
disp('unit set to hours');
val = get(hObject,'Value');
if(val)
   handles.unit='h';
   writeWithTag('sec','Value',0);
   writeWithTag('min','Value',0);
end
guidata(hObject,handles);

function pmax_Callback(hObject, eventdata, handles)
% hObject    handle to pmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pmax as text
%        str2double(get(hObject,'String')) returns contents of pmax as a double
disp('insert pmax');
Pmax = str2double(get(hObject, 'String'));
if isnan(Pmax)
    set(hObject, 'String', 0);
end
% Save the new n_charger value
handles.Pmax = Pmax;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function pmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_bus_csv.
function load_bus_csv_Callback(hObject, eventdata, handles)
% hObject    handle to load_bus_csv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    disp('LoadCSV');
    handles.nChargers

% --- Executes on button press in sim_charge.
function sim_charge_Callback(hObject, eventdata, handles)
% hObject    handle to sim_charge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%*****************************Cells Data*****************************%
% Innenwiderstand einer Zelle in mOhm  x-> Soc | y -> T
global Ri_soc_LookUp;
Ri_soc_LookUp = [0    0     10      20      30      40      50      60      70      80      90      100;
                -10   3.27	1.71	1.70	1.68	1.67	1.66	1.63	1.62	1.60	1.58	1.51;
                0     2.66	1.39	1.38	1.37	1.35	1.34	1.33	1.31	1.30	1.28	1.22;
                10    2.32	1.21	1.20	1.19	1.18	1.17	1.16	1.15	1.13	1.11	1.06;
                25    1.98	1.04	1.03	1.02	1.01	1.00	0.99	0.98	0.97	0.95	0.91;
                40    1.87	0.98	0.97	0.96	0.95	0.95	0.93	0.93	0.92	0.90	0.86;
                50    1.80	0.94	0.93	0.93	0.92	0.91	0.90	0.89	0.88	0.87	0.83];

% max Zellströme in Ampere x-> T | y ->Soc
global Imax_LookUp;            
Imax_LookUp =      [   0	-40	-30	-20	-10	0	10	15	25	30	65	85;
                       0	0	0	0	0	0	0	0	0	0	0	0;
                       10	0	0	0	0	0	0	0	0	0	0	0;
                       20	2	2	2	2	2	2	2	2	2	2	0;
                       30	6	6	6	6	6	6	6	6	6	6	0;
                       40	10	10	10	10	10	10	10	10	10	10	0;
                       50	20	20	20	20	20	20	20	20	20	20	0;
                       60	40	40	40	40	40	40	40	40	40	40	0;
                       70	60	60	60	60	60	60	60	60	60	60	0;
                       80	60	60	60	60	60	60	60	60	60	60	0;
                       90	60	60	60	60	60	60	60	60	60	60	0;
                       100	0	0	0	0	0	0	0	0	0	0	0];
                   
% Voltage and Capacity by 25*C
global VoltSoc_LookUp;
VoltSoc_LookUp =        [0.000 0.021 0.023 0.028 0.036 0.043 0.050 0.059 0.071 0.083 0.105 0.153 0.229 0.305 0.375 0.494 0.582 0.682 0.761 0.864 0.939 0.986 0.995 1.000;
                         2.005 2.120 2.208 2.301 2.389 2.505 2.588 2.708 2.821 2.936 3.031 3.115 3.164 3.189 3.207 3.229 3.235 3.244 3.260 3.271 3.286 3.306 3.352 3.421];

% Korrekturfaktoren für Kapazität einer Zelle in Abhängigkeit der
% row1 : K | row2 : T
global TempCorrection_LookUp;
TempCorrection_LookUp = [0.34 0.57 0.72 0.84 0.91 1.00 1.02 1.03;
                         -30  -20  -10  0    10   25   35   45  ];
%*****************************Generate Test Data*****************************%
MyBus=handles.LastBus;
disp('about to start simulation');
%---- LookUps ----%
MyBus.Battery.Ri_soc_LookUp=Ri_soc_LookUp;
MyBus.Battery.Imax_LookUp=Imax_LookUp;
MyBus.Battery.VoltSoc_LookUp=VoltSoc_LookUp;
MyBus.Battery.TempCorrection_LookUp=TempCorrection_LookUp;
%---- Simulation ----%
tic;
dt=handles.dtt;
tunit=handles.unit;
Pmax=handles.Pmax*1000;
withplot=0;
%---- Set axes tto ----%
ax2 = findall(0,'tag','axes2');
axes(ax2);
MyBus.CalcP(dt,Pmax,withplot,tunit);
C        = MyBus.Battery.simC;
Cmaxx    = MyBus.Battery.Cmax;
I        = MyBus.Battery.simI;
P        = MyBus.Battery.simP;
Pmax     = MyBus.Battery.Pmax;
[unit,un]= MyBus.Battery.ReturnUnit(tunit);
%writeWithTag('axes2','Color','red');
disp('values calculated'); 
[~,i]=size(C);
%____________ Time 
t= (0:dt:dt*(i-1));
t=t/unit;
dt=dt/unit;
%____________ Soc Plot
subplot(4,1,1);
plot(t,C)%graph type
title('SOC Plot')
xlabel(strcat('Time in ',{' '},un))
ylabel('SOC in %')
ylim([0 110])
xlim([0 dt*(i-1)])
%____________ C Plot
subplot(4,1,2);
plot(t,C*Cmaxx/(100*1000))%graph type
title('C Plot')
xlabel(strcat('Time in ',{' '},un))
ylabel(strcat('C_i_n in kA',un))
xlim([0 dt*(i-1)])  
ylim([0.1*Cmaxx Cmaxx]/1000)
%____________ I Plot
subplot(4,1,3);
plot(t,I)%graph type
title('I_m_a_x Plot')
xlabel(strcat('Time in ',{' '},un))
ylabel('I_m_a_x in A')
xlim([0 dt*(i-1)])  
%ylim([0 100])
%____________ P Plot
ax4 = subplot(4,1,4);
cla(ax4);
hold(ax4,'on');
p1 = plot(t,-P/1000);%graph type      
p2 = plot(t,Pmax*ones(size(t))/1000);
legend([p1 p2],{'Pab','Pmax'})
title('P (Charger) Plot')
xlabel(strcat('Time in ',{' '},un))
ylabel('P in kW')
xlim([0 dt*(i-1)])
hold(ax4,'off');
refreshdata
%ylim([110 210])

disp('plotted')
disp(MyBus.ID)

% --- Executes on button press in schedule.
function schedule_Callback(hObject, eventdata, handles)
% hObject    handle to schedule (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('run schedule')

function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bus_id_Callback(hObject, eventdata, handles)
% hObject    handle to bus_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bus_id as text
%        str2double(get(hObject,'String')) returns contents of bus_id as a double
disp('bus id ')
%writeWithTag('bus_id','String','');
ID = get(hObject, 'String');
% Save the new n_charger value
handles.ID = ID;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function bus_id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bus_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Bus_list_arr_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Bus_list_arr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('array list')

function Bus_arr_time_Callback(hObject, eventdata, handles)
% hObject    handle to Bus_arr_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Bus_arr_time as text
%        str2double(get(hObject,'String')) returns contents of Bus_arr_time as a double
disp('arrival time')
try
    Arrival_time = datetime(get(hObject, 'String'),'InputFormat','HH:mm');
    handles.Arrival_time = Arrival_time;
    guidata(hObject,handles)
catch
    disp('wrong time format !');
end
    
% --- Executes during object creation, after setting all properties.
function Bus_arr_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bus_arr_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Bus_arr_soc_Callback(hObject, eventdata, handles)
% hObject    handle to Bus_arr_soc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Bus_arr_soc as text
%        str2double(get(hObject,'String')) returns contents of Bus_arr_soc as a double
disp('arrival soc')
Arrival_SOC = str2num(get(hObject, 'String'));
if isnan(Arrival_SOC)
    set(hObject, 'String', 0);
end
disp('number of chargers');
% Save the new n_charger value
handles.Arrival_SOC = Arrival_SOC;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function Bus_arr_soc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bus_arr_soc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Bus_dep_time_Callback(hObject, eventdata, handles)
% hObject    handle to Bus_dep_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Bus_dep_time as text
%        str2double(get(hObject,'String')) returns contents of Bus_dep_time as a double
disp('departure time')
try
    Departure_time = datetime(get(hObject, 'String'),'InputFormat','HH:mm');
    handles.Departure_time = Departure_time;
    guidata(hObject,handles)
catch
    disp('wrong time format !');
end
% --- Executes during object creation, after setting all properties.
function Bus_dep_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bus_dep_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Bus_dep_soc_Callback(hObject, eventdata, handles)
% hObject    handle to Bus_dep_soc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Bus_dep_soc as text
%        str2double(get(hObject,'String')) returns contents of Bus_dep_soc as a double
disp('dep soc')
Departure_SOC = str2num(get(hObject, 'String'));
if isnan(Departure_SOC)
    set(hObject, 'String', 0);
end
disp('number of chargers');
% Save the new n_charger value
handles.Departure_SOC = Departure_SOC;
guidata(hObject,handles)
% --- Executes during object creation, after setting all properties.
function Bus_dep_soc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bus_dep_soc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Bus_cmax_Callback(hObject, eventdata, handles)
% hObject    handle to Bus_cmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Bus_cmax as text
%        str2double(get(hObject,'String')) returns contents of Bus_cmax as a double
disp('cmax max capacity')
Cmax = str2num(get(hObject, 'String'));
if isnan(Cmax)
    set(hObject, 'String', 0);
end
disp('number of chargers');
% Save the new n_charger value
handles.Cmax = Cmax;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function Bus_cmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bus_cmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function N_serie_Callback(hObject, eventdata, handles)
% hObject    handle to N_serie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of N_serie as text
%        str2double(get(hObject,'String')) returns contents of N_serie as a double
disp(' number series Cells ')
NumberOfCellsSerie = str2num(get(hObject, 'String'));
if isnan(NumberOfCellsSerie)
    set(hObject, 'String', 0);
end
disp('number of chargers');
% Save the new n_charger value
handles.NumberOfCellsSerie = NumberOfCellsSerie;
guidata(hObject,handles)
% --- Executes during object creation, after setting all properties.
function N_serie_CreateFcn(hObject, eventdata, handles)
% hObject    handle to N_serie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function N_paralell_Callback(hObject, eventdata, handles)
% hObject    handle to N_paralell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of N_paralell as text
%        str2double(get(hObject,'String')) returns contents of N_paralell as a double
disp(' number parallel ')
NumberOfCellsPll = str2num(get(hObject, 'String'));
if isnan(NumberOfCellsPll)
    set(hObject, 'String', 0);
end
disp('number of chargers');
% Save the new n_charger value
handles.NumberOfCellsPll = NumberOfCellsPll;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function N_paralell_CreateFcn(hObject, eventdata, handles)
% hObject    handle to N_paralell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in lipo.
function lipo_Callback(hObject, eventdata, handles)
% hObject    handle to lipo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lipo


% --- Executes on button press in lito.
function lito_Callback(hObject, eventdata, handles)
% hObject    handle to lito (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lito


% --- Executes on button press in nmc.
function nmc_Callback(hObject, eventdata, handles)
% hObject    handle to nmc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of nmc


% --- Executes on button press in add_bus.
function add_bus_Callback(hObject, eventdata, handles)
data = readWithTag('Bus_list_arr','Data');
clc;
str1 = handles.ID;
str2 = datestr(handles.Arrival_time,'HH:MM');
disp('first row ')
disp(data(1,:))
if isequal(data(1,:),{'',''})
    data={str1,str2};
else
    data=[data;{str1,str2}];
end
writeWithTag('Bus_list_arr','Data',data);
MyBus=aBus();
%--- Bus Data ---%
MyBus.ID=handles.ID;
MyBus.Arrival_time=handles.Arrival_time;
disp('dep time')
disp(handles.Departure_time)
MyBus.Departure_time=handles.Departure_time;
%---- SOC Variables ----% 
MyBus.Arrival_SOC=handles.Arrival_SOC;
MyBus.Departure_SOC=handles.Departure_SOC;
%---- Scheduling Variables ----% 
MyBus.ChargingStart=0;
MyBus.ChargingTime=0;
%---- BatteryData ----% 
MyBus.Battery = aBattery();
MyBus.Battery.ID=MyBus.ID;
MyBus.Battery.Cmax=handles.Cmax;%As
MyBus.Battery.SOC=MyBus.Arrival_SOC;
MyBus.Battery.endSOC=MyBus.Departure_SOC;
MyBus.Battery.Temperatur=25;
MyBus.Battery.NumberOfCellsPll=handles.NumberOfCellsPll;
MyBus.Battery.NumberOfCellsSerie=handles.NumberOfCellsSerie;
handles.LastBus = MyBus;
guidata(hObject,handles)
disp('add bus ');
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('default')

% --- Executes on button press in optimiser.
function optimiser_Callback(hObject, eventdata, handles)
% hObject    handle to optimiser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('optimiser')

% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('other')
