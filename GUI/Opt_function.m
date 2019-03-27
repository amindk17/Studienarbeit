function Q=Opt_function(start_t0)
    global BusArray0 dt goal iteration;
    disp('iteration')
    iteration=iteration+1;
    disp(iteration);
    [~,sz] =size(BusArray0);
    if strcmp(goal,'Pmin')
        for i = 1:sz
            %start =arrtime + seconds(start_t0(i));
            BusArray0(i).ChargingStart=int32(start_t0(i));
        end
        if isempty(dt)
            msg ='error while using dt global => is empty';
            error(msg);
        end
        [~,P] = FillBigMatrix(BusArray0,dt,0);
        Q = P;
    elseif strcmp(goal,'Psmooth')
        for i = 1:sz
            %start =arrtime + seconds(start_t0(i));
            BusArray0(i).ChargingStart=int32(start_t0(i));
        end
        [~,P] = FillBigMatrix(BusArray0,dt,0);
        Q=max(P)-min(P(P>0));
    else
         msg ='Optimisation Goal can only Be: "Pmin" or "Psmooth" ';
         error(msg);
    end
end
