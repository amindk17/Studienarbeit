function [SimulationMatrix,Pges_max, Nmax] = FillBigMatrix2(BusArray,dt,worstCase)
arrtime=datetime('00:00:00','InputFormat','HH:mm:SS');
deptime=datetime('07:00:00','InputFormat','HH:mm:SS');
timediff =etime(datevec(deptime),datevec(arrtime));
dtm=fix(timediff/dt)+1;
[~,sz] =size(BusArray);
SimulationMatrix=zeros(sz+2,dtm);

    for i = 2:sz+1
        if(isempty(BusArray(i-1).ChargeVector))
            txt='some Bus is not simulated';
            error(txt);
        end
        [~,m]=size(BusArray(i-1).ChargeVector);
        for j=1:m
            %t0=BusArray(i-1).ChargingStart;
            %t0=round(t0_list(i-1));
            if worstCase
              Bustime =  BusArray(i-1).Arrival_time;
              bussArrTime=datetime(Bustime,'InputFormat','HH:mm:SS');
              t0 =fix(etime(datevec(bussArrTime),datevec(arrtime))/dt);
            else
              t0 = BusArray(i-1).ChargingStart;
            end
            SimulationMatrix(i,j+t0)=BusArray(i-1).ChargeVector(j);
            if(j+t0)>dtm
                 msg ='not enough t0! Some aBus can not be Charged!';
                 %warning(msg);
%                  disp(i)
%                  error(msg);
                 Nmax=NaN;
                 Pges_max=NaN;
                 return       
            end    
        end
        
    end
    
    for i = 1:dtm
        A=SimulationMatrix(:,i);
        SimulationMatrix(sz+2,i)=sum(A);
        used_chargers = 0;
        for j = 2:sz+1
            if SimulationMatrix(j,i) ~= 0
                used_chargers=used_chargers+1;
            end
        end
        SimulationMatrix(sz+3,i)=used_chargers;
            
    end
    
    SimulationMatrix(1,:)=(0:dt:timediff);
    B=SimulationMatrix(sz+2,:);
    C=SimulationMatrix(sz+3,:);
    Pges_max=max(B);
    Nmax = max(C);
    

end

