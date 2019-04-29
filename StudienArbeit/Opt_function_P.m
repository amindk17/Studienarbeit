function [ P ] =Opt_function_P( P0 )
global BusArrayP dt iteration;
    iteration=iteration+1;
    if mod(iteration,10) == 0
        disp('iteration')
        disp(iteration);
    end
    [~,sz] =size(BusArrayP);
    
    for i = 1:sz
        BusArrayP(i).CalcP(dt,P0(i),0,'s');
    end
    [~,P,~] = FillBigMatrix(BusArrayP,dt,1);
end

