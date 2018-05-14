function output = InterpToEvents(y,t,events,duration)
yI = [];

for i1 = 1:length(events)-1
    y1 = interp1(t(t>=events(i1) & t <= events(i1+1)),y(:,t>=events(i1) & t <= events(i1+1))',...
        linspace(events(i1),events(i1+1),duration(i1)))';
    [r,k] = size(y1);
    if r<k
        yI = [yI y1];
    else
        yI = [yI y1'];
    end
    
    
end
output = yI;

end
