/*
	Dijkstra.inc - Dijkstra Pathfinding Algorithm
	Copyright © 2012 RyDeR`
*/

#if defined _Dijkstra_Included
	#endinput
#endif

#define _Dijkstra_Included

#if !defined MAX_NODES
	#define MAX_NODES (512)
#endif

enum e_Nodes {
	Float: e_fNX,
	Float: e_fNY,
	Float: e_fNZ,
	e_iLink1,
	e_iLink2,
	e_iLink3,
	e_iLink4
};

stock Dijkstra(const aeNodes[][], iStart, iEnd, aiPath[], const iSize = sizeof(aeNodes)) {
	if(iStart == iEnd) {
		return 0;
	}
	iStart ^= iEnd, iEnd ^= iStart, iStart ^= iEnd;
	
	new
		Float: fDist,
		Float: afDist[MAX_NODES] = { Float: 0x7F800000, ... },
		
		bool: abVisited[MAX_NODES char]
	;
	afDist[iStart] = 0.0;
	aiPath[iStart] = -1;
	
	while(iStart != iEnd) {
		abVisited{iStart} = true;
		
		for(new e_Nodes: e = e_iLink1, i = 0; e <= e_iLink4; ++e) {
			i = aeNodes[iStart][e];
			
			if(i >= iSize) {
				continue;
			}
			if(i != -1) {
				fDist = afDist[iStart] + floatsqroot(floatpower(aeNodes[iStart][e_fNX] - aeNodes[i][e_fNX], 2.0) + floatpower(aeNodes[iStart][e_fNY] - aeNodes[i][e_fNY], 2.0) + floatpower(aeNodes[iStart][e_fNZ] - aeNodes[i][e_fNZ], 2.0));
				
				if(fDist < afDist[i]) {
					aiPath[i] = iStart;
					afDist[i] = fDist;
				}
			}
		}
		fDist = Float: 0x7F800000;
		
		for(new i = 0; i < iSize; ++i) {
			if(!abVisited{i} && afDist[i] < fDist) {
				iStart = i;
				fDist = afDist[i];
			}
		}
		if(iStart == iEnd) {
			return 1;
		}
	}
	return 0;
}