function opt_t0 = Optimise_t0(calcP,BusArray,dt,arrTime)
    [~, m] = size(BusArray);
    LB=zeros(1,m);
    UB=zeros(1,m);
    for i=1:m
        bussArrTime=datetime(BusArray(i).Arrival_time,'InputFormat','HH:mm:SS');
        bussDepTime=datetime(BusArray(i).Departure_time,'InputFormat','HH:mm:SS');
        LB(1,i) =int32(fix(etime(datevec(bussArrTime),datevec(arrTime))/dt));
        UB(1,i) =int32(fix(etime(datevec(bussDepTime),datevec(arrTime))/dt))-BusArray(i).ChargingTime/dt;
    end  
    nvars=m;
    %LB=[0 0 0];
    %UB=[m-m1-1 m-m2-1 m-m3-1];
    IntCon=m;
    opt_t0 = ga(calcP,nvars,[],[],[],[],LB,UB,[],IntCon);
    opt_t0=int64(opt_t0);

end

