classdef aBattery  < handle
    %ABATTERY a Class to abstract a Battery
    %   Detailed explanation goes here
    
    properties
      %---- BatteryData ----%  
      IDB='0';
      Cmax;
      SOC;
      endSOC;
      Temperatur;
      NumberOfCellsPll;
      NumberOfCellsSerie;
      %---- LookUps ----%
      Ri_soc_LookUp;
      Imax_LookUp;
      VoltSoc_LookUp;
      TempCorrection_LookUp;
      Rc = 0.00736 ;
      %---- SimulationData ----% 
      simC;
      simI;
      simP;
      Pmax;
    end
        
    methods
        %Function to return calculated vectors
        function [C,I,P,T] = simulateCharge(obj,dt,Pmax,withplot,tunit)
            k = obj.Return_K(obj.Temperatur,obj.TempCorrection_LookUp);
            i=1;
            obj.SOC = obj.SOC*k;
            soc=obj.SOC;
            C(i)=obj.SOC;
            I(i)=0;
            P(i) = 0;
            finish = false;
            while ~(finish)  
                i=i+1;            
                if i==10^4
                    msg ='too small time Step dt !';
                    error(msg);
                end
                [soc,Ic,Pw,finish] = obj.calcNewSoc(obj,soc,obj.endSOC,obj.Cmax,obj.Temperatur,dt,obj.NumberOfCellsPll,obj.NumberOfCellsSerie,...
                Pmax,obj.Ri_soc_LookUp,obj.VoltSoc_LookUp,obj.Imax_LookUp); 
                deltaQ = Ic*dt;
                if( logical(exist('deltaQ','var') == 1 ) & (deltaQ > obj.Cmax) )
                    msg ='too Large time Step dt !';
                    error(msg);
                end
                C(i) = soc;
                I(i) = Ic;
                P(i) = Pw;
            end
            [unit,un] = obj.ReturnUnit(tunit);
             try
                dt=str2num(dt);
            catch
            end
            T=i*dt/unit;
            obj.simC=C;
            obj.simI=I;
            obj.simP=P;
            obj.Pmax = max(abs(P));
            if(withplot)
                obj.generatePlot(C,obj.Cmax,I,P,Pmax,dt,unit,un);
            end
               
        
        end
        %Function to generate some plots
        function generatePlot(obj,C,Cmaxx,I,P,Pmax,dt,unit,un)
            name =strcat('Bus ',num2str(obj.IDB));    
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
        %*****************************Help Functions*****************************%
        %Function to calculate new SOC
        function [soc,It,P,finish] = calcNewSoc(obj,soc,endSoc,Cmax,T,dt,NumberOfCellsPll,NumberOfCellsSerie,Pmax,Ri_soc_LookUp,VoltSoc_LookUp,Imax_LookUp)
                    Ri = obj.Return_Ri(T,soc,Ri_soc_LookUp);
                    U0 = obj.Return_V(soc,VoltSoc_LookUp);
                    C0=(soc/100)*Cmax;
                    Imax = obj.Return_Imax(T,soc,NumberOfCellsPll,Imax_LookUp);
                    It = obj.calcI(obj,soc,Cmax,Ri,obj.Rc,NumberOfCellsSerie,NumberOfCellsPll,Pmax,dt,Imax,VoltSoc_LookUp);
                    P=-It*U0*NumberOfCellsPll*NumberOfCellsSerie;
                    if ((Pmax~=0)&(abs(P)>abs(Pmax)))
                        It=Pmax/(U0*NumberOfCellsPll*NumberOfCellsSerie);
                        P=-Pmax;
                    end
                    newSoC = (C0+It*dt)*100/Cmax;
                    if(newSoC <= 90)
                        soc = newSoC(1);
                    end
                    if   round(soc-endSoc) >= 0 
                        finish=true;
                        %disp('final SOC');
                        %disp(C0+It*dt);
                    else
                        finish = false;
                    end


                end

        %Function to calculate Current Charge
        function It = calcI(obj,SoC,C,Ri,Rc,NSerie,NPll,P,deltaT,Imax,VoltSoc_LookUp)
            kr = NSerie/NPll;
            Ri=Ri*kr;
            Rc=Rc*kr;
            U0 = obj.Return_V(SoC,VoltSoc_LookUp)*NSerie;
            tmpRC = Rc*(1-exp(-deltaT/(Rc*C)));
            term1= U0/(2*(Ri+tmpRC(1)));
            term2=(P/Ri);
            if ( (term1)^2 > (P/Ri))
                It = U0/(Ri+tmpRC)-sqrt( ( term1 )^2 - term2);
            else
                It = Imax;
            end
            if (It>Imax)
                It=Imax;
            elseif It<0
               msg = 'Too Small capacity ||  too Big Step ! => Very high instant current';
               error(msg)
            end 
        end

        %Function to return the Voltage depending on the SOC in %
        function V = Return_V(soc,LookUp)
            soc_vector = LookUp(1,:)';
            v_vector=LookUp(2,:)';
            if(( (soc < 0) || (soc>100) ))
               msg = 'Cell capacity out of Range in ReturnV';
               error(msg)
            end
            V=interp1(soc_vector,v_vector,soc/100);
         end

        %Function to return the Capacity correction factor
        function k = Return_K(Temperatur,LookUp)
            T_vector = LookUp(2,:)';
            K_vector = LookUp(1,:)';

            if(( (Temperatur < -30) || (Temperatur>45) ))
                msg = 'Cell Temperature out of Range in CorrectionLookUp';
                error(msg)
            end
            k=interp1(T_vector,K_vector,Temperatur);
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
            RestSoC= 100-SoC;
            if(( Temperatur <= -40	) || ( Temperatur >= 85 ))
                msg = 'Cell Temperature out of Range in Imax LookUp';
                error(msg)
            end
            if( (RestSoC < 0) || (RestSoC>100) )
                msg = 'Cell Capacitiy out of Range in Imax LookUp';
                error(msg)
            else
                %Ri=interp2(T_vector,Soc_vector,LookUp',Temperatur,SoC)
                Imax=interp2(Soc_vector,T_vector,LookUp',RestSoC,Temperatur);   
            end
        end

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
                Ri=interp2(T_vector,Soc_vector,LookUp',Temperatur,SoC);
            end
        end
        
        
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
