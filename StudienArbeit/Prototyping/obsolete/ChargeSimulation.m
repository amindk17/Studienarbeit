
%calculate charge vector
[C,I,P]= calcNewSocVector(soc,Cmax,Temperatur,dt,NumberOfCellsPll,NumberOfCellsReihe,pmax,ploty);%%%%%%%%%%%%%%
E=C*Cmax;




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

                     
                     


[C,I,P]= calcNewSocVector(soc,Cmax,Temperatur,dt,NumberOfCellsPll,NumberOfCellsReihe,pmax,ploty);%%%%%%%%%%%%%%
E=C*Cmax;

%*****************************Help Functions*****************************%
%Function to return the internal resistance
function Ri = Return_Ri(Temperatur,SoC,LookUp)
    Soc_vector=LookUp(1,:)';
    T_vector = LookUp(:,1);
    Soc_vector(1,:)=[];
    T_vector(1,:)=[];
    LookUp(1,:) = [];
    LookUp(:,1) = [];
    if((Temperatur < -10	) || (Temperatur>50))
        msg = 'Cell Temperature out of Range';
        error(msg)
    end

    if( (SoC < 0) || (SoC>100) )
        msg = 'Cell Capacity out of Range';
        error(msg)
    else 
        [T  Tindex]=min(abs(T_vector-Temperatur));
        [soc Socindex] = min(abs(Soc_vector-SoC));
        Ri = LookUp(Tindex,Socindex)/1000;
    end
end

%Function to return the max Charging Current
function Imax = Return_Imax(Temperatur,SoC,batNumCelPll,LookUp)
    Soc_vector=LookUp(:,1);
    T_vector = LookUp(1,:)';
    Soc_vector(1,:)=[];
    T_vector(1,:)=[];
    LookUp(1,:) = [];
    LookUp(:,1) = [];
    LookUp=LookUp*batNumCelPll;
    RestSoC= 100-SoC;%recheck
    if(( Temperatur < -40	) || ( Temperatur > 85 ))
        msg = 'Cell Temperature out of Range in Imax LookUp';
        error(msg)
    end

    if( ( RestSoC < 10 ) || ( RestSoC > 90) )
        msg = 'Cell Capacity out of Range  in Imax LookUp';
        error(msg)
    elseif (RestSoC>15)
        [T  Tindex]=min(abs(T_vector-Temperatur));
        [soc Socindex] = min(abs(Soc_vector-RestSoC));
        Imax = LookUp(Socindex,Tindex);
    else
        [T  Tindex]=min(abs(T_vector-Temperatur));
        [soc Socindex] = min(abs(Soc_vector-RestSoC));
        Imax = LookUp(Socindex+1,Tindex);
    end
end

%Function to return the Capacity correction factor 
function k = Return_K(Temperatur,LookUp)
    T_vector = LookUp(2,:)';

    if(( (Temperatur < -30) || (Temperatur>45) ))
        msg = 'Cell Temperature out of Range in CorrectionLookUp';
        error(msg)
    end
    [T  Tindex]=min(abs(T_vector-Temperatur));
    k = LookUp(1,Tindex);
end


%Function to return the Voltage depending on the SOC 
function V = Return_V(soc,LookUp)
    soc_vector = LookUp(1,:)';

    if(( (soc < 0) || (soc>100) ))
       msg = 'Cell capacity out of Range in ReturnV';
       error(msg)
    end

    [soc  Soc_index]=min(abs(soc_vector-soc/100));
    V = LookUp(2,Soc_index);
end

%Function to calculate Current Charge
function It = calcI(SoC,C,Ri,Rc,NSerie,NPll,P,deltaT,Imax)
    global VoltSoc_LookUp;
    kr = NSerie/NPll;
    Ri=Ri*kr;
    Rc=Rc*kr;
    U0 = Return_V(SoC,VoltSoc_LookUp)*NSerie;
    tmpRC = Rc*(1-exp(-deltaT/(Rc*C)));
    It = U0/(Ri+tmpRC)-sqrt( ( U0/(2*(Ri+tmpRC)) )^2 - (P/Ri));
    if (It>Imax)
        It=Imax;
    elseif It<0
       msg = 'Too Small capacity ||  too Big Step ! => Very high instant current';
       error(msg)
    end 
end

%Function to calculate new SOC
function [soc,It,P,finish] = calcNewSoc(soc,Cmax,T,dt,NumberOfCellsPll,NumberOfCellsSerie,Pmax)
    global Ri_soc_LookUp VoltSoc_LookUp Imax_LookUp;
    Ri = Return_Ri(T,soc,Ri_soc_LookUp);
    Rc = 0.00736 ;% need to recheck
    U0 = Return_V(soc,VoltSoc_LookUp);
    C0=(soc/100)*Cmax;
    Imax = Return_Imax(T,soc,NumberOfCellsPll,Imax_LookUp);
    P=-Imax*U0*NumberOfCellsPll*NumberOfCellsSerie;
    if(abs(P)>abs(Pmax))
        P=-Pmax;
    end
    It = calcI(soc,Cmax,Ri,Rc,NumberOfCellsSerie,NumberOfCellsPll,P,dt,Imax);
    P=-It*U0*NumberOfCellsPll*NumberOfCellsSerie;
    newSoC = (C0+It*dt)*100/Cmax;
    if   round(soc-90) >= 0 
        finish=true;
        C0+It*dt
    else
        finish = false;
    end
    
    
    if(newSoC <= 90)
        soc = newSoC;
    end
end

%Function to return calculated vectors
function [C,I,P] = calcNewSocVector(soc,Cmax,Temperatur,dt,NumberOfCellsPll,NumberOfCellsSerie,Pmax,withplot)
    global TempCorrection_LookUp;
    k = Return_K(Temperatur,TempCorrection_LookUp);
    i=1;
    resolution=0;
    soc = soc*k;
    soc*Cmax/100
    C(i)=soc;
    I(i)=0;
    P(i) = 0;
    finish = false;
    while ~(finish)  
        i=i+1;
        [soc,Imax,Pw,finish] = calcNewSoc(soc,Cmax,Temperatur,dt,NumberOfCellsPll,NumberOfCellsSerie,Pmax);
        resolution = Imax*dt;
        C(i)=soc;
        I(i)=Imax;
        P(i) = Pw;       
    end
    disp('It will take in h ')
    i*dt/3600
    if(withplot)
        figure(1)
        t= (0:dt:dt*(i-1));
        subplot(4,1,1);
        plot(t,C)%graph type
        title('SOC Plot')
        xlabel('Time in s')
        ylabel('SOC in %')
        ylim([0 110])
        xlim([0 dt*(i-1)])  
        subplot(4,1,2);
        plot(t,C/1000*Cmax/100)%graph type
        title('C Plot')
        xlabel('Time in s')
        ylabel('C_i_n in kAs')
        xlim([0 dt*(i-1)])  
        ylim([0.1*Cmax Cmax]/1000)
        subplot(4,1,3);
        plot(t,I)%graph type
        title('I_m_a_x Plot')
        xlabel('Time in s')
        ylabel('I_m_a_x in A')
        xlim([0 dt*(i-1)])  
        %ylim([0 100])
        xlim([0 dt*(i-1)])
        subplot(4,1,4);
        plot(t,-P/1000)%graph type
        title('P (Charger) Plot')
        xlabel('Time in s')
        ylabel('P in kW')
        xlim([0 dt*(i-1)])  
        %ylim([110 210])
    
       
    end
end
