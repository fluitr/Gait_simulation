function output = InterpToEvents(y,events,duration)
% y is the signal to interpolate
% events is the index of the start of a new event
% Duration is the mean amount of indices of an event

yI = [];

for i1 = 1:length(events)-1
    %Interpolating to: 
    cind = events(i1):events(i1+1)-1;
    
    %Data 
    cind2 = 1:length(y);
    
    y1 = interp1(cind2,y,linspace(cind(1),cind(end),duration(i1)))';
    [r,k] = size(y1);
    if r<k
        yI = [yI y1];
    else
        yI = [yI y1'];
    end
    
    
end
output = yI;

end
