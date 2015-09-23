%% subclass of TMicrophones

classdef TRecordings
   properties
       fromSpeaker       % (int) from which speaker 
       computedIR        % (float[]) estimated IR from the recording
       recording         % (float[]) actual recording vector
       estimatedTime     % estimated time from speaker to microphone
   end

end
