function speech = Record(fs, record_time)

a = audiorecorder(fs,16,2);
record(a,record_time);
pause(record_time);

speech=getaudiodata(a);

speech=CorrectSpeechSize(speech);

end