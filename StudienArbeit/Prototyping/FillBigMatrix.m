function [SimulationMatrix,Pges_max] = FillBigMatrix(BusArray,dt,t0_list)
arrtime=datetime('00:00:00','InputFormat','HH:mm:SS');
deptime=datetime('06:00:00','InputFormat','HH:mm:SS');
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
            t0=round(t0_list(i-1));
            SimulationMatrix(i,j+t0)=BusArray(i-1).ChargeVector(j);
            if(j+t0)>dtm
                 msg ='too Large start vector t0 !';
                 error(msg);
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

