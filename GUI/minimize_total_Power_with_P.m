function [success] = minimize_total_Power_with_P(BusArr,Pmax_soll,arrtime,deptime,withplot)
%MINIMIZE_NCHARGERS Summary of this function goes here
%   Detailed explanation goes here

%*****************************Generate Test Data*****************************%
global BusArray dt goal
BusArray = BusArr;
goal = 'Pmin';
[~,nr_bus] =size(BusArray);

% for i=1:nr_bus
%    start_time=abs(etime(datevec(arrtime),datevec(BusArrayP(i).Arrival_time)));
%    BusArrayP(i).ChargingStart=start_time;
%    BusArrayP(i).Arrival_seconds = start_time;
%    all_time = abs(etime(datevec(BusArrayP(i).Arrival_time),datevec(BusArrayP(i).Departure_time)));
%    all_time = round(all_time);
%    [Energie_stored, Energie_grid] = CalC_Energie(BusArrayP(i),0.96,VoltSoc_LookUp);
%    Pm = (Energie_grid*1000*3600)/(all_time) ;
%    BusArrayP(i).Pmin=Pm;
% end

%------------------------------------------%
[Bm,~,~]=FillBigMatrix(BusArray,dt,1);
Bm_before = Bm;
BusArray_Before = zeros(2,nr_bus);
for i=1:nr_bus
    BusArray_Before(1,i)=BusArray(i).ChargingStart;
    BusArray_Before(2,i)=BusArray(i).ChargingTime;
end
Power_before=CalcWorstCase(Bm); 
[~,sizeBigM ] = size(Bm);
opt_p = Optimise_P0(@Opt_function_P);

for i=1:nr_bus
     BusArray(i).CalcP(dt,opt_p(i),0,'s');
     BusArray(i).Pmax = int64(opt_p(i));
end  
[Bm_after,Pges_max,Nmax]=FillBigMatrix(BusArray,dt,1);
BusArray_After =  repmat(BusArray,1);

if withplot 
    plot_P(Bm_after,Power_before,1);
    newBarplot3(BusArray_Before,BusArray_After,1,Bm_after,Bm_before)
else
end

if Pmax_soll < abs(Pges_max)/10^3
    success = 0;
else
    success = 1;
end

end

function b = copyobj(a)
   b = eval(class(a));  %create default object of the same class as a. one valid use of eval
   for p =  properties(a).'  %copy all public properties
      try   %may fail if property is read-only
         b.(p) = a.(p);
      catch
         warning('failed to copy property: %s', p);
      end
   end
end

