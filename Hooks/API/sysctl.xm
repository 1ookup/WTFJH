#import "../Global.h"
#import <sys/sysctl.h>
static NSArray* HWArgs=@[
@"WTFJH-Undefined",
@"HW_MACHINE",
@"HW_MODEL",
@"HW_NCPU",
@"HW_BYTEORDER",
@"HW_PHYSMEM",
@"HW_USERMEM",
@"HW_PAGESIZE",
@"HW_DISKNAMES",
@"HW_DISKSTATS",
@"HW_EPOCH",
@"HW_FLOATINGPT",
@"HW_MACHINE_ARCH",
@"HW_VECTORUNIT",
@"HW_BUS_FREQ",
@"HW_CPU_FREQ",
@"HW_CACHELINE",
@"HW_L1ICACHESIZE",
@"HW_L1DCACHESIZE",
@"HW_L2SETTINGS",
@"HW_L2CACHESIZE",
@"HW_L3SETTINGS",
@"HW_L3CACHESIZE",
@"HW_TB_FREQ",
@"HW_MEMSIZE",
@"HW_AVAILCPU",
@"HW_MAXID"];
/*
int	sysctlnametomib(const char *, int *, size_t *);//Probably Pointless To Hook
*/
extern  BOOL getBoolFromPreferences(NSString *preferenceValue);
int (*old_sysctl)(int *, u_int, void *, size_t *, void *, size_t);
int	(*old_sysctlbyname)(const char *, void *, size_t *, void *, size_t);
static int (*oldptrace)(int _request, pid_t _pid, caddr_t _addr, int _data);
int	new_sysctlbyname(const char *name, void *oldp, size_t *oldlenp, void *newp, size_t newlen){
	if([CallStackInspector wasDirectlyCalledByApp]){

		NSString* nameStr=[NSString stringWithUTF8String:name];
		int ret=old_sysctlbyname(name,oldp,oldlenp,newp,newlen);
		CallTracer *tracer = [[CallTracer alloc] initWithClass:@"sysctl" andMethod:@"sysctlbyname"];
		[tracer addArgFromPlistObject:nameStr withKey:@"name"];
		[tracer addReturnValueFromPlistObject:[NSNumber numberWithInt:ret]];
		[traceStorage saveTracedCall: tracer];
		[tracer release];
		[nameStr release];
		return ret;
	}
	else{
		return old_sysctlbyname(name,oldp,oldlenp,newp,newlen);
	}

}
int new_sysctl(int *name, u_int namelen,struct kinfo_proc* info, size_t *oldlenp, void *newp, size_t newlen){
	/*if(*name[0]==1&&*name[1]==14){
        int RetVal=oldsysctl(A,B,info,C,&D,E);
        info->kp_proc.p_flag=0;
        return RetVal;
    }*/


	if([CallStackInspector wasDirectlyCalledByApp]){
	NSMutableArray* names=[NSMutableArray array];
	for(int x=0;x<namelen-1;x++){
		[names addObject:HWArgs[name[x]]];

	}
	int ret= old_sysctl(name,namelen,info,oldlenp,newp,newlen);
	CallTracer *tracer = [[CallTracer alloc] initWithClass:@"sysctl" andMethod:@"sysctl"];
	[tracer addArgFromPlistObject:names withKey:@"name"];
	[tracer addReturnValueFromPlistObject:[NSNumber numberWithInt:ret]];
	[traceStorage saveTracedCall: tracer];
	[tracer release];
	[names release];
//Anti-Anti-Debugging
	extern BOOL getBoolFromPreferences(NSString *preferenceValue);
	if(getBoolFromPreferences(@"AntiAntiDebugging")==YES){
		if(name[0]==CTL_KERN &&name[1]==KERN_PROC && name[2]==KERN_PROC_PID){
			NSLog(@"WTFJH-----Detected sysctl AntiDebugging");
			info->kp_proc.p_flag=0;
				}

	}
//end
	return ret;
		}
else{

	return old_sysctl(name,namelen,info,oldlenp,newp,newlen);
}
}



static int newptrace(int _request, pid_t _pid, caddr_t _addr, int _data){
	BOOL isAntiDebug=NO;
	int ret;
	if (getBoolFromPreferences(@"AntiAntiDebugging")==YES && _request == 31) {
		isAntiDebug=YES;
	}
	WTInit(@"ptrace",@"ptrace");
	WTAdd([NSNumber numberWithLong:_request],@"request");
	WTAdd([NSNumber numberWithLong:_pid],@"pid");
	WTAdd(objectTypeNotSupported,@"addr");
	WTAdd([NSNumber numberWithLong:_data],@"data");
	if(isAntiDebug){
		WTReturn(@"Anti-Debugging Call Patched By WTFJH");
		ret=0;
	}
	else{
		ret=oldptrace(_request,_pid,_addr,_data);
		WTReturn([NSNumber numberWithInt:ret]);
	}
	WTSave;
	WTRelease;
	return ret;

}
extern void init_sysctl_hook() {
   WTHookFunction((void *) sysctlbyname,(void *)new_sysctlbyname,(void **) &old_sysctlbyname);
   WTHookFunction((void *) sysctl,(void *)new_sysctl,(void **) &old_sysctl);
   WTHookFunction((void *)WTFindSymbol(NULL,"_ptrace"), (void *)newptrace, (void **)&oldptrace);
}
