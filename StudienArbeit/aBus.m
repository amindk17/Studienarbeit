classdef aBus < handle & aBattery
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
        ChargingStart=0;
        ChargingTime=0;
        Paverage=0;
        Priority=0;
    end
    
    methods
        function calcPav(obj)
             obj.Paverage = (obj.Departure_SOC-obj.Arrival_SOC)/...
                            (obj.Departure_time-obj.Arrival_time);
        end
   %Function to generate some plots
        function generatePlot(obj,Pmax,dt,tunit)
            [unit,un] = obj.ReturnUnit(tunit);
            bat=obj.Battery;
            Cmaxx=bat.Cmax;
            [bat.simC,bat.simI,bat.simP]=bat.simulateCharge(dt,Pmax,0,tunit);
            C=bat.simC;
            I=bat.simI;
            P=bat.simC;
            name =strcat('Bus ',num2str(obj.ID));    
            figure('name',name)
            [~,i]=size(C);
            %____________ Time 
            t= (0:dt:dt*(i-1));
            t=t/unit;
            dt=dt/unit;
            %____________ Soc Plot
            subplot(4,1,1);
            plot(t,C)%graph type
            title('SOC Plot')
            xlabel(strcat('Time in ',{' '},un))
            ylabel('SOC in %')
            ylim([0 110])
            xlim([0 dt*(i-1)])
            %____________ C Plot
            subplot(4,1,2);
            plot(t,C*Cmaxx/(100*1000))%graph type
            title('C Plot')
            xlabel(strcat('Time in ',{' '},un))
            ylabel(strcat('C_i_n in kA',un))
            xlim([0 dt*(i-1)])  
            ylim([0.1*Cmaxx Cmaxx]/1000)
            %____________ I Plot
            subplot(4,1,3);
            plot(t,I)%graph type
            title('I_m_a_x Plot')
            xlabel(strcat('Time in ',{' '},un))
            ylabel('I_m_a_x in A')
            xlim([0 dt*(i-1)])  
            %ylim([0 100])
            %____________ P Plot
            ax4 = subplot(4,1,4);
            cla(ax4);
            hold(ax4,'on');
            p1 = plot(t,-P/1000);%graph type      
            p2 = plot(t,Pmax*ones(size(t))/1000);
            legend([p1 p2],{'Pab','Pmax'})
            title('P (Charger) Plot')
            xlabel(strcat('Time in ',{' '},un))
            ylabel('P in kW')
            xlim([0 dt*(i-1)])
            hold(ax4,'off');
            refreshdata
            %ylim([110 210])
        end
    end
    methods(Static)
        %Function to convert time units
        function [unit,un]=ReturnUnit(tunit)
            if strcmp(tunit,'s')
                unit = 1;
                un = 's';
            elseif strcmp(tunit,'h')
                unit = 3600;
                un = 'h';
            elseif strcmp(tunit,'min')
                unit = 60;
                un = 'min';
            else
                msg = 'time unit should be "h" "min" or "s"  ';
                error(msg);
            end
        end
     end
end
    


