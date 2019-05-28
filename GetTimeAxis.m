function time_axis = GetTimeAxis(speech, fs)

speech_time=length(speech)/fs;
time_axis=0:1/fs:speech_time-1/fs;

end