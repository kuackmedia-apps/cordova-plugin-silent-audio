var exec = require('cordova/exec');

exports.startSilentAudio = function (success, error) {
    exec(success, error, 'SilentAudioPlugin', 'startSilentAudio', []);
};

exports.stopSilentAudio = function (success, error) {
    exec(success, error, 'SilentAudioPlugin', 'stopSilentAudio', []);
};