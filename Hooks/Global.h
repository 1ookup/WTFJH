#import "Utils/CallStackInspector.h"
#import "Utils/CallTracer.h"
#import "Utils/PlistObjectConverter.h"
#import "Utils/RuntimeUtils.h"
#import "Utils/SQLiteStorage.h"
#import "Utils/Utils.h"
#import "Utils/DelegateProxies.h"
#import "Utils/NSURLConnectionDelegateProx.h"

#import <substrate.h>

#import "Misc/WTSubstrate.h"
#import <objc/runtime.h>
#import <mach-o/getsect.h>
#import <mach-o/dyld.h>
#import <dlfcn.h>
#import "Misc/fishhook.h"
#import "Obfuscation.h"
#import "capstone/capstone.h"

#define objectTypeNotSupported @"objectTypeNotSupported"
#define traceStorage [SQLiteStorage sharedManager]

#ifdef NonJailbroken
#define preferenceFilePath [NSString stringWithFormat:@"%@/Library/Preferences/naville.wtfjh.plist",NSHomeDirectory()]
#else
#define preferenceFilePath @"/private/var/mobile/Library/Preferences/naville.wtfjh.plist"
#endif


#define Meh1(x) #x
#define Meh(x) Meh1(x)
#ifdef DEBUG
#define WTInit(CLASSNAME,ARGUMENTNAME) CallTracer *tracer = [[CallTracer alloc] initWithClass:CLASSNAME andMethod:ARGUMENTNAME];\
									   NSLog(@"WTFJH-%@-%@",CLASSNAME,ARGUMENTNAME)
#else
#define WTInit(CLASSNAME,ARGUMENTNAME) CallTracer *tracer = [[CallTracer alloc] initWithClass:CLASSNAME andMethod:ARGUMENTNAME]
#endif
#define WTAdd(Argument,Name) [tracer addArgFromPlistObject:Argument withKey:Name]
#define WTReturn(Return) [tracer addReturnValueFromPlistObject:Return]
#define WTSave [traceStorage saveTracedCall:tracer]
#define WTRelease [tracer release];
#define WTShouldLog [CallStackInspector wasDirectlyCalledByApp]
#define WTCallBack(LibraryName,FunctionToCall) static void CallBackFunction(const struct mach_header* mh, intptr_t vmaddr_slide){ \
					Dl_info image_info;\
					dladdr(mh, &image_info);\
					const char *image_name = image_info.dli_fname;\
					if(image_name==NULL){\
						NSLog(@"Empty ImageName");\
						return;\
					}\
					NSString* name=[NSString stringWithUTF8String:image_name];\
					if([name containsString:LibraryName]){\
						FunctionToCall();\
					}\
					[name release];\
					}
#define WTAddCallBack(LoaderFunction) _dyld_register_func_for_add_image(&CallBackFunction);LoaderFunction()

#define RMASLRCenter @"com.naville.wtfjh.rmaslr"

#define CyPort 2588
