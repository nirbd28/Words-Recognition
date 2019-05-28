function frame_axis = GetFrameAxis(frames, step_time)

[~,n]=size(frames); % n -number of frames
frame_axis=0:step_time:n*step_time-step_time;

end