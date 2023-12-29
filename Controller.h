@interface GCController : NSObject
/*
@property (nonatomic,retain) id profile;
@property (nonatomic,retain,readonly) NSArray * hidServices;
@property (nonatomic,readonly) unsigned service;
@property (nonatomic,retain) NSString * physicalDeviceUniqueID;
@property (assign,nonatomic) BOOL physicalDeviceUsesCompass;
@property (nonatomic,copy) id controllerPausedHandler;
@property (retain) NSObject* handlerQueue;
@property (nonatomic,copy,readonly) NSString * vendorName;
@property (getter=isAttachedToDevice,nonatomic,readonly) BOOL attachedToDevice;
@property (assign,nonatomic) long long playerIndex;
@property (nonatomic,retain,readonly) GCGamepad * gamepad;
//@property (nonatomic,retain,readonly) GCMicroGamepad * microGamepad;
@property (nonatomic,retain,readonly) GCExtendedGamepad * extendedGamepad;
@property (nonatomic,retain,readonly) GCMotion * motion;
+(id)controllers;
+(void)__daemon__appDidEnterBackground;
+(void)__daemon__appWillEnterForeground;
+(void)_startWirelessControllerDiscoveryWithCompanions:(BOOL)arg1 btClassic:(BOOL)arg2 btle:(BOOL)arg3 completionHandler:(id)arg4 ;
+(void)__open__;
+(void)__openXPC__;
+(void)__openXPC_and_CBApplicationDidBecomeActive__;
+(void)__setLogger__:(d)arg1 ;
+(void)__daemon__startBonjourService;
+(void)__daemon__setUserActivityUserInfo:(id)arg1 ;
+(void)__daemon__requestConnectedHostUpdatesWithHandler:(id)arg1 ;
+(void)__daemon__addController:(id)arg1 ;
+(void)__daemon__removeController:(id)arg1 ;
+(void)__daemon__controllerWithUDID:(unsigned long long)arg1 setValue:(float)arg2 forElement:(int)arg3 ;
+(void)startWirelessControllerDiscoveryWithCompletionHandler:(id)arg1 ;
+(void)stopWirelessControllerDiscovery;
+(void)handleUIEvent:(id)arg1 ;
-(NSString *)physicalDeviceUniqueID;
-(NSString *)vendorName;
-(unsigned)service;
-(GCExtendedGamepad *)extendedGamepad;
-(GCGamepad *)gamepad;
-(void)setPlayerIndex:(long long)arg1 ;
-(long long)playerIndex;
-(unsigned long long)deviceHash;
//-(GCMotion *)motion;
-(void)removeServiceRef:(IOHIDServiceClientRef)arg1 ;
-(BOOL)supportsMotionLite;
-(NSArray *)hidServices;
-(void)setPhysicalDeviceUniqueID:(NSString *)arg1 ;
-(BOOL)physicalDeviceUsesCompass;
-(void)setPhysicalDeviceUsesCompass:(BOOL)arg1 ;
-(void)addServiceRefs:(id)arg1 ;
-(BOOL)isForwarded;
-(id)controllerPausedHandler;
//-(GCMicroGamepad *)microGamepad;
-(void)setControllerPausedHandler:(id)arg1 ;
-(BOOL)isAttachedToDevice;
-(BOOL)isEqualToController:(id)arg1 ;
-(BOOL)hasServiceRef:(id)arg1 ;
-(void*)createInputBufferForDevice:(id)arg1 withSize:(unsigned long long)arg2 ;
-(id)profile;
-(void)setProfile:(id)arg1 ;
-(void)setHandlerQueue:(NSObject*)arg1 ;
-(NSObject*)handlerQueue;
-(unsigned)sampleRate;
*/
@end
@interface GCControllerElement : NSObject

@property (nonatomic,weak,readonly) GCControllerElement * collection;
@property (getter=isAnalog,nonatomic,readonly) BOOL analog;
-(GCControllerElement *)collection;
-(BOOL)_setValue:(float)arg1 queue:(id)arg2 ;
-(BOOL)setHIDValue:(id)arg1 queue:(id)arg2 ;
-(BOOL)isAnalog;
-(BOOL)setHIDValue:(id)arg1 ;
-(float)value;
-(id)controller;
-(BOOL)_setValue:(float)arg1 ;
@end

@interface GCControllerButtonInput : GCControllerElement

@property (nonatomic,copy) id valueChangedHandler;
@property (nonatomic,copy) id pressedChangedHandler;
@property (nonatomic,readonly) float value;
@property (getter=isPressed,nonatomic,readonly) BOOL pressed;
-(void)setValueChangedHandler:(id)arg1 ;
-(id)valueChangedHandler;
-(BOOL)_setValue:(float)arg1 queue:(id)arg2 ;
-(BOOL)setHIDValue:(id)arg1 queue:(id)arg2 ;
-(BOOL)setHIDValue:(id)arg1 ;
-(id)pressedChangedHandler;
-(void)setPressedChangedHandler:(id)arg1 ;
-(BOOL)isPressed;
-(float)value;
-(BOOL)_setValue:(float)arg1 ;
@end

@interface GCControllerAxisInput : GCControllerElement

@property (nonatomic,readonly) GCControllerButtonInput * positive;
@property (nonatomic,readonly) GCControllerButtonInput * negative;
@property (getter=isFlipped,nonatomic,readonly) BOOL flipped;
@property (getter=isDigital,nonatomic,readonly) BOOL digital;
@property (nonatomic,copy) id valueChangedHandler;
@property (nonatomic,readonly) float value;
-(void)setValueChangedHandler:(id)arg1 ;
-(GCControllerButtonInput *)negative;
-(id)valueChangedHandler;
-(BOOL)_setValue:(float)arg1 queue:(id)arg2 ;
-(BOOL)setHIDValue:(id)arg1 queue:(id)arg2 ;
-(BOOL)isAnalog;
-(BOOL)setHIDValue:(id)arg1 ;
-(BOOL)isDigital;
-(GCControllerButtonInput *)positive;
-(id)description;
-(float)value;
-(BOOL)isFlipped;
-(BOOL)_setValue:(float)arg1 ;
@end

@interface GCControllerDirectionPad : GCControllerElement

@property (nonatomic,copy) id valueChangedHandler;
@property (nonatomic,readonly) GCControllerAxisInput * xAxis;
@property (nonatomic,readonly) GCControllerAxisInput * yAxis;
@property (nonatomic,readonly) GCControllerButtonInput * up;
@property (nonatomic,readonly) GCControllerButtonInput * down;
@property (nonatomic,readonly) GCControllerButtonInput * left;
@property (nonatomic,readonly) GCControllerButtonInput * right;
-(void)setValueChangedHandler:(id)arg1 ;
-(id)valueChangedHandler;
-(BOOL)setHIDValue:(id/*id*/)arg1 queue:(id)arg2 ;
-(BOOL)setHIDValue:(id/*id*/)arg1 ;
-(id)initWithFlippedY:(BOOL)arg1 digital:(BOOL)arg2 ;
-(GCControllerButtonInput *)down;
-(GCControllerAxisInput *)yAxis;
-(GCControllerAxisInput *)xAxis;
-(GCControllerButtonInput *)left;
-(GCControllerButtonInput *)right;
-(GCControllerButtonInput *)up;
-(id)description;
@end

@interface GCExtendedGamepad : NSObject
@property (nonatomic,weak,readonly) GCController * controller;
@property (nonatomic,copy) id valueChangedHandler;
@property (nonatomic,readonly) GCControllerDirectionPad * dpad;
@property (nonatomic,readonly) GCControllerButtonInput * buttonA;
@property (nonatomic,readonly) GCControllerButtonInput * buttonB;
@property (nonatomic,readonly) GCControllerButtonInput * buttonX;
@property (nonatomic,readonly) GCControllerButtonInput * buttonY;
@property (nonatomic,readonly) GCControllerDirectionPad * leftThumbstick;
@property (nonatomic,readonly) GCControllerDirectionPad * rightThumbstick;
@property (nonatomic,readonly) GCControllerButtonInput * leftShoulder;
@property (nonatomic,readonly) GCControllerButtonInput * rightShoulder;
@property (nonatomic,readonly) GCControllerButtonInput * leftTrigger;
@property (nonatomic,readonly) GCControllerButtonInput * rightTrigger;
@property (nonatomic,readonly) GCControllerButtonInput * leftThumbstickButton;
@property (nonatomic,readonly) GCControllerButtonInput * rightThumbstickButton;
+(BOOL)supportsUSBInterfaceProtocol:(unsigned char)arg1 ;
-(id)saveSnapshot;
-(void)setValueChangedHandler:(id)arg1 ;
-(GCControllerButtonInput *)buttonA;
-(GCControllerButtonInput *)buttonB;
-(GCControllerButtonInput *)buttonX;
-(GCControllerButtonInput *)buttonY;
-(GCControllerDirectionPad *)leftThumbstick;
-(GCControllerDirectionPad *)rightThumbstick;
-(GCControllerDirectionPad *)dpad;
-(GCControllerButtonInput *)leftShoulder;
-(GCControllerButtonInput *)rightShoulder;
-(GCControllerButtonInput *)leftTrigger;
-(GCControllerButtonInput *)rightTrigger;
-(id)initWithController:(id)arg1 ;
-(GCControllerButtonInput *)rightThumbstickButton;
-(GCControllerButtonInput *)leftThumbstickButton;
-(void)setDpad:(id)arg1 x:(double)arg2 y:(double)arg3 ;
-(id)valueChangedHandler;
-(void)setButton:(id)arg1 value:(double)arg2 ;
-(id)button0;
-(id)button3;
-(id)inputForElement:(/*IOHIDElementRef*/)arg1 ;
-(void)setButton:(id)arg1 pressed:(BOOL)arg2 ;
-(BOOL)reportsAbsoluteDpadValues;
-(void)setReportsAbsoluteDpadValues:(BOOL)arg1 ;
-(id)button1;
-(id)button2;
-(GCController *)controller;
-(BOOL)allowsRotation;
-(void)setAllowsRotation:(BOOL)arg1 ;
@end
