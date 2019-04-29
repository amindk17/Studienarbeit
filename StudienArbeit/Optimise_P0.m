function [ P ] = Optimise_P0( calcP )
    global BusArrayP
    [~, m] = size(BusArrayP);
    LB=zeros(1,m);
    UB=zeros(1,m);
    for i=1:m
        LB(1,i) =BusArrayP(i).Pmin*2;
        UB(1,i) =BusArrayP(i).Pmin*100;
    end  
    nvars=m;
    %opts = optimoptions(@ga,'PlotFcn',{@gaplotbestf,@gaplotstopping});
    opts = optimoptions(@ga,'PlotFcn',{@gaplotbestf,@gaplotstopping,@gaplotgenealogy}...
    ,'MaxStallGenerations',10,'FunctionTolerance',10,'MaxGenerations',300,'MaxStallTime',30);
    P = ga(calcP,nvars,[],[],[],[],LB,UB,[],opts);


end

