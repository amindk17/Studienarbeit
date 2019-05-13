tic;
clc;clear;
average = 100;
 
list=[10 15 25 86 95 65 80 21 100 1 75 0];

sol2 = find_opt(list,average)

toc;
%Function to return two closest elements to sum
function sol2 = find_opt(list,average)
    j=1;
    [col row] = size(list)
    
    while j <= row/2
        sol = Return_sol(list,average);
        [best,i] = min(abs(sol(3,:)));
        x=find(list==sol(1,i),1);
        y=find(list==sol(2,i),1);
        try
            sol2(1,j)=x;
            sol2(2,j)=y;
            list(x)=NaN;
            list(y)=NaN;
            j=j+1;
        catch exception
            disp('error')
            break
        end
        disp(j)
    end
end
%Function to return two closest elements to sum
function sol = Return_sol(list,average)
    i=1;
    for elm = list
        newlist = elm+list;
        newlist(newlist==2*elm)=NaN;
        [T(i)  Tindex(i)]=min(abs(newlist-average));
        x = elm;
        y = newlist(Tindex(i))-elm;
        delta = x+y-average;
        sol(1,i)=x;
        sol(2,i)=y;
        sol(3,i)=delta;
        i=i+1;
        clc;
    end
end
