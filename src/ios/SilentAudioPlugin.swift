import Foundation

@objc(SilentAudioPlugin) class SilentAudioPlugin: CDVPlugin {

    @objc(startSilentAudio:)
    func startSilentAudio(command: CDVInvokedUrlCommand) {
        SilentAudioManager.shared.start()
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc(pauseSilentAudio:)
    func pauseSilentAudio(command: CDVInvokedUrlCommand) {
        SilentAudioManager.shared.pause()
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc(stopSilentAudio:)
    func stopSilentAudio(command: CDVInvokedUrlCommand) {
        SilentAudioManager.shared.stop()
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }
}
