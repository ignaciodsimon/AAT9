% Class for speaker

classdef TSpeaker
    
    properties
        width         %(float) width of the speaker
        height        %(float) height of the speaker
        position      %(float,float) position in space
        orientation   %(float) angle of speaker
        id            %(int) ID number 
        microphones   %(class) contains information about microphones
    end

    methods
        function this=TSpeaker()
                this.microphones = [TMicrophone() TMicrophone() TMicrophone()];
        end
    end
end
