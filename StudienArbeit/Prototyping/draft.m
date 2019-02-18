a=hours(returnRandomTime(1,6));
b=hours(returnRandomTime(1,6));
c=hours(returnRandomTime(1,6))
d=hours(returnRandomTime(1,6))
Y = [a,b
     c,d];
 
figure
h=barh(Y,'stacked')
h(1).FaceColor = 'white'; % color


function time = returnRandomTime(hmin,hmax)
    h1=sprintf('%02d',randi([hmin hmax],1));
    m1=sprintf('%02d',randi([0 59],1));
    s1='00';
    time = strcat(h1,':',m1,':',s1);
    time=datetime(time,'InputFormat','HH:mm:SS');
    
end