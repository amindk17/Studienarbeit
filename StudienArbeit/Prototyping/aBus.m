classdef aBus < handle
    %ABUS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %---- Identifier ----%
        ID='0';
        %---- Time Variables ----% 
        Arrival_time=0; 
        Departure_time=0;
        %---- SOC Variables ----% 
        Arrival_SOC=0;
        Departure_SOC=0;
        Battery=aBattery();
        %---- Scheduling Variables ----% 
        ChargeVector;
        ChargingStart=0;
        ChargingTime=0;
        Paverage=0;
        Priority=0;
    end
    
    methods
        function calcPav(obj)
            timediff =etime(datevec(obj.Departure_time),datevec(obj.Arrival_time))/3600;
            c_dep =obj.Departure_SOC*obj.Battery.Cmax/100;
            c_arr =obj.Arrival_SOC*obj.Battery.Cmax/100;
            obj.Paverage = (c_dep-c_arr)/timediff;
        end
        %Function to generate some plots
         function CalcP(obj,dt,Pmax,withplot,tunit)
            [~,~,obj.ChargeVector,obj.ChargingTime] = obj.Battery.simulateCharge(dt,Pmax,withplot,tunit);
            obj.ChargeVector=-obj.ChargeVector;
         end
    end
end
    


