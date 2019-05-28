function frames = Frames(speech, fs, frame_time) 

n=length(speech); % n - number of samples 
ts=1/fs; % ts- space between 2 samples in time
tot_time=ts*n; % tot_time - total time of speech

frames=[]; % frame[i,j] i - specific index, j - value

frames_num = floor(tot_time/frame_time); % frames_num- number of frames 

speech_i=1; % speech_i - speech index 
for i=1:frames_num % i - frame number i    
j=1; % j- value of i frame     
  for k=0:ts:frame_time % run for frame_time 
      frames(j,i)=speech(speech_i); 
      if speech_i == n
          break;
      end
      j=j+1;
      speech_i = speech_i +1;
  end          
end

end
