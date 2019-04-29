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
    IntCon=m;
    %opts = optimoptions(@ga,'PlotFcn',{@gaplotbestf,@gaplotstopping,@gaplotgenealogy});
    opts = optimoptions(@ga,'PlotFcn',{@gaplotbestf,@gaplotstopping,@gaplotgenealogy}...
    ,'MaxStallGenerations',10,'FunctionTolerance',10,'MaxGenerations',300,'MaxStallTime',30);
    opt_t0 = ga(calcP,nvars,[],[],[],[],LB,UB,[],IntCon,opts);
    opt_t0=int64(opt_t0);

end

