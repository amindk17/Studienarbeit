function [SimulationMatrix,Pges_max] = BigMatr(BusArray,dt,worstCase)
arrtime=datetime('00:00:00','InputFormat','HH:mm');
deptime=datetime('07:00:00','InputFormat','HH:mm');
timediff =etime(datevec(deptime),datevec(arrtime));
try
    dt=str2num(dt);
catch
end
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
              bussArrTime=datetime(Bustime,'InputFormat','HH:mm');
              t0 =fix(etime(datevec(bussArrTime),datevec(arrtime))/dt);
            else
              t0 = BusArray(i-1).ChargingStart;
            end
            SimulationMatrix(i,j+t0)=BusArray(i-1).ChargeVector(j);
            if(j+t0)>dtm
                 msg ='not enough t0! Some aBus can not be Charged!';
                 %warning(msg);
                 error(msg);
                 %Pges_max=Inf;
                 
            end    
        end
    end
    
    for i = 1:dtm
        A=SimulationMatrix(:,i);
        SimulationMatrix(sz+2,i)=sum(A);
    end
    B=SimulationMatrix(sz+2,:);
    Pges_max=max(B);
    SimulationMatrix(1,:)=(0:dt:timediff);
    

end

