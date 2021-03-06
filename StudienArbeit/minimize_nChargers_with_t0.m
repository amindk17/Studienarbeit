function [success] = minimize_nChargers_with_t0(BusArr,Nmax_soll,arrtime,deptime,withplot)
%MINIMIZE_NCHARGERS Summary of this function goes here
%   Detailed explanation goes here

%*****************************Generate Test Data*****************************%
global BusArray dt;
BusArray = BusArr;
goal = 'Nmin';
[~,nr_bus] =size(BusArray);

for i=1:nr_bus
   %BusArray(i).CalcP(dt,45000,0,'s');
   start_time=abs(etime(datevec(arrtime),datevec(BusArray(i).Arrival_time)));
   BusArray(i).ChargingStart=start_time;
   BusArray(i).Arrival_seconds = start_time;
end


%*****************************Run Optimiser*****************************%
%------------------------------------------%
[Bm,~,~]=FillBigMatrix(BusArray,dt,1);
Power_before=CalcWorstCase(Bm); 
Bm_before = Bm;
[~,sizeBigM ] = size(Bm);
global goal;

opt_t0 = Optimise_t0(@Opt_function,BusArray,dt,arrtime);

[Bm_after,Pges_max,Nmax]=FillBigMatrix(BusArray,dt,0);

for i=1:nr_bus
     BusArray(i).ChargingStart=double(opt_t0(i)*dt);
end 
if withplot 
    plot_P(Bm_after,Power_before,1);
    newBarplot2(BusArray,1,Bm_after,Bm_before)
else
end
if Nmax_soll < Nmax
    success = 0;
else
    success = 1;
end
end

