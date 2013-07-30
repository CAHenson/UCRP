#define COL_GREEN2         "{33CC00}"
#define COL_WHITE          "{FFFFFF}"
enum pInfo
{
	pPassword[129],
	pKills,
	pDeaths,
    pAdmin,
    pMoney,
    pScore,
    pVIP,
    pOnline
}
new PlayerInfo[MAX_PLAYERS][pInfo];
native WP_Hash(buffer[], len, const str[]);

forward LoadUserData(playerid, name[], value[]);

#define INI_Exists(%0)  fexist(%0)

#define DIALOG_REGISTER 1
#define DIALOG_LOGIN    2

#define USER_FILE       "Users/%s.ini"
#define VERSION         "1.0.0"


public LoadUserData(playerid, name[], value[])
{
    INI_String("Password", PlayerInfo[playerid][pPassword], 129);
    INI_Int("Admin", PlayerInfo[playerid][pAdmin]);
    INI_Int("VIP", PlayerInfo[playerid][pVIP]);
    INI_Int("Money", PlayerInfo[playerid][pMoney]);
    INI_Int("Score", PlayerInfo[playerid][pScore]);
    INI_Int("Kills", PlayerInfo[playerid][pKills]);
    INI_Int("Deaths", PlayerInfo[playerid][pDeaths]);
    INI_Int("Online", PlayerInfo[playerid][pOnline]);
    return 1;   
}

OnPlayerRegister(playerid, password[])
{
    new
        hashPassword[129],
        uFile[35];

    format(uFile, 35, USER_FILE, GetName(playerid));

    new
        INI:playerFile = INI_Open(uFile);

    WP_Hash(hashPassword, 129, password);
	
    INI_WriteString(playerFile, "Password", hashPassword);
    INI_WriteInt(playerFile, "Admin", 0);
    INI_WriteInt(playerFile, "VIP", 0);
    INI_WriteInt(playerFile, "Money", 200);
    INI_WriteInt(playerFile, "Score", 0);
    INI_WriteInt(playerFile, "Kills", 0);
    INI_WriteInt(playerFile, "Deaths", 0);
    INI_WriteInt(playerFile, "Online", 0);

    INI_Close(playerFile);

    SetPVarInt(playerid, "Registered", 1);
    SetPVarInt(playerid, "Logged", 1);
    return 1;
}

OnPlayerLogin(playerid, password[])
{
    new
        hashPassword[129],
        uFile[35];

    format(uFile, 35, USER_FILE, GetName(playerid));

    INI_ParseFile(uFile, "LoadUserData", .bExtra = true, .extra = playerid);

    WP_Hash(hashPassword, 129, password);

    if(strcmp(PlayerInfo[playerid][pPassword], hashPassword, false))
    {
	{
		SetPVarInt(playerid, "Logged", 1);
	}
    }
    return 1;
}

OnPlayerLogout(playerid)
{
    new
        uFile[35];

    format(uFile, 35, USER_FILE, GetName(playerid));

    new
        INI:playerFile = INI_Open(uFile);
    INI_WriteInt(playerFile, "Admin", PlayerInfo[playerid][pAdmin]);
    INI_WriteInt(playerFile, "VIP", PlayerInfo[playerid][pVIP]);
    INI_WriteInt(playerFile, "Money", GetPlayeMoney(playerid));
    INI_WriteInt(playerFile, "Score", GetPlayerScore(playerid));
    INI_WriteInt(playerFile, "Kills", PlayerInfo[playerid][pKills]);
    INI_WriteInt(playerFile, "Deaths", PlayerInfo[playerid][pDeaths]);
    INI_WriteInt(playerFile, "Online", PlayerInfo[playerid][pOnline]);

    INI_Close(playerFile);
    return 1;
}

forward Online();
public Online()
{
	foreach (Player, i)
	{
		PlayerInfo[i][pOnline] += 1;
	}
	return 1;
}