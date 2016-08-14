export CFLAGS=-Wp,"-DWTFJHTWEAKNAME=@\"WTFJH\",-DPROTOTYPE,"-DWTFJHHostName=@\"NavRMBP\"
include $(THEOS)/makefiles/common.mk
TWEAK_NAME = WTFJH
SUBSTRATE ?= yes
WTFJH_FILES = Tweak.xm CompileDefines.xm Hooks/API/AppleAccount.xm Hooks/API/CommonCryptor.xm Hooks/API/CommonDigest.xm Hooks/API/CommonHMAC.xm Hooks/API/CommonKeyDerivation.xm Hooks/API/CoreTelephony.xm Hooks/API/dlfcn.xm Hooks/API/Keychain.xm Hooks/API/libC.xm Hooks/API/libMobileGestalt.xm Hooks/API/LSApplication.xm Hooks/API/MachO.xm Hooks/API/Notification.xm Hooks/API/NSData.xm Hooks/API/NSFileHandle.xm Hooks/API/NSFileManager.xm Hooks/API/NSHTTPCookie.xm Hooks/API/NSInputStream.xm Hooks/API/NSKeyedArchiver.xm Hooks/API/NSKeyedUnarchiver.xm Hooks/API/NSOutputStream.xm Hooks/API/NSProcessInfo.xm Hooks/API/NSURLConnection.xm Hooks/API/NSURLCredential.xm Hooks/API/NSURLSession.xm Hooks/API/NSUserDefaults.xm Hooks/API/NSXMLParser.xm Hooks/API/ObjCRuntime.xm Hooks/API/Security.xm Hooks/API/Socket.xm Hooks/API/SSLKillSwitch.xm Hooks/API/sysctl.xm Hooks/API/UIPasteboard.xm Hooks/SDK/FclBlowfish.xm Hooks/SDK/JSPatch.xm Hooks/SDK/OpenSSLAES.xm Hooks/SDK/OpenSSLBlowFish.xm Hooks/SDK/OpenSSLMD5.xm Hooks/SDK/OpenSSLSHA1.xm Hooks/SDK/OpenSSLSHA512.xm Hooks/SDK/Reveal.xm Hooks/SDK/Wax.xm Hooks/Utils/CallStackInspector.m Hooks/Utils/CallTracer.m Hooks/Utils/DelegateProxies.m Hooks/Utils/NSURLConnectionDelegateProx.m Hooks/Utils/NSURLSessionDelegateProxy.m Hooks/Utils/PlistObjectConverter.m Hooks/Utils/RemoteLogSender.m Hooks/Utils/RuntimeUtils.m Hooks/Utils/SQLiteStorage.m Hooks/Utils/Utils.m Hooks/ThirdPartyTools/classdumpdyld.xm Hooks/ThirdPartyTools/dumpdecrypted.xm Hooks/ThirdPartyTools/InspectiveC.xm Hooks/Misc/Cycript.xm Hooks/Misc/fishhook.c Hooks/Misc/RemoveASLR.xm Hooks/Misc/SplitMachO.mm Hooks/Misc/WTSubstrate.mm
WTFJH_CCFLAGS  = -Qunused-arguments -std=c++11
WTFJH_LDFLAGS  = -Wl,-segalign,4000,-sectcreate,WTFJH,SIGDB,./SignatureDatabase.plist,-sectcreate,WTFJH,classdumpdyld,./classdumpdyld.dylib,-sectcreate,WTFJH,dumpdecrypted,./dumpdecrypted.dylib,-sectcreate,WTFJH,InspectiveC,./InspectiveC.dylib  -lz -L. -v -force_load ./ExtraFWs/libcapstone.a -force_load ./ExtraFWs/libLiberation.a -force_load ./ExtraFWs/Cycript.framework/Cycript -F./ExtraFWs/ -Wno-unused-function 
WTFJH_CFLAGS =  -I/Volumes/PAGEZERO/WTFJH/Hooks/
WTFJH_LIBRARIES = sqlite3 substrate stdc++ c++  
WTFJH_FRAMEWORKS = Foundation UIKit Security JavaScriptCore UIKit CoreGraphics CoreFoundation QuartzCore CFNetwork  
 
include $(THEOS_MAKE_PATH)/tweak.mk
after-install::
	install.exec "killall -9 SpringBoard"