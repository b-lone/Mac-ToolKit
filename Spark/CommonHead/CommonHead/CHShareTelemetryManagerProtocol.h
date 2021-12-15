#ifndef CHShareTelemetryManagerProtocol_IMPORTED
#define CHShareTelemetryManagerProtocol_IMPORTED
// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel_protocol.j2

enum CHDragPosition: NSUInteger;
enum CHShortcut: NSUInteger;



//forward declare the protocol
@protocol CHShareTelemetryManagerProtocol;

@protocol CHShareTelemetryManagerDelegate
@end

@protocol CHShareTelemetryManagerProtocol

@property(nonatomic, weak) id<CHShareTelemetryManagerDelegate> _Nullable delegate; // DEPRECATED, use add/removeDelegate instead
-(void) addDelegate:(id<CHShareTelemetryManagerDelegate> _Nonnull)delegate NS_SWIFT_NAME(addDelegate(_:));
-(void) removeDelegate:(id<CHShareTelemetryManagerDelegate> _Nonnull)delegate NS_SWIFT_NAME(removeDelegate(_:));


- (void)recordShortcutKeyPressed:(NSString * _Nonnull)callId shortcut:(enum CHShortcut)shortcut NS_SWIFT_NAME(recordShortcutKeyPressed(callId:shortcut:));
- (void)recordSettingsButtonPressed:(NSString * _Nonnull)callId NS_SWIFT_NAME(recordSettingsButtonPressed(callId:));
- (void)recordControlBarDragPosition:(NSString * _Nonnull)callId position:(enum CHDragPosition)position NS_SWIFT_NAME(recordControlBarDragPosition(callId:position:));


@end

#endif
