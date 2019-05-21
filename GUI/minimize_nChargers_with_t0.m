function [Pges_max,Nmax] = minimize_nChargers_with_t0(BusArr,Nmax_soll,arrtime,deptime,withplot)
%MINIMIZE_NCHARGERS Summary of this function goes here
%   Detailed explanation goes here

%*****************************Generate Test Data*****************************%
global BusArray dt goal;
BusArray = BusArr;
goal = 'Nmin';
[~,nr_bus] =size(BusArray);

%*****************************Run Optimiser*****************************%
%------------------------------------------%
[Bm,~,~]=FillBigMatrix(BusArray,dt,1);
Power_before=CalcWorstCase(Bm); 
Bm_before = Bm;
[~,sizeBigM ] = size(Bm);

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

end

