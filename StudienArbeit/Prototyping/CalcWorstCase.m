function [ Pworst ] = CalcWorstCase( BusArray )
    Pworst = 0;
    [~,sz] =size(BusArray);
    for i = 1:sz
        Pworst = Pworst+BusArray(i).Battery.Pmax;
    end    
end

