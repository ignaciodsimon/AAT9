
%% Subclass of TSpeaker


classdef TMicrophone
    properties
        ID              %(string) letter of Microphone [A,B,C]
        Recordings      %(Class) contains recordings & estimated times for each speaker
    end
    
    methods 
        function this=TMicrophone()
        this.Recordings = TRecordings();
        end
    end
   
end