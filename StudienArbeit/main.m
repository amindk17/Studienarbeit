clc; clear ; 

%to Solve input power Problem%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Temperatur = 0;                 % Temperatur in C
soc = 15;                       % initial SOC in %
Cmax = 20*10^3;                % Capacity in A*Unit
NumberOfCellsPll = 4;           % Number of Paralell Cells
NumberOfCellsReihe=100 ;        % Number of Serie Cells
Rc = 0.00736;                   % Rc in Ohm (!!!! recheck !!!!)
dt=1;                           % in Unit
pmax=100*10^3;                  % Charger input Power in W
ploty=1;                        % 1 means generate plots , 0 no  
Unit  = 's';                  % 's' 'min' or 'h'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%calculate charge vector
[C,I,P]= calcNewSocVector(soc,Cmax,Temperatur,dt,NumberOfCellsPll,NumberOfCellsReihe,pmax,ploty,Unit);%%%%%%%%%%%%%%
E=C*Cmax;