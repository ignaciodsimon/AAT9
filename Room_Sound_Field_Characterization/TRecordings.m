%% subclass of TMicrophones

classdef TRecordings
   properties
       fromSpeaker % (int) from which speaker 
       recording    % (float[]) actual recording vector
       estimatedTime     % estimated time from speaker to microphone
   end

end
