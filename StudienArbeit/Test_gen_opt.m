clc;clear all;
clear
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
global BusArray;
global iteration dt;
iteration=0;
nr_bus = 10;
dt=250;
x1=zeros(nr_bus,1)';
tic
BusArray=randomFill(nr_bus,45*10^3);
toc
arrtime=datetime('00:00:00','InputFormat','HH:mm:SS');
deptime=datetime('06:00:00','InputFormat','HH:mm:SS');
for i=1:nr_bus
   %BusArray(i).CalcP(dt,45000,0,'s');
   start_time=abs(etime(datevec(arrtime),datevec(BusArray(i).Arrival_time)));
   BusArray(i).ChargingStart=start_time;
   BusArray(i).Arrival_seconds = start_time;
end


%*****************************Run Optimiser*****************************%
%------------------------------------------%
[Bm,~,~]=FillBigMatrix(BusArray,dt,1);
wC=CalcWorstCase(Bm); 
[~,sizeBigM ] = size(Bm);
global goal;
goal = 'Nmin';
newBarplot(BusArray,1,Bm)
tic;
opt_t0 = Optimise_t0(@Opt_function,BusArray,dt,arrtime);
toc;
[Bm,Pges_max,Nmax]=FillBigMatrix(BusArray,dt,0);
plot_P(Bm,wC,1);
for i=1:nr_bus
     BusArray(i).ChargingStart=double(opt_t0(i)*dt);
end  

%Save the list
newBarplot(BusArray,1,Bm)
name = strcat('BusList',int2str(nr_bus),'.mat');
save(name, 'BusArray');
%------------------------------------------%

[Energie_stored,Energie_grid] = CalC_Energie(BusArray(9),0.94,VoltSoc_LookUp)
Bus = BusArray(9);
