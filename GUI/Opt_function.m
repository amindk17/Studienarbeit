function Q=Opt_function(start_t0)
    global BusArray dt goal iteration;
    iteration=iteration+1;
    if mod(iteration,10) == 0
        disp('iteration')
        disp(iteration);
    end
    
    
    [~,sz] =size(BusArray);
    if strcmp(goal,'Pmin')
        for i = 1:sz
            %start =arrtime + seconds(start_t0(i));
            BusArray(i).ChargingStart=int32(start_t0(i));
        end
        [~,P,~] = FillBigMatrix(BusArray,dt,0);
        Q = P;
    elseif strcmp(goal,'Psmooth')
        for i = 1:sz
            %start =arrtime + seconds(start_t0(i));
            BusArray(i).ChargingStart=int32(start_t0(i));
        end
        [~,P,~] = FillBigMatrix(BusArray,dt,0);
        Q=max(P)-min(P(P>0));
     elseif strcmp(goal,'Nmin')
        for i = 1:sz
            %start =arrtime + seconds(start_t0(i));
            BusArray(i).ChargingStart=int32(start_t0(i));
        end
        [~,~,N] = FillBigMatrix(BusArray,dt,0);
        Q=N    
    else
         msg ='Optimisation Goal can only Be: "Pmin" or "Psmooth" ';
         error(msg);
    end
end
