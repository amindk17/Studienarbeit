i=9;
Bus = BusArray(i);

Bus_charge_time = max(size(Bus.Battery.Cmax*Bus.Battery.simP))*dt
K= Bus.Battery.NumberOfCellsPll * Bus.Battery.NumberOfCellsSerie *1/1000%Ri


T = (deltaC*Bus.Battery.Cmax/100)*K*5
