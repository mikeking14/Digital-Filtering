% This function accepts a recording time - time, a filename - filename and
% and a parameter to specify which device to use - ID. SET ID = -1 to use
% the defauls audio device. If you specify a filename that has already been
% used, this function will prompt you for a new filename.

function audioCapture(time, filename, ID)

record_Time = time;
Fs = 44100 ; 
nBits = 16 ; 
nChannels = 1 ; 
recObj = audiorecorder(Fs,nBits,nChannels,ID); % Create recording object

    % Check if the File already exists, if not continue and write to file
    while exist(filename, 'file')
      % File already exists.
      warningMessage = sprintf('Warning: file already exists:\n%s', filename);
      uiwait(msgbox(warningMessage));
      filename = input('Enter a new file name: ','s');
      filename = append('Audio Files/',filename,'.wav')
    end
    
    
    % Audio Device setup
    %info = audiodevinfo; 
    %$deviceReader = audioDeviceReader; % read the devices
    %devices = getAudioDevices(deviceReader); % put the audio devices in an object called devices
    

    pause(2);
    disp('Start speaking.')
    recordblocking(recObj,record_Time);
    disp('End of Recording.');
    play(recObj);
    y = getaudiodata(recObj);

    % Write the recording to a file
    audiowrite(filename,y,Fs); 
end
