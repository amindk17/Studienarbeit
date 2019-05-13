function [Energie_stored,Energie_grid] = CalC_Energie(Bus,Wirkungsgrad,V_Table)
global dt
%_________Stored in Batt _________
Cmax = Bus.Battery.Cmax;
deltaC = max(Bus.Battery.simC)-min(Bus.Battery.simC);
Ah = deltaC*Cmax/(3600*100); % convert As to Ah the added Energie
ser = Bus.Battery.NumberOfCellsSerie;
V= aBattery.Return_V(max(Bus.Battery.simC),V_Table);
V_tot = V*ser;
Energie_stored = Ah *ser*V/1000; % Calculate P in kWh

%_________from Grid _________
Pv = abs(Bus.Battery.simP);
T  = 0:dt:dt*(max(size(Pv))-1) ;
Energie_grid = trapz(T, Pv) /(3600*1000)*1/Wirkungsgrad; %convert to kWh
end

