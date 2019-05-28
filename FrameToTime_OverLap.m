function time = FrameToTime_OverLap(frame ,frame_time, frame_lap)
    time=(frame-1)*(frame_time-frame_lap);
end