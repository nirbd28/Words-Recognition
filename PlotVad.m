function PlotVad(speech, fs, start_time, end_time, file_name)

time_axis = GetTimeAxis(speech, fs);

cla reset;
axis([0 2 min(speech)  max(speech)]);
plot(time_axis,speech);

hold on;
stem(start_time,max(speech),'r','Marker', 'none');
hold on;
stem(end_time,max(speech),'r','Marker', 'none');

temp_x=start_time:1/fs:end_time;
temp_y = zeros(1,length(temp_x));
temp_y=temp_y+max(speech);

plot(temp_x,temp_y,'r');

xlabel('Time[Sec]');
ylabel('Amplitude');
title(file_name);


end