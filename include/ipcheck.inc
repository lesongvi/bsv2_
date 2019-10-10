#if defined _ipcheck_included
    #endinput
#endif
#define _ipcheck_included

stock IsIp(const string[])
{
	new count = 0;
	new pos[50];
	new length = strlen(string);
	for(new n=0; n<length; n++)
	{
		if(string[n] == '.')
		{
		    if(count < 50)
		    {
		    	pos[count] = n;
			}
			count++;
		}
	}
	if(count >= 3)
	{
	    new res[50];
		for(new n=0; n<count; n++)
		{
			if(n != (count - 1) && n != count)
			{
				if((pos[n+1] - pos[n]) > 4 || (pos[n+1] - pos[n]) == 1)
				{
					res[n] = 0;
				}
				else
				{
				    res[n] = 1;
				}
			}
		}
		new result = 0;
		for(new n=0; n<count; n++)
		{
		    if(res[n] == 1) result++;
		}
		if(result >= 2)
		{
		    return 1;
		}
	}
	return 0;
}