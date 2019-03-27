function [ P ] =Opt_function_P( P0 )
global BusArray dt iteration;
    iteration=iteration+1;
    if mod(iteration,10) == 0
        disp('iteration')
        disp(iteration);
    end
    [~,sz] =size(BusArray);
    
    for i = 1:sz
        BusArray(i).CalcP(dt,P0(i),0,'s');
    end
    [~,P,~] = FillBigMatrix2(BusArray,dt,0);
end

