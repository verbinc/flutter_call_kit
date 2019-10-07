import 'package:flutter/material.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:flutter_call_kit/flutter_call_kit.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _configured;
  String _currentCallId;

  @override
  void initState() {
    super.initState();
    configure();
  }

  Future<void> configure() async {
    FlutterCallKit().configure(
      IOSOptions("My Awesome APP",
          imageName: 'sim_icon',
          supportsVideo: false,
          maximumCallGroups: 1,
          maximumCallsPerCallGroup: 1),
      didReceiveStartCallAction: _didReceiveStartCallAction,
      performAnswerCallAction: _performAnswerCallAction,
      performEndCallAction: _performEndCallAction,
      didActivateAudioSession: _didActivateAudioSession,
      didDisplayIncomingCall: _didDisplayIncomingCall,
      didPerformSetMutedCallAction: _didPerformSetMutedCallAction,
      didPerformDTMFAction: _didPerformDTMFAction,
      didToggleHoldAction: _didToggleHoldAction,
    );
    setState(() {
      _configured = true;
    });
  }

  /// Use startCall to ask the system to start a call - Initiate an outgoing call from this point
  startCall(String handle, String localizedCallerName) {
    /// Your normal start call action
    FlutterCallKit().startCall(currentCallId, handle, localizedCallerName);
  }

  reportEndCallWithUUID(String uuid, EndReason reason) {
    FlutterCallKit().reportEndCallWithUUID(uuid, reason);
  }

  /// Event Listener Callbacks


  _didReceiveStartCallAction(String uuid, String handle) {
    // Get this event after the system decides you can start a call
    // You can now start a call from within your app
  }

  _performAnswerCallAction(String uuid) {
    // Called when the user answers an incoming call
  }

  _performEndCallAction(String uuid) {
    FlutterCallKit().endCall(this.currentCallId);
    _currentCallId = null;
  }

  _didActivateAudioSession() {
    // you might want to do following things when receiving this event:
    // - Start playing ringback if it is an outgoing call
  }

  _didDisplayIncomingCall(String error, String uuid, String handle,
      String localizedCallerName, bool fromPushKit) {
    // You will get this event after RNCallKeep finishes showing incoming call UI
    // You can check if there was an error while displaying
  }

  _didPerformSetMutedCallAction(bool mute, String uuid) {
    // Called when the system or user mutes a call
  }
  _didPerformDTMFAction(String digit, String uuid) {
    // Called when the system or user performs a DTMF action
  }

  _didToggleHoldAction(bool hold, String uuid) {
    // Called when the system or user holds a call
  }

  String get currentCallId {
    if (_currentCallId == null) {
      final uuid = new Uuid();
      _currentCallId = uuid.v4();
    }

    return _currentCallId;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Flutter Call Kit Configured: $_configured\n'),
        ),
      ),
    );
  }
}