function [ Pworst ] = CalcWorstCase(Bm)
    [sz,~] =size(Bm);
    Pworst = Bm(sz-1,:);   
end

