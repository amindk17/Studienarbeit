function [ Pworst ] = CalcWorstCase(Bm)
    [sz,~] =size(Bm);
    Pworst = Bm(sz,:);   
end

