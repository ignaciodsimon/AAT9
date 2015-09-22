
%% subclass of TMicrophones


classdef TRecordings
   properties
       from_speaker % (int) from which speaker 
       recording    % (float[]) actual recording vector
       est_time     % estimated time from speaker to microphone
   end
   
end