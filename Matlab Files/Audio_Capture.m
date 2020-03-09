%%
% This file will record audio from the selected device, and store that audio
% in the name of a the file specified below. 

ID = -1; % Sets which device is used. -1 is default audio input device
Fs = 44100 ; 
nBits = 16 ; 
nChannels = 1 ; 
fileName = 'tuning_forker2.wav'

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
    disp('Start speaking.')
    pause(2);
    recordblocking(recObj,5);
    disp('End of Recording.');
    play(recObj);
    y = getaudiodata(recObj);

    % Write the recording to a file
    audiowrite(fileName,y,Fs); 
end
