
% Class for speaker


classdef TSpeaker
    
    properties
        position      %(float,float) position in space
        orientation   %(float) angle of speaker
        ID            %(int) ID number 
        MicA          %(class) contains information about microphones
        MicB
        MicC
    end
    
    methods
        function this=TSpeaker()
                this.MicA = TMicrophone();
                this.MicB = TMicrophone();
                this.MicC = TMicrophone();
        end
    end
end

