%% Subclass of TSpeaker

classdef TMicrophone
    properties
        id              %(string) letter of Microphone [A,B,C]
        recordings      %(Class) contains recordings & estimated times for each speaker
    end

    methods
        function this = TMicrophone()
        this.recordings = [TRecordings() TRecordings() TRecordings() TRecordings() TRecordings() TRecordings()];
        end
    end

end
