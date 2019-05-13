function [ Q ] =Opt_function_P( P0 )
global BusArray dt iteration goal;

    iteration=iteration+1;
    if mod(iteration,2) == 0
        disp('iteration')
        disp(iteration);
    end
    [~,sz] =size(BusArray);
    
    for i = 1:sz
        BusArray(i).CalcP(dt,P0(i),0,'s');
    end
    [~,P,N] = FillBigMatrix(BusArray,dt,1);
    
    if strcmp(goal,'Pmin')
        Q = P;
    elseif strcmp(goal,'Nmin')
        Q = N;    
    else
        msg ='Optimisation Goal can only Be: "Pmin" or "Psmooth" ';
        error(msg);
    end
    
end

