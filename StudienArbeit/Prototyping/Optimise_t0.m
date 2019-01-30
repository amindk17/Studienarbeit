function opt_t0 = Optimise_t0(calcP,BusArray,sizeBigM)
    [~, m] = size(BusArray);
    LB=zeros(1,m);
    UB=zeros(1,m);
    for i=1:m
        [~,a]=size(BusArray(i).ChargeVector);
        UB(1,i)=sizeBigM-a-1;
    end  
    nvars=m;
    %LB=[0 0 0];
    %UB=[m-m1-1 m-m2-1 m-m3-1];
    IntCon=m;
    opt_t0 = ga(calcP,nvars,[],[],[],[],LB,UB,[],IntCon);
    opt_t0=int64(opt_t0);

end

