# Digital-Filtering
This matlab script will capture a specified amount of audio (time) and
store that audio in a file within the Audio Files folder. If a file with
the specified filename already exists, it will prompt the user for
another filename. Next, this script will analyse the audio, plotting the
audio in the time and frequency domain. The script then adds
noise to the audio file, and filters that noise using two kaiser windowed 
low pass filters. Two filters are used so that two Kaiser windows of 
different shape can be applied to the filters, hence improving the 
quality of the filter. Next, the two kaiser windows are plotted, 
overlapped in the time and frequency domain, so that we may better 
visualize them. Additionally, plots of regular audio, and filtered audio
are plotted together.
