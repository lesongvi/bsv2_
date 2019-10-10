// Timer Fix by Slice
// Other things by me: http://forum.sa-mp.com/search.php?searchid=3338956
// Version: 0.2.1

#if !defined _samp_included
	#error Please include a_samp before Timer Fix.
#endif

#if !defined TIMER_FIX_TICK_INTERVAL
	#define TIMER_FIX_TICK_INTERVAL  5
#endif

#if !defined TIMER_FIX_TIMER_SLOTS
	#define TIMER_FIX_TIMER_SLOTS  128
#endif

#if !defined TIMER_FIX_MAX_ARGUMENTS
	#define TIMER_FIX_MAX_ARGUMENTS  32 // Highest possible is 125
#endif

#if !defined TIMER_FIX_DISABLE_EX
	#define TIMER_FIX_DISABLE_EX  false // Disables hooking SetTimerEx
#endif

// "Namespace"

#define TF.  TF_

native TF.SetTimer_Raw(const szFunction[], iInterval, bRepeating) = SetTimer;
native TF.SetTimerEx_Raw(const szFunction[], iInterval, bRepeating, const szFormat[], {Float, _}:...) = SetTimerEx;
native TF.KillTimer_Raw(iTimerID) = KillTimer;

#define SetTimer    TF_SetTimer_Hook

#if !TIMER_FIX_DISABLE_EX
	#define SetTimerEx  TF_SetTimer_Hook
#endif

#define KillTimer   TF_KillTimer_Hook

enum TF.E_TIMER {
	bool:e_bUsed,
	     e_szFunction[32],
	     e_iArgumentCount,
	     e_axArguments[TIMER_FIX_MAX_ARGUMENTS],
	     e_iInterval,
	     e_iNextCall,
	bool:e_bRepeating,
	bool:e_bRunning
};

new
	bool:TF.g_bTickTimerRunning = false,
	     TF.g_Timers[TIMER_FIX_TIMER_SLOTS][TF.E_TIMER]
;

stock TF.SetTimer_Hook(const szFunction[], iInterval, bRepeating, const szFormat[] = "", {Float, _}:...) {
	const
		STATIC_ARGS = 4
	;
	
	new
		iSlot = -1
	;
	
	if (strfind(szFormat, "s", true) != -1) {
		printf("ERROR: Timer Fix doesn't support strings yet; your timer will not be fired (%s).", szFunction);
		
		return -1;
	}
	
	if (!TF.g_bTickTimerRunning) {
		TF.g_bTickTimerRunning = true;
		
		TF.SetTimer_Raw("TF_TickTimer", TIMER_FIX_TICK_INTERVAL, true);
	}
	
	for (new i = 0; i < sizeof(TF.g_Timers); i++) {
		if (!TF.g_Timers[i][e_bUsed]) {
			iSlot = i;
			
			break;
		}
	}
	
	if (iSlot == -1) {
		if (!TIMER_FIX_DISABLE_EX || szFormat[0]) {
			printf("ERROR: Timer Fix was unable to find an empty slot for the timer; your timer will not be fired because it has arguments (%s).", szFunction);
			printf("       You have to increase TIMER_FIX_TIMER_SLOTS (current: %d).", TIMER_FIX_TIMER_SLOTS);
			
			return -1;
		} else {
			printf("WARNING: TimerFix was unable to find an empty slot for the timer, your timer will be using the regular functionality.");
			printf("         You should increase TIMER_FIX_TIMER_SLOTS (current: %d).", TIMER_FIX_TIMER_SLOTS);

			return TF.SetTimer_Raw(szFunction, iInterval, bRepeating);
		}
	}
	
	TF.g_Timers[iSlot][e_bRepeating] = !!bRepeating;
	TF.g_Timers[iSlot][e_bRunning] = false;
	TF.g_Timers[iSlot][e_iInterval] = iInterval;
	TF.g_Timers[iSlot][e_iNextCall] = GetTickCount() + iInterval - (TIMER_FIX_TICK_INTERVAL / 2);
	TF.g_Timers[iSlot][e_iArgumentCount] = numargs() - STATIC_ARGS;
	
	if (TF.g_Timers[iSlot][e_iArgumentCount] != strlen(szFormat)) {
		printf("ERROR: Timer Fix is unable to start your timer because the length of the format string doesn't match the number of arguments passed (%d, %d).", TF.g_Timers[iSlot][e_iArgumentCount], strlen(szFormat));
		printf("       Make sure you passed the correct number of arguments to SetTimerEx (%s).", szFunction);
		
		return -1;
	}
	
	for (new i = 0; i < TF.g_Timers[iSlot][e_iArgumentCount]; i++)
		TF.g_Timers[iSlot][e_axArguments][i] = getarg(STATIC_ARGS + i);
	
	TF.g_Timers[iSlot][e_szFunction][0] = 0;
	
	if (ispacked(szFunction))
		strunpack(TF.g_Timers[iSlot][e_szFunction], szFunction, 32);
	else
		strcat(TF.g_Timers[iSlot][e_szFunction], szFunction, 32);
	
	if (funcidx(TF.g_Timers[iSlot][e_szFunction]) == -1) {
		printf("ERROR: A timer was started for a function that doesn't exist, or isn't public: %s.", TF.g_Timers[iSlot][e_szFunction]);
		
		return -1;
	}
	
	TF.g_Timers[iSlot][e_bUsed] = true;
	
	// I made it so timer IDs pointing to this script are negative; thus, allowing me to create a universal KillTimer function.
	return iSlot - sizeof(TF.g_Timers) - 1;
}

stock TF.KillTimer_Hook(iTimerID) {
	if (iTimerID < 0 && iTimerID >= -sizeof(TF.g_Timers) - 1) {
		// Get the slot in the array (iSlot above).
		iTimerID += sizeof(TF.g_Timers) + 1;
		
		TF.g_Timers[iTimerID][e_bUsed] = false;
	} else {
		TF.KillTimer_Raw(iTimerID);
	}
	
	return true;
}

forward TF.TickTimer();
public TF.TickTimer() {
	new
		iTick = GetTickCount()
	;
	
	for (new i = 0; i < sizeof(TF.g_Timers); i++) {
		if (!TF.g_Timers[i][e_bUsed])
			continue;
		
		if (TF.g_Timers[i][e_bRunning]) {
			printf("WARNING: timerfix: \"%s\" didn't properly execute last time.", TF.g_Timers[i][e_szFunction]);
			
			TF.g_Timers[i][e_bRunning] = false;
		}
		
		if (iTick >= TF.g_Timers[i][e_iNextCall]) {
			if (TF.g_Timers[i][e_bRepeating])
				TF.g_Timers[i][e_iNextCall] = iTick + TF.g_Timers[i][e_iInterval] - (TIMER_FIX_TICK_INTERVAL / 2);
			else {
				TF.g_Timers[i][e_bUsed] = false;
			}
			
			TF.g_Timers[i][e_bRunning] = true;
			
			if (TF.g_Timers[i][e_iArgumentCount] == 0) {
				#if defined TIMERFIX_DEBUG
					printf("timerfix: Calling \"%s\" (plain).", TF.g_Timers[i][e_szFunction]);
				#endif
				
				CallLocalFunction(TF.g_Timers[i][e_szFunction], "");
			} else {
				#if defined TIMERFIX_DEBUG
					printf("timerfix: Calling \"%s\" (args).", TF.g_Timers[i][e_szFunction]);
				#endif
				
				new
					szFormatSpecifier[TIMER_FIX_MAX_ARGUMENTS],
					iArgumentAddress,
					iNumArgs = TF.g_Timers[i][e_iArgumentCount],
					iArgCount = TF.g_Timers[i][e_iArgumentCount] * 4,
					j
				;
				
				for (j = 0; j < TF.g_Timers[i][e_iArgumentCount]; j++)
					strcat(szFormatSpecifier, "i");
				
				j = 0;
				
				#emit CONST.PRI TF_g_Timers
				#emit STOR.S.PRI iArgumentAddress
				
				iArgumentAddress += sizeof(TF_g_Timers) * 4;
				iArgumentAddress += (_:TF_E_TIMER * i + _:e_axArguments) * 4;
				
				iArgumentAddress += iArgCount;
				
				#if defined TIMERFIX_DEBUG
					printf("timerfix: Pushing arguments (%d)..", TF.g_Timers[i][e_iArgumentCount]);
				#endif
				
				for (; j != iNumArgs; ++j) {
					iArgumentAddress -= 4;
					
					#emit PUSH.S    iArgumentAddress
				}

				#emit PUSH.ADR  szFormatSpecifier
				
				#emit CONST.PRI TF_g_Timers
				#emit STOR.S.PRI iArgumentAddress
				
				iArgumentAddress += sizeof(TF_g_Timers) * 4;
				iArgumentAddress += (_:TF_E_TIMER * i + _:e_szFunction) * 4;
				
				#emit PUSH.S  iArgumentAddress

				iArgCount += 8;
				
				#emit PUSH.S    iArgCount
				#emit SYSREQ.C  CallLocalFunction

				iArgCount += 4;

				#emit LCTRL         4
				#emit LOAD.S.alt    iArgCount
				#emit ADD
				#emit SCTRL         4
			}
			
			#if defined TIMERFIX_DEBUG
				printf("timerfix: Done calling \"%s\".", TF.g_Timers[i][e_szFunction]);
			#endif
			
			TF.g_Timers[i][e_bRunning] = false;
		}
	}
}

#undef TF