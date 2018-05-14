
y_limits = ylim;

for i_lines = 1:length(durations)-1
line([sum(durations(1:i_lines))/1000 sum(durations(1:i_lines))/1000],y_limits,'Color',[0 0 0]);
end

ylim(y_limits);