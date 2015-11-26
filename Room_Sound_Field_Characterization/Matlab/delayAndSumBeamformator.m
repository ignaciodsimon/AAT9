function [thirdOctaveBands, freqbands] = delayAndSumBeamformator(mic1, mic3, focus_point, spk_position, orientation, c, fs)
%This function performs a naive and simple beamformator on data from the same array
%Input is mic1, mic2, focus point, spk_position, orientation, c, fs 

d = 0.127 / 2;

        filterLength = 200;
    centerTap = filterLength / 2 ;



%Perform rotation to mic1 and mic3 around speaker location(mic 2 location)
% mic1_position = [  (spk_position(1) - d) * cos(orientation*pi/180) - spk_position(2) * sin(orientation*pi/180) ,...
%                         (spk_position(1) - d) * sin(orientation*pi/180) + spk_position(2) * cos(orientation*pi/180)];
% mic3_position = [  (spk_position(1) + d) * cos(orientation*pi/180) - spk_position(2) * sin(orientation*pi/180)   ,...
%                         (spk_position(1) + d) * sin(orientation*pi/180) + spk_position(2) * cos(orientation*pi/180)];

%Perform rotation to mic1 and mic3 around speaker location(mic 2 location)
%in radians
mic1_position = [  (spk_position(1) - d) * cos(orientation) - spk_position(2) * sin(orientation) ,...
                        (spk_position(1) - d) * sin(orientation) + spk_position(2) * cos(orientation)];
mic3_position = [  (spk_position(1) + d) * cos(orientation) - spk_position(2) * sin(orientation)   ,...
                        (spk_position(1) + d) * sin(orientation) + spk_position(2) * cos(orientation)];



x = focus_point(1);
y = focus_point(2);

%calculate distances from focus_points to mic1 and mic2 position
distance_focus_mic1 = sqrt( ( x - mic1_position(1) )^2 + ( y - mic1_position(2) )^2 );
distance_focus_mic3 = sqrt( ( x - mic3_position(1) )^2 + ( y - mic3_position(2) )^2 );

%convert to time delays
delay_focus_mic1 = distance_focus_mic1 / c;
delay_focus_mic3 = distance_focus_mic3 / c;

%convert time to sample delay
delay_sample_mic1 = delay_focus_mic1 * fs;
delay_sample_mic3 = delay_focus_mic3 * fs; 



%calculate relative delay according to the closest microphone and 
%negativily delay the microphone furthest away

if delay_sample_mic1 < delay_sample_mic3
    
    %apply delay so that mic1 and mic3 would align if focuspoint =
    %sourcepoint in space
    
    relative_delay = delay_sample_mic3 - delay_sample_mic1;
    frac_delay = relative_delay - floor(relative_delay);
%     filterLength = floor(relative_delay);
%     centerTap = filterLength / 2;
%     
%     filterLength = 101
%     centerTap = floor(relative_delay)
%     filterLength = 2000
%     centerTap = filterLength / 2    
%     
%         filterLength = 30
%     centerTap = filterLength / 2 
    %now make sinc filter with these parameters
    
        %generate sinc filter for mic3 and hanning window it
        for i = 1:filterLength
            x = i - frac_delay;
            sincfilter(i) = sin( pi * ( x - centerTap )) / ( pi * (x - centerTap) );
            hann_window = 0.5 * ( 1 - cos( (2*pi*i) / ( filterLength - 1 ) ));
            sincfilter(i) = sincfilter(i) * hann_window;
        end

        
            sincfilter = sincfilter((centerTap - floor(relative_delay) + 1):length(sincfilter));

    %apply fractional delay filter to desired signal
    frac_delayed_mic1 = conv(sincfilter,mic1);
%     length(frac_delayed_mic1)
%     length(mic3)
%     delayed_mic1 = mic1(1:length(mic1)-floor(relative_delay));
%     delayed_mic1 = [zeros(1,floor(relative_delay)) delayed_mic1];
%     
    mic3 = [mic3 ; zeros(length(frac_delayed_mic1)-length(mic3),1)];
    summation = mic3 + frac_delayed_mic1;
%     
%     hold on
%     plot(mic1)
%     plot(mic3)
%     plot(delayed_mic1)
%     plot(frac_delayed_mic1)
%     legend('mic1','mic3','delayed mic1','frac delayed mic1')

    
    [thirdOctaveBands, freqbands] = oct3bank(summation);

    %Plot filter
    
%     plot(sincfilter)
%     grid on

elseif delay_sample_mic3 < delay_sample_mic1
    
    %apply delay so that mic1 and mic3 would align if focuspoint =
    %sourcepoint in space
    
    relative_delay = delay_sample_mic1 - delay_sample_mic3;
    frac_delay = relative_delay - floor(relative_delay);
%     filterLength = floor(relative_delay)+1
%     centerTap = filterLength / 2;
% %     
%     filterLength = 101
%     centerTap = floor(relative_delay)
%     filterLength = 30
%     centerTap = filterLength / 2   

%now make sinc filter with these parameters
    
        %generate sinc filter for mic3 and hanning window it
        for i = 1:filterLength
            x = i - frac_delay;
            sincfilter(i) = sin( pi * ( x - centerTap )) / ( pi * (x - centerTap) );
            hann_window = 0.5 * ( 1 - cos( (2*pi*i) / ( filterLength - 1 ) ));
            sincfilter(i) = sincfilter(i) * hann_window;
        end
        
        
    sincfilter = sincfilter((centerTap - floor(relative_delay) + 1):length(sincfilter));
    %apply fractional delay filter to desired signal
    frac_delayed_mic3 = conv(sincfilter,mic3);
%     fra = length(frac_delayed_mic3)
%     raw = length(mic1)
%     fra - raw
% %     delayed_mic3 = mic3(1:length(mic3)-floor(relative_delay));
% %     delayed_mic3 = [zeros(1,floor(relative_delay)) delayed_mic3];
% size(mic1)

% zeropad to make the signal even lengths for summation
mic1 = [mic1 ; zeros(length(frac_delayed_mic3)-length(mic1),1)];
%     raw1 = length(mic1)

summation = mic1 + frac_delayed_mic3;

[thirdOctaveBands, freqbands] = oct3bank(summation);
% plot(bands)
%     %plot filter
% %     plot(sincfilter)
% %     grid on
%     hold on
%     plot(mic1)
%     plot(mic3)
% %     plot(delayed_mic3)
%     plot(frac_delayed_mic3)
%     legend('mic1','mic3','delayed mic3','frac delayed mic3')
% plot(summation)    
else
    
    disp('Focus point and source point are the same.')
    
end
    


%make the two signals the same length by zero padding
% if length(mic1) < length(mic3)
%     mic1 = [mic1 zeros(1,length(mic3) - length(mic1))];
% elseif length(mic3) < length(mic1)
%     mic3 = [mic3 zeros(1,length(mic1) - length(mic3))];
% else
%     disp('Microphone signals are the same length -> No zeropadding')
% end

%sum the two signals

% summation = mic1 + mic3;
% 
% figure(2)
% plot(summation)
% 
% %Save the power in 1/3 octave bands
% bands = oct3bank(summation);
% figure(3)
% plot(bands)



































% if delay_sample_mic1 < delay_sample_mic3
%     
%     relative_delay_on_mic3 = delay_sample_mic3 - delay_sample_mic1;
%     
%     %compute fractional delay
%     frac_delay_mic3 = relative_delay_on_mic3 - floor(relative_delay_on_mic3);
% 
%     %Filter order and center tap
%     filterLength = floor(relative_delay_on_mic3);
%     centerTap = filterLength / 2;
%     
%     %generate sinc filter for mic3 of length M and hanning window
%         for i = 1:filterLength
%             x_mic3 = i - frac_delay_mic3;
%             sinc_mic3(i) = sin( pi * ( x_mic3 - centerTap )) / ( pi * (x_mic3 - centerTap) );
%             hann_window = 0.5 * ( 1 - cos( (2*pi*i) / ( filterLength - 1 ) ));
%             sinc_mic3_hann(i) = sinc_mic3(i) * hann_window;
%         end
%     
%     delayed_mic3 = mic3(floor(relative_delay_on_mic3):length(mic3));
%     frac_delayed_mic3 = conv(sinc_mic3_hann, mic3);
% %     frac_delayed_mic3 = conv(mic3,sinc_mic3_hann);
% 
% elseif delay_sample_mic3 < delay_sample_mic1
%     
%     relative_delay_on_mic1 = delay_sample_mic1 - delay_sample_mic3;
%     
%     %compute fractional delay
%     frac_delay_mic1 = relative_delay_on_mic1 - floor(relative_delay_on_mic1);
% 
%     %Filter order and center tap
%     filterLength = floor(delay_sample_mic1); 
%     centerTap = filterLength / 2;
%     
%     %generate sinc filter for mic1 of length M and hanning window
%         for i = 1:filterLength
%             x_mic1 = i - frac_delay_mic1;
%             sinc_mic1(i) = sin( pi * ( x_mic1 - centerTap )) / ( pi * (x_mic1-centerTap) );
%             hann_window = 0.5 * ( 1 - cos( (2*pi*i) / ( filterLength - 1 ) ));
%             sinc_mic1_hann(i) = sinc_mic1(i) * hann_window;
%         end
% 
%     delayed_mic1 = mic1(floor(relative_delay_on_mic1):length(mic1));
%     frac_delayed_mic1 = conv(sinc_mic1_hann,mic1);
%     
% end























% 
% hold on
% plot(mic1)
% plot(mic3)
% plot(delayed_mic1)
% plot(frac_delayed_mic1)
% legend('mic1','mic3','delayed_mic1','frac_delayed_mic1')


% hold on
% plot(mic1)
% plot(mic3)
% plot(delayed_mic3)
% plot(frac_delayed_mic3)
% legend('mic1','mic3','delayed mic3','frac delayed mic3')



    
    
    
    
    
    
    


end