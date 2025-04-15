var exec = require('cordova/exec');

exports.startSilentAudio = function(success, error) {
    exec(success, error, 'CDVSilentAudioPlugin', 'startSilentAudio', []);
};

exports.pauseSilentAudio = function(success, error) {
    exec(success, error, 'CDVSilentAudioPlugin', 'pauseSilentAudio', []);
};

exports.stopSilentAudio = function(success, error) {
    exec(success, error, 'CDVSilentAudioPlugin', 'stopSilentAudio', []);
};
