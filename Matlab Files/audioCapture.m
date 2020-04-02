%%
% This 

function audioCapture(time, filename)

ID = 3; % Sets which device is used. -1 is default audio input device
record_Time = 10;
Fs = 44100 ; 
nBits = 16 ; 
nChannels = 1 ; 


% Check if the File already exists, if not continue and write to file
if exist(fileName, 'file')
  % File already exists.
  warningMessage = sprintf('Warning: file already exists:\n%s', fileName);
  uiwait(msgbox(warningMessage));
else
    % Audio Device setup
    info = audiodevinfo; %
    deviceReader = audioDeviceReader; % read the devices
    devices = getAudioDevices(deviceReader) % put the audio devices in an object called devices
    

    recObj = audiorecorder(Fs,nBits,nChannels,ID); % Create recording object
    pause(2);
    disp('Start speaking.')
    recordblocking(recObj,record_Time);
    disp('End of Recording.');
    play(recObj);
    y = getaudiodata(recObj);

    % Write the recording to a file
    audiowrite(fileName,y,Fs); 
end
