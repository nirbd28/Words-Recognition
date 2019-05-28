function [frames, step_time] = FramesWithOverLap(speech, fs, frame_time, frame_lap) 
% frame_time - time of every frame
% frame_lap - time of overlap
% step_time - time of steps

step_time=frame_time-frame_lap;

n=length(speech); % n - number of samples 
ts=1/fs; % ts- space between 2 samples in time
tot_time=ts*n; % tot_time - total time of speech

frames=[]; % frame[i,j] i - specific index, j - value

%%% find frames num
frames_num=Get_Frames_Num(step_time, frame_time, tot_time);

speech_i=1; % speech_i - speech index 
for i=1:frames_num % i - frame number i    
j=1; % j- value of the i frame     
  for k=0:ts:frame_time-ts % run for frame_time 
      frames(j,i)=speech(speech_i); 
      if speech_i == n
          break;
      end
      j=j+1;
      speech_i = speech_i +1;
  end 
  speech_i = speech_i - floor(frame_lap*fs); % speech_i -= index overlap
end

end
%%%%%%%%%%

function frames_num=Get_Frames_Num(step_time, frame_time, tot_time)

frames_num=1;
while 1
    end_time=(frames_num-1)*step_time+frame_time; % end of each frame
    if end_time>=tot_time
        break;
    end
    frames_num=frames_num+1;   
end

end