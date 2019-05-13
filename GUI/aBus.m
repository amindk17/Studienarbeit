classdef aBus < handle
    %ABUS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %---- Identifier ----%
        ID='0';
        dt = 0;
        %---- Time Variables ----% 
        Arrival_time=0; 
        Departure_time=0;
        %---- SOC Variables ----% 
        Arrival_SOC=0;
        Departure_SOC=0;
        Battery=aBattery();
        %---- Scheduling Variables ----% 
        ChargeVector;
        Arrival_seconds=0;
        ChargingStart=0;
        ChargingTime=0;
        Pmax=0;
        Pmin=0;
        Peff=1;
        Priority=0;
    end
    
    methods
        %Function to generate some plots
         function CalcP(obj,dt,Pmax,withplot,tunit)
            [~,~,obj.ChargeVector,obj.ChargingTime] = obj.Battery.simulateCharge(dt,Pmax,withplot,tunit);
            obj.ChargeVector=-obj.ChargeVector;
         end
  
    end
end
    


