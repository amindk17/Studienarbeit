function [ P ] = Optimise_P0( calcP )
    global BusArray
    [~, m] = size(BusArray);
    LB=zeros(1,m);
    UB=zeros(1,m);
    for i=1:m
        LB(1,i) =BusArray(i).Pmax/10;
        UB(1,i) =BusArray(i).Pmax;
    end  
    nvars=m;
    opts = optimoptions(@ga,'PlotFcn',{@gaplotbestf,@gaplotstopping});
    P = ga(calcP,nvars,[],[],[],[],LB,UB,[],opts);


end

