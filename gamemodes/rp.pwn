/*==============================================================================
=========================Made by Jafet Macario==================================
================================================================================
WARNING: THIS IS NOT A GF/LARP EDIT, IT HAS BEEN MADE FROM SCRATCH!
WARNING: This has been made for new users in PAWN so they can get started.
====================================CREDITS=====================================
Thanks to:
Y_Less for his impressive sscanf and foreach,
DracoBlue for his dini and dudb,
ZeeX for his ZCMD,
MadMan for his Vehicle System,
Jafet Macario - Made this gamemode
Reignald Bailey - Helped me with some stuff.
SkizzoTrick for his tutorial.
=====================Please DO NOT REMOVE the Credits===========================*/
//================================[INCLUDES]====================================
#include <a_samp>
#include <YSI\y_ini>
#include <zcmd>
#include <foreach>
//================================[DEFINES]=====================================
#define PRESSED(%0) \
(((newkeys&(%0))==(%0)) && ((oldkeys & (%0)) != (%0)))
#define PATH "/Users/%s.ini"
//=========================DEALERSHIP SETTINGS==================================
#undef MAX_PLAYERS
#define MAX_PLAYERS 100
#define MAX_DVEHICLES 200
#define MAX_DEALERSHIPS 10
#define MAX_FUEL_STATIONS 10
#define VEHICLE_File_PATH "DSHIP/Vehicles/"
#define DEALERSHIP_File_PATH "DSHIP/Dealerships/"
#define FUEL_STATION_File_PATH "DSHIP/FuelStations/"
#define MAX_PLAYER_VEHICLES 3
#define FUEL_PRICE 5
#define GAS_CAN_PRICE 500
#define ALARM_TIME 10000  // alarm duration in milliseconds (1 second = 1000 milliseconds)
#define DEFAULT_NUMBER_PLATE "123 ABC"
#define VEHICLE_DEALERSHIP 1
#define VEHICLE_PLAYER 2
#define DIALOG_NONE 12345
#define DIALOG_ERROR 12346
#define DIALOG_VEHICLE 500
#define DIALOG_VEHICLE_BUY 501
#define DIALOG_VEHICLE_SELL 502
#define DIALOG_FINDVEHICLE 503
#define DIALOG_TRUNK 504
#define DIALOG_TRUNK_ACTION 505
#define DIALOG_VEHICLE_PLATE 507
#define DIALOG_FUEL 510
#define DIALOG_EDITVEHICLE 606
#define strcpy(%0,%1,%2) %0="",strcat(%0,%2,%1)
#define ShowErrorDialog(%1,%2) ShowPlayerDialog(%1, DIALOG_ERROR, DIALOG_STYLE_MSGBOX, "ERROR", %2, "OK", "")
//==============================[COLORS DEFINES]================================
#define ResetMoneyBar ResetPlayerMoney
#define UpdateMoneyBar GivePlayerMoney
#define SCM SendClientMessage
#define LIGHTBLUE "{00CED1}"
#define ALB "{ffffff}"
#define RED "{F81414}"
#define GREEN "{00FF22}"
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GRAD1 0xFFFFFFFF
#define COLOR_PURPLE 0xC2A2DAAA
#define COLOR_LIGHTRED 0xFF6347AA
#define COLOR_BLUE 0x2641FEAA
#define COLOR_FADE1 0xE6E6E6E6
#define COLOR_FADE2 0xC8C8C8C8
#define COLOR_FADE3 0xAAAAAAAA
#define COLOR_FADE4 0x8C8C8C8C
#define COLOR_YELLOW3 0xFFFF00FF
#define COLOR_FADE5 0x6E6E6E6E
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_CHAT1 0xF9B7FFAA
#define COLOR_CHAT2 0xE6A9ECAA
#define COLOR_CHAT3 0xC38EC7AA
#define COLOR_CHAT4 0xD2B9D3AA
#define COLOR_CHAT5 0xC6AEC7AA
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_YELLOW2 0xF5DEB3AA
#define COLOR_GOLD 	0xF6C861AA
#define COLOR_DBLUE 0x2641FEAA
#define COLOR_OOC 0xE0FFFFAA
#define PURPLE "{7A378B}"
#define COLOR_GREEN 			0x008000FF
#define COLOR_LIGHTBLUE 		0xADD8E6FF
#define COLOR_RED 				0xFF0000FF
#define COLOR_LIGHTGREEN 		0x9ACD32AA
#define CYELLOW "{9DBD1E}"
#define CORANGE "{E68C0E}"
#define CBLUE   "{39AACC}"
#define CDGREEN "{6FA828}"
#define CWHITE  "{FFFFFF}"
#define CRED    "{FF0000}"
#define COBJS1	"{D0A5D1}"
#define COBJS2  "{8FC95F}"
#define CSALMON "{FA8072}"
#define COL_WHITE "{FFFFFF}"
#define COL_RED "{F81414}"
#define COL_GREEN "{00FF22}"
#define COL_LIGHTBLUE "{00CED1}"
//=====================================[FORWARDS]===============================
forward SetPlayerSpawn(playerid);
forward ShowStats(playerid,targetid);
forward Payday();
forward SyncTime();
forward SetPlayerUnMute();
forward ScoreUpdate();
forward FixHour(hour);
forward newbietimer();
forward Unfreeze(playerid);
forward SendAdminMessage(color, string[]);
forward ABroadCast(color,const string[],level);
forward TBroadCast(color,const string[], level);
forward SendTesterMessage(color, string[]);
forward RACtime(playerid);
forward ClearChatboxToAll(playerid, lines);
forward ClearChatboxToAll2(playerid, lines);
forward OOCOff(color,const string[]);
forward ProxDetectorS(Float:radi, playerid, targetid);
forward ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5);
forward PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z);
forward split(const strsrc[], strdest[][], delimiter);
forward SetOriginalColor(playerid);
OnePlayAnim(playerid,animlib[],animname[], Float:Speed, looping, lockx, locky, lockz, lp)
{
	ApplyAnimation(playerid, animlib, animname, Speed, looping, lockx, locky, lockz, lp);
}
LoopingAnim(playerid,animlib[],animname[], Float:Speed, looping, lockx, locky, lockz, lp)
{
    ApplyAnimation(playerid, animlib, animname, Speed, looping, lockx, locky, lockz, lp);
}
//==================================DEALERSHIP==================================
forward MainTimer();
forward SaveTimer();
forward StopAlarm(vehicleid);
//===================================ENGINE=====================================
forward StartEngine(playerid);
forward DamagedEngine(playerid);
new reg1[ ] = "This is a RolePlay Server.\n{FFFFFF}DeathMatch {F81414}isn't accepted {FFFFFF}only if you have a good RP reason!.\n",
    reg2[ ] = "When you start to play you must know the basic rules.\nFor that is the next {F81414}tutorial.\n\n",
    reg3[ ] = "•Cheats or Bug Abuse is forbidden, you will end up with {F81414}Ban PERMANENT.\n",
    reg4[ ] = "•Keep a decent {F81414}language {FFFFFF}on the server.\n",
    reg5[ ] = "•Spamming will lead you to {F81414}mute/kick.\n",
    reg6[ ] = "•DriveBy isn't allowed, only with a {F81414}good {FFFFFF}RP reason.\n",
    reg7[ ] = "•Remember, ALWAYS RolePlay.\n",
    reg8[ ] = "\n\n{F81414}changeme {F3FF02}wishes you good luck!";
//==================================[ENUMS]=====================================
enum pInfo
{
    pPass,
    pLevel,
    pSex,
    pAge,
    pOrigin,
    pPlace,
    pCash,
	pExp,
    pAdmin,
    pNumber,
    pTester,
    pWarns,
	pSelected,
	pMuted,
	pMuteTime,
    pFirstJoined,
    pModel,
    pVip,
    pSpawn,
    pLocked,
    pDriveLic,
};
new PlayerInfo[MAX_PLAYERS][pInfo];
forward LoadUser_data(playerid,name[],value[]);
public LoadUser_data(playerid,name[],value[])
{
    INI_Int("Password",PlayerInfo[playerid][pPass]);
    INI_Int("Level",PlayerInfo[playerid][pLevel]);
    INI_Int("Cash",PlayerInfo[playerid][pCash]);
    INI_Int("Admin",PlayerInfo[playerid][pAdmin]);
    INI_Int("Age",PlayerInfo[playerid][pAge]);
    INI_Int("Origin",PlayerInfo[playerid][pOrigin]);
    INI_Int("Sex",PlayerInfo[playerid][pSex]);
    INI_Int("Model",PlayerInfo[playerid][pModel]);
    INI_Int("DriveLic",PlayerInfo[playerid][pDriveLic]);
	INI_Int("Place",PlayerInfo[playerid][pPlace]);
	INI_Int("Exp",PlayerInfo[playerid][pExp]);
	INI_Int("Admin",PlayerInfo[playerid][pAdmin]);
	INI_Int("Number",PlayerInfo[playerid][pNumber]);
	INI_Int("Tester",PlayerInfo[playerid][pTester]);
	INI_Int("Warns",PlayerInfo[playerid][pWarns]);
	INI_Int("Selected",PlayerInfo[playerid][pSelected]);
	INI_Int("Muted",PlayerInfo[playerid][pMuted]);
	INI_Int("MuteTime",PlayerInfo[playerid][pMuteTime]);
	INI_Int("FirstJoined",PlayerInfo[playerid][pFirstJoined]);
	INI_Int("Vip",PlayerInfo[playerid][pVip]);
	INI_Int("Spawn",PlayerInfo[playerid][pSpawn]);
	INI_Int("Locked",PlayerInfo[playerid][pLocked]);
    return 1;
}
stock UserPath(playerid)
{
    new string[128],playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),PATH,playername);
    return string;
}

stock udb_hash(buf[]) { // Credits to DracoBlue
    new length=strlen(buf);
    new s1 = 1;
    new s2 = 0;
    new n;
    for (n=0; n<length; n++)
    {
       s1 = (s1 + buf[n]) % 65521;
       s2 = (s2 + s1)     % 65521;
    }
    return (s2 << 16) + s1;
}
//==============================[SYMBOLS MAX_PLAYERS]===========================
new gPlayerLogged[MAX_PLAYERS];
new gPlayerLogTries[MAX_PLAYERS];
new ntimer[MAX_PLAYERS];
new PlayerNeedsHelp[MAX_PLAYERS];
new Mobile[MAX_PLAYERS];
new RingTone[MAX_PLAYERS];
new CellTime[MAX_PLAYERS];
new gPlayerRegStep[MAX_PLAYERS];
new AdminDuty[MAX_PLAYERS];
//========================================[DMV]=================================
new dmvc;
new dmvc1;
new dmvc2;
new CP[MAX_PLAYERS];
new TakingLesson[MAX_PLAYERS];
//==============================================================================
new TesterDuty[MAX_PLAYERS];
new gPlayerTutorialing[MAX_PLAYERS];
new gOoc[MAX_PLAYERS];
new BigEar[MAX_PLAYERS];
new Text:Textdraw98[MAX_PLAYERS];
//==================================[SYMBOLS AMMOUNT]===========================
new Menu:Paper;
new Menu:Paper2;
new levelcost = 25000;
new noooc = 1;
new realchat = 1;
new levelexp = 4;
new ghour = 0;
new gminute = 0;
new gsecond = 0;
new realtime = 1;
new timeshift = -1;
new ScoreOld;
new shifthour;
//=========================================DEALERSHIP=================================================================
new SaveVehicleIndex;
new RefuelTime[MAX_PLAYERS];
new TrackCar[MAX_PLAYERS];
new Float:Fuel[MAX_VEHICLES] = {100.0, ...};
new VehicleSecurity[MAX_VEHICLES];
new VehicleCreated[MAX_DVEHICLES];
new VehicleID[MAX_DVEHICLES];
new VehicleModel[MAX_DVEHICLES];
new Float:VehiclePos[MAX_DVEHICLES][4];
new VehicleColor[MAX_DVEHICLES][2];
new VehicleInterior[MAX_DVEHICLES];
new VehicleWorld[MAX_DVEHICLES];
new VehicleOwner[MAX_DVEHICLES][MAX_PLAYER_NAME];
new VehicleNumberPlate[MAX_DVEHICLES][16];
new VehicleValue[MAX_DVEHICLES];
new VehicleTrunk[MAX_DVEHICLES][5][2];
new VehicleMods[MAX_DVEHICLES][14];
new VehiclePaintjob[MAX_DVEHICLES] = {255, ...};
new Text3D:VehicleLabel[MAX_DVEHICLES];
new DealershipCreated[MAX_DEALERSHIPS];
new Float:DealershipPos[MAX_DEALERSHIPS][3];
new Text3D:DealershipLabel[MAX_DEALERSHIPS];
new FuelStationCreated[MAX_FUEL_STATIONS];
new Float:FuelStationPos[MAX_FUEL_STATIONS][3];
new Text3D:FuelStationLabel[MAX_FUEL_STATIONS];
new VehicleNames[][] = {
	"Landstalker","Bravura","Buffalo","Linerunner","Perennial","Sentinel","Dumper","Firetruck","Trashmaster","Stretch","Manana","Infernus",
	"Voodoo","Pony","Mule","Cheetah","Ambulance","Leviathan","Moonbeam","Esperanto","Taxi","Washington","Bobcat","Mr Whoopee","BF Injection",
	"Hunter","Premier","Enforcer","Securicar","Banshee","Predator","Bus","Rhino","Barracks","Hotknife","Trailer","Previon","Coach","Cabbie",
	"Stallion","Rumpo","RC Bandit","Romero","Packer","Monster","Admiral","Squalo","Seasparrow","Pizzaboy","Tram","Trailer","Turismo","Speeder",
	"Reefer","Tropic","Flatbed","Yankee","Caddy","Solair","Berkley's RC Van","Skimmer","PCJ-600","Faggio","Freeway","RC Baron","RC Raider",
	"Glendale","Oceanic","Sanchez","Sparrow","Patriot","Quad","Coastguard","Dinghy","Hermes","Sabre","Rustler","ZR3 50","Walton","Regina",
	"Comet","BMX","Burrito","Camper","Marquis","Baggage","Dozer","Maverick","News Chopper","Rancher","FBI Rancher","Virgo","Greenwood",
	"Jetmax","Hotring","Sandking","Blista Compact","Police Maverick","Boxville","Benson","Mesa","RC Goblin","Hotring Racer A","Hotring Racer B",
	"Bloodring Banger","Rancher","Super GT","Elegant","Journey","Bike","Mountain Bike","Beagle","Cropdust","Stunt","Tanker","RoadTrain",
	"Nebula","Majestic","Buccaneer","Shamal","Hydra","FCR-900","NRG-500","HPV1000","Cement Truck","Tow Truck","Fortune","Cadrona","FBI Truck",
	"Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight","Streak","Vortex","Vincent","Bullet","Clover",
	"Sadler","Firetruck","Hustler","Intruder","Primo","Cargobob","Tampa","Sunrise","Merit","Utility","Nevada","Yosemite","Windsor","Monster A",
	"Monster B","Uranus","Jester","Sultan","Stratum","Elegy","Raindance","RC Tiger","Flash","Tahoma","Savanna","Bandito","Freight","Trailer",
	"Kart","Mower","Duneride","Sweeper","Broadway","Tornado","AT-400","DFT-30","Huntley","Stafford","BF-400","Newsvan","Tug","Trailer A","Emperor",
	"Wayfarer","Euros","Hotdog","Club","Trailer B","Trailer C","Andromada","Dodo","RC Cam","Launch","Police Car (LSPD)","Police Car (SFPD)",
	"Police Car (LVPD)","Police Ranger","Picador","S.W.A.T. Van","Alpha","Phoenix","Glendale","Sadler","Luggage Trailer A","Luggage Trailer B",
	"Stair Trailer","Boxville","Farm Plow","Utility Trailer"
};
enum MainZone
{
	Zone_Name[28],
	Float:Zone_Area[6]
}

static const SanAndreasZones[][MainZone] = {

	{"The Big Ear",	                {-410.00,1403.30,-3.00,-137.90,1681.20,200.00}},
	{"Aldea Malvada",               {-1372.10,2498.50,0.00,-1277.50,2615.30,200.00}},
	{"Angel Pine",                  {-2324.90,-2584.20,-6.10,-1964.20,-2212.10,200.00}},
	{"Arco del Oeste",              {-901.10,2221.80,0.00,-592.00,2571.90,200.00}},
	{"Avispa Country Club",         {-2646.40,-355.40,0.00,-2270.00,-222.50,200.00}},
	{"Avispa Country Club",         {-2831.80,-430.20,-6.10,-2646.40,-222.50,200.00}},
	{"Avispa Country Club",         {-2361.50,-417.10,0.00,-2270.00,-355.40,200.00}},
	{"Avispa Country Club",         {-2667.80,-302.10,-28.80,-2646.40,-262.30,71.10}},
	{"Avispa Country Club",         {-2470.00,-355.40,0.00,-2270.00,-318.40,46.10}},
	{"Avispa Country Club",         {-2550.00,-355.40,0.00,-2470.00,-318.40,39.70}},
	{"Back o Beyond",               {-1166.90,-2641.10,0.00,-321.70,-1856.00,200.00}},
	{"Battery Point",               {-2741.00,1268.40,-4.50,-2533.00,1490.40,200.00}},
	{"Bayside",                     {-2741.00,2175.10,0.00,-2353.10,2722.70,200.00}},
	{"Bayside Marina",              {-2353.10,2275.70,0.00,-2153.10,2475.70,200.00}},
	{"Beacon Hill",                 {-399.60,-1075.50,-1.40,-319.00,-977.50,198.50}},
	{"Blackfield",                  {964.30,1203.20,-89.00,1197.30,1403.20,110.90}},
	{"Blackfield",                  {964.30,1403.20,-89.00,1197.30,1726.20,110.90}},
	{"Blackfield Chapel",           {1375.60,596.30,-89.00,1558.00,823.20,110.90}},
	{"Blackfield Chapel",           {1325.60,596.30,-89.00,1375.60,795.00,110.90}},
	{"Blackfield Intersection",     {1197.30,1044.60,-89.00,1277.00,1163.30,110.90}},
	{"Blackfield Intersection",     {1166.50,795.00,-89.00,1375.60,1044.60,110.90}},
	{"Blackfield Intersection",     {1277.00,1044.60,-89.00,1315.30,1087.60,110.90}},
	{"Blackfield Intersection",     {1375.60,823.20,-89.00,1457.30,919.40,110.90}},
	{"Blueberry",                   {104.50,-220.10,2.30,349.60,152.20,200.00}},
	{"Blueberry",                   {19.60,-404.10,3.80,349.60,-220.10,200.00}},
	{"Blueberry Acres",             {-319.60,-220.10,0.00,104.50,293.30,200.00}},
	{"Caligula's Palace",           {2087.30,1543.20,-89.00,2437.30,1703.20,110.90}},
	{"Caligula's Palace",           {2137.40,1703.20,-89.00,2437.30,1783.20,110.90}},
	{"Calton Heights",              {-2274.10,744.10,-6.10,-1982.30,1358.90,200.00}},
	{"Chinatown",                   {-2274.10,578.30,-7.60,-2078.60,744.10,200.00}},
	{"City Hall",                   {-2867.80,277.40,-9.10,-2593.40,458.40,200.00}},
	{"Come-A-Lot",                  {2087.30,943.20,-89.00,2623.10,1203.20,110.90}},
	{"Commerce",                    {1323.90,-1842.20,-89.00,1701.90,-1722.20,110.90}},
	{"Commerce",                    {1323.90,-1722.20,-89.00,1440.90,-1577.50,110.90}},
	{"Commerce",                    {1370.80,-1577.50,-89.00,1463.90,-1384.90,110.90}},
	{"Commerce",                    {1463.90,-1577.50,-89.00,1667.90,-1430.80,110.90}},
	{"Commerce",                    {1583.50,-1722.20,-89.00,1758.90,-1577.50,110.90}},
	{"Commerce",                    {1667.90,-1577.50,-89.00,1812.60,-1430.80,110.90}},
	{"Conference Center",           {1046.10,-1804.20,-89.00,1323.90,-1722.20,110.90}},
	{"Conference Center",           {1073.20,-1842.20,-89.00,1323.90,-1804.20,110.90}},
	{"Cranberry Station",           {-2007.80,56.30,0.00,-1922.00,224.70,100.00}},
	{"Creek",                       {2749.90,1937.20,-89.00,2921.60,2669.70,110.90}},
	{"Dillimore",                   {580.70,-674.80,-9.50,861.00,-404.70,200.00}},
	{"Doherty",                     {-2270.00,-324.10,-0.00,-1794.90,-222.50,200.00}},
	{"Doherty",                     {-2173.00,-222.50,-0.00,-1794.90,265.20,200.00}},
	{"Downtown",                    {-1982.30,744.10,-6.10,-1871.70,1274.20,200.00}},
	{"Downtown",                    {-1871.70,1176.40,-4.50,-1620.30,1274.20,200.00}},
	{"Downtown",                    {-1700.00,744.20,-6.10,-1580.00,1176.50,200.00}},
	{"Downtown",                    {-1580.00,744.20,-6.10,-1499.80,1025.90,200.00}},
	{"Downtown",                    {-2078.60,578.30,-7.60,-1499.80,744.20,200.00}},
	{"Downtown",                    {-1993.20,265.20,-9.10,-1794.90,578.30,200.00}},
	{"Downtown Los Santos",         {1463.90,-1430.80,-89.00,1724.70,-1290.80,110.90}},
	{"Downtown Los Santos",         {1724.70,-1430.80,-89.00,1812.60,-1250.90,110.90}},
	{"Downtown Los Santos",         {1463.90,-1290.80,-89.00,1724.70,-1150.80,110.90}},
	{"Downtown Los Santos",         {1370.80,-1384.90,-89.00,1463.90,-1170.80,110.90}},
	{"Downtown Los Santos",         {1724.70,-1250.90,-89.00,1812.60,-1150.80,110.90}},
	{"Downtown Los Santos",         {1370.80,-1170.80,-89.00,1463.90,-1130.80,110.90}},
	{"Downtown Los Santos",         {1378.30,-1130.80,-89.00,1463.90,-1026.30,110.90}},
	{"Downtown Los Santos",         {1391.00,-1026.30,-89.00,1463.90,-926.90,110.90}},
	{"Downtown Los Santos",         {1507.50,-1385.20,110.90,1582.50,-1325.30,335.90}},
	{"East Beach",                  {2632.80,-1852.80,-89.00,2959.30,-1668.10,110.90}},
	{"East Beach",                  {2632.80,-1668.10,-89.00,2747.70,-1393.40,110.90}},
	{"East Beach",                  {2747.70,-1668.10,-89.00,2959.30,-1498.60,110.90}},
	{"East Beach",                  {2747.70,-1498.60,-89.00,2959.30,-1120.00,110.90}},
	{"East Los Santos",             {2421.00,-1628.50,-89.00,2632.80,-1454.30,110.90}},
	{"East Los Santos",             {2222.50,-1628.50,-89.00,2421.00,-1494.00,110.90}},
	{"East Los Santos",             {2266.20,-1494.00,-89.00,2381.60,-1372.00,110.90}},
	{"East Los Santos",             {2381.60,-1494.00,-89.00,2421.00,-1454.30,110.90}},
	{"East Los Santos",             {2281.40,-1372.00,-89.00,2381.60,-1135.00,110.90}},
	{"East Los Santos",             {2381.60,-1454.30,-89.00,2462.10,-1135.00,110.90}},
	{"East Los Santos",             {2462.10,-1454.30,-89.00,2581.70,-1135.00,110.90}},
	{"Easter Basin",                {-1794.90,249.90,-9.10,-1242.90,578.30,200.00}},
	{"Easter Basin",                {-1794.90,-50.00,-0.00,-1499.80,249.90,200.00}},
	{"Easter Bay Airport",          {-1499.80,-50.00,-0.00,-1242.90,249.90,200.00}},
	{"Easter Bay Airport",          {-1794.90,-730.10,-3.00,-1213.90,-50.00,200.00}},
	{"Easter Bay Airport",          {-1213.90,-730.10,0.00,-1132.80,-50.00,200.00}},
	{"Easter Bay Airport",          {-1242.90,-50.00,0.00,-1213.90,578.30,200.00}},
	{"Easter Bay Airport",          {-1213.90,-50.00,-4.50,-947.90,578.30,200.00}},
	{"Easter Bay Airport",          {-1315.40,-405.30,15.40,-1264.40,-209.50,25.40}},
	{"Easter Bay Airport",          {-1354.30,-287.30,15.40,-1315.40,-209.50,25.40}},
	{"Easter Bay Airport",          {-1490.30,-209.50,15.40,-1264.40,-148.30,25.40}},
	{"Easter Bay Chemicals",        {-1132.80,-768.00,0.00,-956.40,-578.10,200.00}},
	{"Easter Bay Chemicals",        {-1132.80,-787.30,0.00,-956.40,-768.00,200.00}},
	{"El Castillo del Diablo",      {-464.50,2217.60,0.00,-208.50,2580.30,200.00}},
	{"El Castillo del Diablo",      {-208.50,2123.00,-7.60,114.00,2337.10,200.00}},
	{"El Castillo del Diablo",      {-208.50,2337.10,0.00,8.40,2487.10,200.00}},
	{"El Corona",                   {1812.60,-2179.20,-89.00,1970.60,-1852.80,110.90}},
	{"El Corona",                   {1692.60,-2179.20,-89.00,1812.60,-1842.20,110.90}},
	{"El Quebrados",                {-1645.20,2498.50,0.00,-1372.10,2777.80,200.00}},
	{"Esplanade East",              {-1620.30,1176.50,-4.50,-1580.00,1274.20,200.00}},
	{"Esplanade East",              {-1580.00,1025.90,-6.10,-1499.80,1274.20,200.00}},
	{"Esplanade East",              {-1499.80,578.30,-79.60,-1339.80,1274.20,20.30}},
	{"Esplanade North",             {-2533.00,1358.90,-4.50,-1996.60,1501.20,200.00}},
	{"Esplanade North",             {-1996.60,1358.90,-4.50,-1524.20,1592.50,200.00}},
	{"Esplanade North",             {-1982.30,1274.20,-4.50,-1524.20,1358.90,200.00}},
	{"Fallen Tree",                 {-792.20,-698.50,-5.30,-452.40,-380.00,200.00}},
	{"Fallow Bridge",               {434.30,366.50,0.00,603.00,555.60,200.00}},
	{"Fern Ridge",                  {508.10,-139.20,0.00,1306.60,119.50,200.00}},
	{"Financial",                   {-1871.70,744.10,-6.10,-1701.30,1176.40,300.00}},
	{"Fisher's Lagoon",             {1916.90,-233.30,-100.00,2131.70,13.80,200.00}},
	{"Flint Intersection",          {-187.70,-1596.70,-89.00,17.00,-1276.60,110.90}},
	{"Flint Range",                 {-594.10,-1648.50,0.00,-187.70,-1276.60,200.00}},
	{"Fort Carson",                 {-376.20,826.30,-3.00,123.70,1220.40,200.00}},
	{"Foster Valley",               {-2270.00,-430.20,-0.00,-2178.60,-324.10,200.00}},
	{"Foster Valley",               {-2178.60,-599.80,-0.00,-1794.90,-324.10,200.00}},
	{"Foster Valley",               {-2178.60,-1115.50,0.00,-1794.90,-599.80,200.00}},
	{"Foster Valley",               {-2178.60,-1250.90,0.00,-1794.90,-1115.50,200.00}},
	{"Frederick Bridge",            {2759.20,296.50,0.00,2774.20,594.70,200.00}},
	{"Gant Bridge",                 {-2741.40,1659.60,-6.10,-2616.40,2175.10,200.00}},
	{"Gant Bridge",                 {-2741.00,1490.40,-6.10,-2616.40,1659.60,200.00}},
	{"Ganton",                      {2222.50,-1852.80,-89.00,2632.80,-1722.30,110.90}},
	{"Ganton",                      {2222.50,-1722.30,-89.00,2632.80,-1628.50,110.90}},
	{"Garcia",                      {-2411.20,-222.50,-0.00,-2173.00,265.20,200.00}},
	{"Garcia",                      {-2395.10,-222.50,-5.30,-2354.00,-204.70,200.00}},
	{"Garver Bridge",               {-1339.80,828.10,-89.00,-1213.90,1057.00,110.90}},
	{"Garver Bridge",               {-1213.90,950.00,-89.00,-1087.90,1178.90,110.90}},
	{"Garver Bridge",               {-1499.80,696.40,-179.60,-1339.80,925.30,20.30}},
	{"Glen Park",                   {1812.60,-1449.60,-89.00,1996.90,-1350.70,110.90}},
	{"Glen Park",                   {1812.60,-1100.80,-89.00,1994.30,-973.30,110.90}},
	{"Glen Park",                   {1812.60,-1350.70,-89.00,2056.80,-1100.80,110.90}},
	{"Green Palms",                 {176.50,1305.40,-3.00,338.60,1520.70,200.00}},
	{"Greenglass College",          {964.30,1044.60,-89.00,1197.30,1203.20,110.90}},
	{"Greenglass College",          {964.30,930.80,-89.00,1166.50,1044.60,110.90}},
	{"Hampton Barns",               {603.00,264.30,0.00,761.90,366.50,200.00}},
	{"Hankypanky Point",            {2576.90,62.10,0.00,2759.20,385.50,200.00}},
	{"Harry Gold Parkway",          {1777.30,863.20,-89.00,1817.30,2342.80,110.90}},
	{"Hashbury",                    {-2593.40,-222.50,-0.00,-2411.20,54.70,200.00}},
	{"Hilltop Farm",                {967.30,-450.30,-3.00,1176.70,-217.90,200.00}},
	{"Hunter Quarry",               {337.20,710.80,-115.20,860.50,1031.70,203.70}},
	{"Idlewood",                    {1812.60,-1852.80,-89.00,1971.60,-1742.30,110.90}},
	{"Idlewood",                    {1812.60,-1742.30,-89.00,1951.60,-1602.30,110.90}},
	{"Idlewood",                    {1951.60,-1742.30,-89.00,2124.60,-1602.30,110.90}},
	{"Idlewood",                    {1812.60,-1602.30,-89.00,2124.60,-1449.60,110.90}},
	{"Idlewood",                    {2124.60,-1742.30,-89.00,2222.50,-1494.00,110.90}},
	{"Idlewood",                    {1971.60,-1852.80,-89.00,2222.50,-1742.30,110.90}},
	{"Jefferson",                   {1996.90,-1449.60,-89.00,2056.80,-1350.70,110.90}},
	{"Jefferson",                   {2124.60,-1494.00,-89.00,2266.20,-1449.60,110.90}},
	{"Jefferson",                   {2056.80,-1372.00,-89.00,2281.40,-1210.70,110.90}},
	{"Jefferson",                   {2056.80,-1210.70,-89.00,2185.30,-1126.30,110.90}},
	{"Jefferson",                   {2185.30,-1210.70,-89.00,2281.40,-1154.50,110.90}},
	{"Jefferson",                   {2056.80,-1449.60,-89.00,2266.20,-1372.00,110.90}},
	{"Julius Thruway East",         {2623.10,943.20,-89.00,2749.90,1055.90,110.90}},
	{"Julius Thruway East",         {2685.10,1055.90,-89.00,2749.90,2626.50,110.90}},
	{"Julius Thruway East",         {2536.40,2442.50,-89.00,2685.10,2542.50,110.90}},
	{"Julius Thruway East",         {2625.10,2202.70,-89.00,2685.10,2442.50,110.90}},
	{"Julius Thruway North",        {2498.20,2542.50,-89.00,2685.10,2626.50,110.90}},
	{"Julius Thruway North",        {2237.40,2542.50,-89.00,2498.20,2663.10,110.90}},
	{"Julius Thruway North",        {2121.40,2508.20,-89.00,2237.40,2663.10,110.90}},
	{"Julius Thruway North",        {1938.80,2508.20,-89.00,2121.40,2624.20,110.90}},
	{"Julius Thruway North",        {1534.50,2433.20,-89.00,1848.40,2583.20,110.90}},
	{"Julius Thruway North",        {1848.40,2478.40,-89.00,1938.80,2553.40,110.90}},
	{"Julius Thruway North",        {1704.50,2342.80,-89.00,1848.40,2433.20,110.90}},
	{"Julius Thruway North",        {1377.30,2433.20,-89.00,1534.50,2507.20,110.90}},
	{"Julius Thruway South",        {1457.30,823.20,-89.00,2377.30,863.20,110.90}},
	{"Julius Thruway South",        {2377.30,788.80,-89.00,2537.30,897.90,110.90}},
	{"Julius Thruway West",         {1197.30,1163.30,-89.00,1236.60,2243.20,110.90}},
	{"Julius Thruway West",         {1236.60,2142.80,-89.00,1297.40,2243.20,110.90}},
	{"Juniper Hill",                {-2533.00,578.30,-7.60,-2274.10,968.30,200.00}},
	{"Juniper Hollow",              {-2533.00,968.30,-6.10,-2274.10,1358.90,200.00}},
	{"K.A.C.C. Military Fuels",     {2498.20,2626.50,-89.00,2749.90,2861.50,110.90}},
	{"Kincaid Bridge",              {-1339.80,599.20,-89.00,-1213.90,828.10,110.90}},
	{"Kincaid Bridge",              {-1213.90,721.10,-89.00,-1087.90,950.00,110.90}},
	{"Kincaid Bridge",              {-1087.90,855.30,-89.00,-961.90,986.20,110.90}},
	{"King's",                      {-2329.30,458.40,-7.60,-1993.20,578.30,200.00}},
	{"King's",                      {-2411.20,265.20,-9.10,-1993.20,373.50,200.00}},
	{"King's",                      {-2253.50,373.50,-9.10,-1993.20,458.40,200.00}},
	{"LVA Freight Depot",           {1457.30,863.20,-89.00,1777.40,1143.20,110.90}},
	{"LVA Freight Depot",           {1375.60,919.40,-89.00,1457.30,1203.20,110.90}},
	{"LVA Freight Depot",           {1277.00,1087.60,-89.00,1375.60,1203.20,110.90}},
	{"LVA Freight Depot",           {1315.30,1044.60,-89.00,1375.60,1087.60,110.90}},
	{"LVA Freight Depot",           {1236.60,1163.40,-89.00,1277.00,1203.20,110.90}},
	{"Las Barrancas",               {-926.10,1398.70,-3.00,-719.20,1634.60,200.00}},
	{"Las Brujas",                  {-365.10,2123.00,-3.00,-208.50,2217.60,200.00}},
	{"Las Colinas",                 {1994.30,-1100.80,-89.00,2056.80,-920.80,110.90}},
	{"Las Colinas",                 {2056.80,-1126.30,-89.00,2126.80,-920.80,110.90}},
	{"Las Colinas",                 {2185.30,-1154.50,-89.00,2281.40,-934.40,110.90}},
	{"Las Colinas",                 {2126.80,-1126.30,-89.00,2185.30,-934.40,110.90}},
	{"Las Colinas",                 {2747.70,-1120.00,-89.00,2959.30,-945.00,110.90}},
	{"Las Colinas",                 {2632.70,-1135.00,-89.00,2747.70,-945.00,110.90}},
	{"Las Colinas",                 {2281.40,-1135.00,-89.00,2632.70,-945.00,110.90}},
	{"Las Payasadas",               {-354.30,2580.30,2.00,-133.60,2816.80,200.00}},
	{"Las Venturas Airport",        {1236.60,1203.20,-89.00,1457.30,1883.10,110.90}},
	{"Las Venturas Airport",        {1457.30,1203.20,-89.00,1777.30,1883.10,110.90}},
	{"Las Venturas Airport",        {1457.30,1143.20,-89.00,1777.40,1203.20,110.90}},
	{"Las Venturas Airport",        {1515.80,1586.40,-12.50,1729.90,1714.50,87.50}},
	{"Last Dime Motel",             {1823.00,596.30,-89.00,1997.20,823.20,110.90}},
	{"Leafy Hollow",                {-1166.90,-1856.00,0.00,-815.60,-1602.00,200.00}},
	{"Liberty City",                {-1000.00,400.00,1300.00,-700.00,600.00,1400.00}},
	{"Lil' Probe Inn",              {-90.20,1286.80,-3.00,153.80,1554.10,200.00}},
	{"Linden Side",                 {2749.90,943.20,-89.00,2923.30,1198.90,110.90}},
	{"Linden Station",              {2749.90,1198.90,-89.00,2923.30,1548.90,110.90}},
	{"Linden Station",              {2811.20,1229.50,-39.50,2861.20,1407.50,60.40}},
	{"Little Mexico",               {1701.90,-1842.20,-89.00,1812.60,-1722.20,110.90}},
	{"Little Mexico",               {1758.90,-1722.20,-89.00,1812.60,-1577.50,110.90}},
	{"Los Flores",                  {2581.70,-1454.30,-89.00,2632.80,-1393.40,110.90}},
	{"Los Flores",                  {2581.70,-1393.40,-89.00,2747.70,-1135.00,110.90}},
	{"Los Santos International",    {1249.60,-2394.30,-89.00,1852.00,-2179.20,110.90}},
	{"Los Santos International",    {1852.00,-2394.30,-89.00,2089.00,-2179.20,110.90}},
	{"Los Santos International",    {1382.70,-2730.80,-89.00,2201.80,-2394.30,110.90}},
	{"Los Santos International",    {1974.60,-2394.30,-39.00,2089.00,-2256.50,60.90}},
	{"Los Santos International",    {1400.90,-2669.20,-39.00,2189.80,-2597.20,60.90}},
	{"Los Santos International",    {2051.60,-2597.20,-39.00,2152.40,-2394.30,60.90}},
	{"Marina",                      {647.70,-1804.20,-89.00,851.40,-1577.50,110.90}},
	{"Marina",                      {647.70,-1577.50,-89.00,807.90,-1416.20,110.90}},
	{"Marina",                      {807.90,-1577.50,-89.00,926.90,-1416.20,110.90}},
	{"Market",                      {787.40,-1416.20,-89.00,1072.60,-1310.20,110.90}},
	{"Market",                      {952.60,-1310.20,-89.00,1072.60,-1130.80,110.90}},
	{"Market",                      {1072.60,-1416.20,-89.00,1370.80,-1130.80,110.90}},
	{"Market",                      {926.90,-1577.50,-89.00,1370.80,-1416.20,110.90}},
	{"Market Station",              {787.40,-1410.90,-34.10,866.00,-1310.20,65.80}},
	{"Martin Bridge",               {-222.10,293.30,0.00,-122.10,476.40,200.00}},
	{"Missionary Hill",             {-2994.40,-811.20,0.00,-2178.60,-430.20,200.00}},
	{"Montgomery",                  {1119.50,119.50,-3.00,1451.40,493.30,200.00}},
	{"Montgomery",                  {1451.40,347.40,-6.10,1582.40,420.80,200.00}},
	{"Montgomery Intersection",     {1546.60,208.10,0.00,1745.80,347.40,200.00}},
	{"Montgomery Intersection",     {1582.40,347.40,0.00,1664.60,401.70,200.00}},
	{"Mulholland",                  {1414.00,-768.00,-89.00,1667.60,-452.40,110.90}},
	{"Mulholland",                  {1281.10,-452.40,-89.00,1641.10,-290.90,110.90}},
	{"Mulholland",                  {1269.10,-768.00,-89.00,1414.00,-452.40,110.90}},
	{"Mulholland",                  {1357.00,-926.90,-89.00,1463.90,-768.00,110.90}},
	{"Mulholland",                  {1318.10,-910.10,-89.00,1357.00,-768.00,110.90}},
	{"Mulholland",                  {1169.10,-910.10,-89.00,1318.10,-768.00,110.90}},
	{"Mulholland",                  {768.60,-954.60,-89.00,952.60,-860.60,110.90}},
	{"Mulholland",                  {687.80,-860.60,-89.00,911.80,-768.00,110.90}},
	{"Mulholland",                  {737.50,-768.00,-89.00,1142.20,-674.80,110.90}},
	{"Mulholland",                  {1096.40,-910.10,-89.00,1169.10,-768.00,110.90}},
	{"Mulholland",                  {952.60,-937.10,-89.00,1096.40,-860.60,110.90}},
	{"Mulholland",                  {911.80,-860.60,-89.00,1096.40,-768.00,110.90}},
	{"Mulholland",                  {861.00,-674.80,-89.00,1156.50,-600.80,110.90}},
	{"Mulholland Intersection",     {1463.90,-1150.80,-89.00,1812.60,-768.00,110.90}},
	{"North Rock",                  {2285.30,-768.00,0.00,2770.50,-269.70,200.00}},
	{"Ocean Docks",                 {2373.70,-2697.00,-89.00,2809.20,-2330.40,110.90}},
	{"Ocean Docks",                 {2201.80,-2418.30,-89.00,2324.00,-2095.00,110.90}},
	{"Ocean Docks",                 {2324.00,-2302.30,-89.00,2703.50,-2145.10,110.90}},
	{"Ocean Docks",                 {2089.00,-2394.30,-89.00,2201.80,-2235.80,110.90}},
	{"Ocean Docks",                 {2201.80,-2730.80,-89.00,2324.00,-2418.30,110.90}},
	{"Ocean Docks",                 {2703.50,-2302.30,-89.00,2959.30,-2126.90,110.90}},
	{"Ocean Docks",                 {2324.00,-2145.10,-89.00,2703.50,-2059.20,110.90}},
	{"Ocean Flats",                 {-2994.40,277.40,-9.10,-2867.80,458.40,200.00}},
	{"Ocean Flats",                 {-2994.40,-222.50,-0.00,-2593.40,277.40,200.00}},
	{"Ocean Flats",                 {-2994.40,-430.20,-0.00,-2831.80,-222.50,200.00}},
	{"Octane Springs",              {338.60,1228.50,0.00,664.30,1655.00,200.00}},
	{"Old Venturas Strip",          {2162.30,2012.10,-89.00,2685.10,2202.70,110.90}},
	{"Palisades",                   {-2994.40,458.40,-6.10,-2741.00,1339.60,200.00}},
	{"Palomino Creek",              {2160.20,-149.00,0.00,2576.90,228.30,200.00}},
	{"Paradiso",                    {-2741.00,793.40,-6.10,-2533.00,1268.40,200.00}},
	{"Pershing Square",             {1440.90,-1722.20,-89.00,1583.50,-1577.50,110.90}},
	{"Pilgrim",                     {2437.30,1383.20,-89.00,2624.40,1783.20,110.90}},
	{"Pilgrim",                     {2624.40,1383.20,-89.00,2685.10,1783.20,110.90}},
	{"Pilson Intersection",         {1098.30,2243.20,-89.00,1377.30,2507.20,110.90}},
	{"Pirates in Men's Pants",      {1817.30,1469.20,-89.00,2027.40,1703.20,110.90}},
	{"Playa del Seville",           {2703.50,-2126.90,-89.00,2959.30,-1852.80,110.90}},
	{"Prickle Pine",                {1534.50,2583.20,-89.00,1848.40,2863.20,110.90}},
	{"Prickle Pine",                {1117.40,2507.20,-89.00,1534.50,2723.20,110.90}},
	{"Prickle Pine",                {1848.40,2553.40,-89.00,1938.80,2863.20,110.90}},
	{"Prickle Pine",                {1938.80,2624.20,-89.00,2121.40,2861.50,110.90}},
	{"Queens",                      {-2533.00,458.40,0.00,-2329.30,578.30,200.00}},
	{"Queens",                      {-2593.40,54.70,0.00,-2411.20,458.40,200.00}},
	{"Queens",                      {-2411.20,373.50,0.00,-2253.50,458.40,200.00}},
	{"Randolph Industrial",         {1558.00,596.30,-89.00,1823.00,823.20,110.90}},
	{"Redsands East",               {1817.30,2011.80,-89.00,2106.70,2202.70,110.90}},
	{"Redsands East",               {1817.30,2202.70,-89.00,2011.90,2342.80,110.90}},
	{"Redsands East",               {1848.40,2342.80,-89.00,2011.90,2478.40,110.90}},
	{"Redsands West",               {1236.60,1883.10,-89.00,1777.30,2142.80,110.90}},
	{"Redsands West",               {1297.40,2142.80,-89.00,1777.30,2243.20,110.90}},
	{"Redsands West",               {1377.30,2243.20,-89.00,1704.50,2433.20,110.90}},
	{"Redsands West",               {1704.50,2243.20,-89.00,1777.30,2342.80,110.90}},
	{"Regular Tom",                 {-405.70,1712.80,-3.00,-276.70,1892.70,200.00}},
	{"Richman",                     {647.50,-1118.20,-89.00,787.40,-954.60,110.90}},
	{"Richman",                     {647.50,-954.60,-89.00,768.60,-860.60,110.90}},
	{"Richman",                     {225.10,-1369.60,-89.00,334.50,-1292.00,110.90}},
	{"Richman",                     {225.10,-1292.00,-89.00,466.20,-1235.00,110.90}},
	{"Richman",                     {72.60,-1404.90,-89.00,225.10,-1235.00,110.90}},
	{"Richman",                     {72.60,-1235.00,-89.00,321.30,-1008.10,110.90}},
	{"Richman",                     {321.30,-1235.00,-89.00,647.50,-1044.00,110.90}},
	{"Richman",                     {321.30,-1044.00,-89.00,647.50,-860.60,110.90}},
	{"Richman",                     {321.30,-860.60,-89.00,687.80,-768.00,110.90}},
	{"Richman",                     {321.30,-768.00,-89.00,700.70,-674.80,110.90}},
	{"Robada Intersection",         {-1119.00,1178.90,-89.00,-862.00,1351.40,110.90}},
	{"Roca Escalante",              {2237.40,2202.70,-89.00,2536.40,2542.50,110.90}},
	{"Roca Escalante",              {2536.40,2202.70,-89.00,2625.10,2442.50,110.90}},
	{"Rockshore East",              {2537.30,676.50,-89.00,2902.30,943.20,110.90}},
	{"Rockshore West",              {1997.20,596.30,-89.00,2377.30,823.20,110.90}},
	{"Rockshore West",              {2377.30,596.30,-89.00,2537.30,788.80,110.90}},
	{"Rodeo",                       {72.60,-1684.60,-89.00,225.10,-1544.10,110.90}},
	{"Rodeo",                       {72.60,-1544.10,-89.00,225.10,-1404.90,110.90}},
	{"Rodeo",                       {225.10,-1684.60,-89.00,312.80,-1501.90,110.90}},
	{"Rodeo",                       {225.10,-1501.90,-89.00,334.50,-1369.60,110.90}},
	{"Rodeo",                       {334.50,-1501.90,-89.00,422.60,-1406.00,110.90}},
	{"Rodeo",                       {312.80,-1684.60,-89.00,422.60,-1501.90,110.90}},
	{"Rodeo",                       {422.60,-1684.60,-89.00,558.00,-1570.20,110.90}},
	{"Rodeo",                       {558.00,-1684.60,-89.00,647.50,-1384.90,110.90}},
	{"Rodeo",                       {466.20,-1570.20,-89.00,558.00,-1385.00,110.90}},
	{"Rodeo",                       {422.60,-1570.20,-89.00,466.20,-1406.00,110.90}},
	{"Rodeo",                       {466.20,-1385.00,-89.00,647.50,-1235.00,110.90}},
	{"Rodeo",                       {334.50,-1406.00,-89.00,466.20,-1292.00,110.90}},
	{"Royal Casino",                {2087.30,1383.20,-89.00,2437.30,1543.20,110.90}},
	{"San Andreas Sound",           {2450.30,385.50,-100.00,2759.20,562.30,200.00}},
	{"Santa Flora",                 {-2741.00,458.40,-7.60,-2533.00,793.40,200.00}},
	{"Santa Maria Beach",           {342.60,-2173.20,-89.00,647.70,-1684.60,110.90}},
	{"Santa Maria Beach",           {72.60,-2173.20,-89.00,342.60,-1684.60,110.90}},
	{"Shady Cabin",                 {-1632.80,-2263.40,-3.00,-1601.30,-2231.70,200.00}},
	{"Shady Creeks",                {-1820.60,-2643.60,-8.00,-1226.70,-1771.60,200.00}},
	{"Shady Creeks",                {-2030.10,-2174.80,-6.10,-1820.60,-1771.60,200.00}},
	{"Sobell Rail Yards",           {2749.90,1548.90,-89.00,2923.30,1937.20,110.90}},
	{"Spinybed",                    {2121.40,2663.10,-89.00,2498.20,2861.50,110.90}},
	{"Starfish Casino",             {2437.30,1783.20,-89.00,2685.10,2012.10,110.90}},
	{"Starfish Casino",             {2437.30,1858.10,-39.00,2495.00,1970.80,60.90}},
	{"Starfish Casino",             {2162.30,1883.20,-89.00,2437.30,2012.10,110.90}},
	{"Temple",                      {1252.30,-1130.80,-89.00,1378.30,-1026.30,110.90}},
	{"Temple",                      {1252.30,-1026.30,-89.00,1391.00,-926.90,110.90}},
	{"Temple",                      {1252.30,-926.90,-89.00,1357.00,-910.10,110.90}},
	{"Temple",                      {952.60,-1130.80,-89.00,1096.40,-937.10,110.90}},
	{"Temple",                      {1096.40,-1130.80,-89.00,1252.30,-1026.30,110.90}},
	{"Temple",                      {1096.40,-1026.30,-89.00,1252.30,-910.10,110.90}},
	{"The Camel's Toe",             {2087.30,1203.20,-89.00,2640.40,1383.20,110.90}},
	{"The Clown's Pocket",          {2162.30,1783.20,-89.00,2437.30,1883.20,110.90}},
	{"The Emerald Isle",            {2011.90,2202.70,-89.00,2237.40,2508.20,110.90}},
	{"The Farm",                    {-1209.60,-1317.10,114.90,-908.10,-787.30,251.90}},
	{"Four Dragons Casino",         {1817.30,863.20,-89.00,2027.30,1083.20,110.90}},
	{"The High Roller",             {1817.30,1283.20,-89.00,2027.30,1469.20,110.90}},
	{"The Mako Span",               {1664.60,401.70,0.00,1785.10,567.20,200.00}},
	{"The Panopticon",              {-947.90,-304.30,-1.10,-319.60,327.00,200.00}},
	{"The Pink Swan",               {1817.30,1083.20,-89.00,2027.30,1283.20,110.90}},
	{"The Sherman Dam",             {-968.70,1929.40,-3.00,-481.10,2155.20,200.00}},
	{"The Strip",                   {2027.40,863.20,-89.00,2087.30,1703.20,110.90}},
	{"The Strip",                   {2106.70,1863.20,-89.00,2162.30,2202.70,110.90}},
	{"The Strip",                   {2027.40,1783.20,-89.00,2162.30,1863.20,110.90}},
	{"The Strip",                   {2027.40,1703.20,-89.00,2137.40,1783.20,110.90}},
	{"The Visage",                  {1817.30,1863.20,-89.00,2106.70,2011.80,110.90}},
	{"The Visage",                  {1817.30,1703.20,-89.00,2027.40,1863.20,110.90}},
	{"Unity Station",               {1692.60,-1971.80,-20.40,1812.60,-1932.80,79.50}},
	{"Valle Ocultado",              {-936.60,2611.40,2.00,-715.90,2847.90,200.00}},
	{"Verdant Bluffs",              {930.20,-2488.40,-89.00,1249.60,-2006.70,110.90}},
	{"Verdant Bluffs",              {1073.20,-2006.70,-89.00,1249.60,-1842.20,110.90}},
	{"Verdant Bluffs",              {1249.60,-2179.20,-89.00,1692.60,-1842.20,110.90}},
	{"Verdant Meadows",             {37.00,2337.10,-3.00,435.90,2677.90,200.00}},
	{"Verona Beach",                {647.70,-2173.20,-89.00,930.20,-1804.20,110.90}},
	{"Verona Beach",                {930.20,-2006.70,-89.00,1073.20,-1804.20,110.90}},
	{"Verona Beach",                {851.40,-1804.20,-89.00,1046.10,-1577.50,110.90}},
	{"Verona Beach",                {1161.50,-1722.20,-89.00,1323.90,-1577.50,110.90}},
	{"Verona Beach",                {1046.10,-1722.20,-89.00,1161.50,-1577.50,110.90}},
	{"Vinewood",                    {787.40,-1310.20,-89.00,952.60,-1130.80,110.90}},
	{"Vinewood",                    {787.40,-1130.80,-89.00,952.60,-954.60,110.90}},
	{"Vinewood",                    {647.50,-1227.20,-89.00,787.40,-1118.20,110.90}},
	{"Vinewood",                    {647.70,-1416.20,-89.00,787.40,-1227.20,110.90}},
	{"Whitewood Estates",           {883.30,1726.20,-89.00,1098.30,2507.20,110.90}},
	{"Whitewood Estates",           {1098.30,1726.20,-89.00,1197.30,2243.20,110.90}},
	{"Willowfield",                 {1970.60,-2179.20,-89.00,2089.00,-1852.80,110.90}},
	{"Willowfield",                 {2089.00,-2235.80,-89.00,2201.80,-1989.90,110.90}},
	{"Willowfield",                 {2089.00,-1989.90,-89.00,2324.00,-1852.80,110.90}},
	{"Willowfield",                 {2201.80,-2095.00,-89.00,2324.00,-1989.90,110.90}},
	{"Willowfield",                 {2541.70,-1941.40,-89.00,2703.50,-1852.80,110.90}},
	{"Willowfield",                 {2324.00,-2059.20,-89.00,2541.70,-1852.80,110.90}},
	{"Willowfield",                 {2541.70,-2059.20,-89.00,2703.50,-1941.40,110.90}},
	{"Yellow Bell Station",         {1377.40,2600.40,-21.90,1492.40,2687.30,78.00}},
	// Citys Zones
	{"Los Santos",                  {44.60,-2892.90,-242.90,2997.00,-768.00,900.00}},
	{"Las Venturas",                {869.40,596.30,-242.90,2997.00,2993.80,900.00}},
	{"Bone County",                 {-480.50,596.30,-242.90,869.40,2993.80,900.00}},
	{"Tierra Robada",               {-2997.40,1659.60,-242.90,-480.50,2993.80,900.00}},
	{"Tierra Robada",               {-1213.90,596.30,-242.90,-480.50,1659.60,900.00}},
	{"San Fierro",                  {-2997.40,-1115.50,-242.90,-1213.90,1659.60,900.00}},
	{"Red County",                  {-1213.90,-768.00,-242.90,2997.00,596.30,900.00}},
	{"Flint County",                {-1213.90,-2892.90,-242.90,44.60,-768.00,900.00}},
	{"Whetstone",                   {-2997.40,-2892.90,-242.90,-1213.90,-1115.50,900.00}}
};
//=================================Engine=======================================
new vehEngine[MAX_VEHICLES];
//===========================[MAIN]=============================================
main()
{
	printf("-------------------------------------");
	printf("changeme ");
	printf("-------------------------------------");
	printf("By Jafet Macario");
}
//==========================[CALLBACKS]=========================================
public Unfreeze(playerid)
{
	TogglePlayerControllable(playerid, 1);
	return 1;
}
public SyncTime()
{
	new string[64];
	new tmphour;
	new tmpminute;
	new tmpsecond;
	gettime(tmphour, tmpminute, tmpsecond);
	FixHour(tmphour);
	tmphour = shifthour;
	if ((tmphour > ghour) || (tmphour == 0 && ghour == 23))
	{
		format(string, sizeof(string), "SERVER: The time is now %d:00 hours",tmphour);
		SendClientMessageToAll(COLOR_WHITE,string);
		ghour = tmphour;
		Payday();
		if (realtime)
		{
			SetWorldTime(tmphour);
		}
	}
}
public OnPlayerEnterCheckpoint(playerid)
{
    if(CP[playerid]==200)//dmv_01
	{
		if(IsPlayerInVehicle(playerid, dmvc) || IsPlayerInVehicle(playerid, dmvc1) || IsPlayerInVehicle(playerid, dmvc2))
		{
	    	DisablePlayerCheckpoint(playerid);
			CP[playerid] = 201;
			SetPlayerCheckpoint(playerid, 1432.4354,-1658.6343,13.1245, 5.0);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTBLUE,"DMV: You are not in the car!");
		    SendClientMessage(playerid, COLOR_LIGHTBLUE,"DMV: You didn't passed the test, please try again!");
		    DisablePlayerCheckpoint(playerid);
    		RemovePlayerFromVehicle(playerid);
  			SetVehicleToRespawn(GetPlayerVehicleID(playerid));
  			TakingLesson[playerid] = 0;
		}
	}
	else if(CP[playerid]==201)//dmv_02
	{
	    DisablePlayerCheckpoint(playerid);
		CP[playerid] = 202;
		SetPlayerCheckpoint(playerid, 1432.3827,-1588.9227,13.1318, 5.0);
	}
	else if(CP[playerid]==202)//dmv_03
	{
	    DisablePlayerCheckpoint(playerid);
		CP[playerid] = 203;
		SetPlayerCheckpoint(playerid, 1454.7500,-1480.2014,13.0978, 5.0);
	}
	else if(CP[playerid]==203)//dmv_04
	{
	    DisablePlayerCheckpoint(playerid);
		CP[playerid] = 204;
		SetPlayerCheckpoint(playerid, 1457.2000,-1439.2382,13.1303, 5.0);
	}
	else if(CP[playerid]==204)//dmv_05
	{
	    DisablePlayerCheckpoint(playerid);
		CP[playerid] = 205;
		SetPlayerCheckpoint(playerid, 1429.9436,-1437.6150,13.1244, 5.0);
	}
   	else if(CP[playerid]==205)//dmv_06
	{
	    DisablePlayerCheckpoint(playerid);
		CP[playerid] = 206;
		SetPlayerCheckpoint(playerid, 1423.7155,-1398.9248,13.1238, 5.0);
	}
	else if(CP[playerid]==206)//dmv_07
	{
	    DisablePlayerCheckpoint(playerid);
		CP[playerid] = 207;
		SetPlayerCheckpoint(playerid, 1350.0922,-1393.0492,13.1469, 5.0);
	}
	else if(CP[playerid]==207)//dmv_08
	{
	    DisablePlayerCheckpoint(playerid);
		CP[playerid] = 208;
		SetPlayerCheckpoint(playerid, 1106.5748,-1397.0431,13.1716, 5.0);
	}
	else if(CP[playerid]==208)//dmv_09
	{
	    DisablePlayerCheckpoint(playerid);
		CP[playerid] = 209;
		SetPlayerCheckpoint(playerid, 1059.6833,-1419.8898,13.1155, 5.0);
	}
	else if(CP[playerid]==209)//dmv_10
	{
	    DisablePlayerCheckpoint(playerid);
		CP[playerid] = 210;
		SetPlayerCheckpoint(playerid, 1035.0563,-1571.5737,13.1341, 5.0);
	}
	else if(CP[playerid]==210)//dmv_11
	{
	    DisablePlayerCheckpoint(playerid);
		CP[playerid] = 211;
		SetPlayerCheckpoint(playerid, 1143.5441,-1574.9717,13.0121, 5.0);
	}
	else if(CP[playerid]==211)//dmv_12
	{
	    DisablePlayerCheckpoint(playerid);
		CP[playerid] = 212;
		SetPlayerCheckpoint(playerid, 1289.9336,-1574.8125,13.1246, 5.0);
	}
	else if(CP[playerid]==212)//dmv_13
	{
	    DisablePlayerCheckpoint(playerid);
		CP[playerid] = 213;
		SetPlayerCheckpoint(playerid, 1295.0909,-1659.1091,13.1246, 5.0);
	}
	else if(CP[playerid]==213)//dmv_14
	{
		DisablePlayerCheckpoint(playerid);
		CP[playerid] = 214;
		SetPlayerCheckpoint(playerid, 1295.0031,-1704.4797,13.1240, 5.0);
	}
	else if(CP[playerid]==214)//dmv_15
	{
	    DisablePlayerCheckpoint(playerid);
		CP[playerid] = 215;
		SetPlayerCheckpoint(playerid, 1299.5117,-1817.1479,13.1245, 5.0);
	}
	else if(CP[playerid]==215)//dmv_16
	{
	    DisablePlayerCheckpoint(playerid);
		CP[playerid] = 216;
		SetPlayerCheckpoint(playerid, 1300.8134,-1855.0059,13.1245, 5.0);
	}
	else if(CP[playerid]==216)//dmv_17
	{
	    DisablePlayerCheckpoint(playerid);
		CP[playerid] = 217;
		SetPlayerCheckpoint(playerid, 1389.0083,-1874.1768,13.1245, 5.0);
	}
	else if(CP[playerid]==217)//dmv_18
	{
	    DisablePlayerCheckpoint(playerid);
		CP[playerid] = 218;
		SetPlayerCheckpoint(playerid, 1523.0303,-1874.8875,13.1266, 5.0);
	}
	else if(CP[playerid]==218)//dmv_19
	{
	    DisablePlayerCheckpoint(playerid);
		CP[playerid] = 219;
		SetPlayerCheckpoint(playerid, 1571.1161,-1872.5188,13.1252, 5.0);
	}
	else if(CP[playerid]==219)//dmv_20
	{
	    DisablePlayerCheckpoint(playerid);
		CP[playerid] = 220;
		SetPlayerCheckpoint(playerid, 1572.3271,-1733.9789,13.1269, 5.0);
	}
	else if(CP[playerid]==220)//dmv_21
	{
	    DisablePlayerCheckpoint(playerid);
		CP[playerid] = 221;
		SetPlayerCheckpoint(playerid, 1531.4258,-1730.1346,13.1245, 5.0);
	}
	else if(CP[playerid]==221)//dmv_22
	{
	    DisablePlayerCheckpoint(playerid);
		CP[playerid] = 222;
		SetPlayerCheckpoint(playerid, 1437.5671,-1730.2736,13.1254, 5.0);
	}
	else if(CP[playerid]==222)//dmv_23
	{
	    DisablePlayerCheckpoint(playerid);
		CP[playerid] = 223;
		SetPlayerCheckpoint(playerid, 1424.2367,-1694.3533,13.2030, 5.0);
	}
	else if(CP[playerid]==223)//dmv_Final
	{
		new pName[24];
		new str[128];
		GetPlayerName(playerid, pName, 24);
		pName[strfind(pName,"_")] = ' ';
		GivePlayerCash(playerid, -500);
 		format(str, 128,"DMV: Congratulations %s! You passed the test.", pName);
 		SendClientMessage(playerid, COLOR_LIGHTBLUE, str);
 		RemovePlayerFromVehicle(playerid);
  		SetVehicleToRespawn(GetPlayerVehicleID(playerid));
  		TakingLesson[playerid] = 0;
		PlayerInfo[playerid][pDriveLic] = 1;
		DisablePlayerCheckpoint(playerid);
	}
	else
	{
    	DisablePlayerCheckpoint(playerid);
	}
	return 1;
}
public OnPlayerSelectedMenuRow(playerid, row)
{
    new Menu:current;
    current = GetPlayerMenu(playerid);
    if(current == Paper)
    {
        switch(row)
        {
            case 0:
            {
				HideMenuForPlayer(Paper, playerid);
				ShowMenuForPlayer(Paper2, playerid);
			}
            case 2:
            {
				ShowMenuForPlayer(Paper, playerid);
				SendClientMessage(playerid,COLOR_GREEN,"____________How to call a taxi:_________________");
				SendClientMessage(playerid,COLOR_WHITE,"/call 444");
				SendClientMessage(playerid,COLOR_WHITE,"To stand up type /stopanim and press ENTER");
            }
            case 1:
            {
				ShowMenuForPlayer(Paper, playerid);
		        SendClientMessage(playerid,COLOR_GREEN,"____________How to get a license:______________");
		        SendClientMessage(playerid,COLOR_WHITE,"- The license costs 500$");
		        SendClientMessage(playerid,COLOR_WHITE,"- On your radar has been placed a checkpoint where you can get license");
		        SendClientMessage(playerid,COLOR_GREEN,"________________________");
		        SendClientMessage(playerid,COLOR_WHITE,"To stand up type /stopanim and press ENTER");
		        SetPlayerCheckpoint(playerid, 1432.4354,-1658.6343,13.1245,10.0);
			}
            case 3:
            {
				ShowMenuForPlayer(Paper, playerid);
		        SendClientMessage(playerid,COLOR_GREEN,"____________Where To Live:______________");
		        SendClientMessage(playerid,COLOR_WHITE,"- Rent a room in one of the houses");
		        SendClientMessage(playerid,COLOR_WHITE,"- Or stay in LS Airport motel");
		        SendClientMessage(playerid,COLOR_GREEN,"________________________");
		        SendClientMessage(playerid,COLOR_WHITE,"To stand up type /stopanim and press ENTER");
			}
            case 4:
            {
				ShowMenuForPlayer(Paper, playerid);
		        SendClientMessage(playerid,COLOR_GREEN,"____________Need a Medic?:______________");
		        SendClientMessage(playerid,COLOR_WHITE,"/call 911");
		        SendClientMessage(playerid,COLOR_GREEN,"________________________");
		        SendClientMessage(playerid,COLOR_WHITE,"To stand up type /stopanim and press ENTER");
			}
            case 5:
            {
				ShowMenuForPlayer(Paper, playerid);
		        SendClientMessage(playerid,COLOR_GREEN,"____________Need the Police?:______________");
		        SendClientMessage(playerid,COLOR_WHITE,"/call 911");
		        SendClientMessage(playerid,COLOR_GREEN,"________________________");
		        SendClientMessage(playerid,COLOR_WHITE,"To stand up type /stopanim and press ENTER");
			}
            case 6:
            {
				ShowMenuForPlayer(Paper, playerid);
		        SendClientMessage(playerid,COLOR_GREEN,"_____True RP Forums:_________");
		        SendClientMessage(playerid,COLOR_WHITE,"(Read rules and guides there)");
		        SendClientMessage(playerid,COLOR_WHITE,"forums...");
		        SendClientMessage(playerid,COLOR_GREEN,"________________________");
		        SendClientMessage(playerid,COLOR_WHITE,"To stand up type /stopanim and press ENTER");
			}
        }
	}
    if(current == Paper2)
    {
        switch(row)
        {
            case 0:
            {
                HideMenuForPlayer(Paper2, playerid);
				ShowMenuForPlayer(Paper, playerid);
			}
            case 1:
            {
				ShowMenuForPlayer(Paper, playerid);
				SendClientMessage(playerid,COLOR_GREEN,"_____________Garbage Collector_____________");
				SendClientMessage(playerid,COLOR_GREEN,"Head to the checkpoint to join this job!");
				SendClientMessage(playerid,COLOR_GREEN,"Every job has requirements,you can see them when you arrive there");
		        SendClientMessage(playerid,COLOR_GREEN,"________________________");
		        SendClientMessage(playerid,COLOR_WHITE,"To stand up type /stopanim and press ENTER");
		        SetPlayerCheckpoint(playerid,1381.2228,-1088.7719,27.3906,5.0);
            }
            case 2:
            {
				ShowMenuForPlayer(Paper, playerid);
				SendClientMessage(playerid,COLOR_GREEN,"_____________Taximeter_____________");
				SendClientMessage(playerid,COLOR_GREEN,"Head to the checkpoint to join this job!");
				SendClientMessage(playerid,COLOR_GREEN,"Every job has requirements,you can see them when you arrive there");
		        SendClientMessage(playerid,COLOR_GREEN,"________________________");
		        SendClientMessage(playerid,COLOR_WHITE,"To stand up type /stopanim and press ENTER");
		        SetPlayerCheckpoint(playerid,1381.2228,-1088.7719,27.3906,5.0);
			}
            case 3:
            {
				ShowMenuForPlayer(Paper, playerid);
				SendClientMessage(playerid,COLOR_GREEN,"_____________Fishing[Temporary Job]_____________");
				SendClientMessage(playerid,COLOR_GREEN,"Your searching for the fishing job?You found it.!");
				SendClientMessage(playerid,COLOR_GREEN,"/gofishing to get all the information.Shortly,it is a temporary job,you don't get payday from it and you can");
				SendClientMessage(playerid,COLOR_GREEN,"fish all the time without getting a contract .");
		        SendClientMessage(playerid,COLOR_GREEN,"________________________");
		        SendClientMessage(playerid,COLOR_WHITE,"To stand up type /stopanim and press ENTER");
			}
            case 4:
            {
				ShowMenuForPlayer(Paper, playerid);
				SendClientMessage(playerid,COLOR_GREEN,"_____________Mechanic[Temporary Job]_____________");
				SendClientMessage(playerid,COLOR_GREEN,"You will need a towing vehicle for this.!");
				SendClientMessage(playerid,COLOR_GREEN,"You will have to answer citizens calls and help them with their car");
				SendClientMessage(playerid,COLOR_GREEN,"Command: /mechanic");
		        SendClientMessage(playerid,COLOR_GREEN,"________________________");
		        SendClientMessage(playerid,COLOR_WHITE,"To stand up type /stopanim and press ENTER");
			}
		}
    }
	return 1;
}
public SetPlayerUnMute()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
      		if(PlayerInfo[i][pMuted] > 0)
		    {
				if(PlayerInfo[i][pMuteTime] > 0)
				{
					PlayerInfo[i][pMuteTime]--;
				}
				if(PlayerInfo[i][pMuteTime] <= 0)
				{
				    PlayerInfo[i][pMuteTime] = 0;
					if(PlayerInfo[i][pMuted] == 1)
					{
						PlayerInfo[i][pMuted] = 0;
					}
					PlayerInfo[i][pMuted] = 0;
					SendClientMessage(i,COLOR_LIGHTRED,"Your silence time has expired.You can now talk again ");
				}
			}
  		}
   	}
}

public ScoreUpdate()
{
	new Score;
	new name[MAX_PLAYER_NAME];
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i))
		{
			GetPlayerName(i, name, sizeof(name));
   			Score = PlayerInfo[i][pLevel];
			SetPlayerScore(i, Score);
			if (Score > ScoreOld)
			{
				ScoreOld = Score;
			}
		}
	}
}
public OnGameModeInit()
{
//===============================DEALERSHIP=====================================
	LoadVehicles();
	LoadDealerships();
	LoadFuelStations();
	for(new i=1; i < MAX_DVEHICLES; i++)
	{
		UpdateVehicle(i, 0);
	}
	for(new i=1; i < MAX_DEALERSHIPS; i++)
	{
		UpdateDealership(i, 0);
	}
	for(new i=1; i < MAX_FUEL_STATIONS; i++)
	{
		UpdateFuelStation(i, 0);
	}
	SetTimer("MainTimer", 1000, true);
	SetTimer("SaveTimer", 2222, true);
//==============================================================================
	printf("------ Engine System Started------- ");
	SetGameModeText("changeme");
	gettime(ghour, gminute, gsecond);
	FixHour(ghour);
	ghour = shifthour;
	if (realtime)
	{
		new tmphour;
		new tmpminute;
		new tmpsecond;
		gettime(tmphour, tmpminute, tmpsecond);
		FixHour(tmphour);
		tmphour = shifthour;
		SetWorldTime(tmphour);
	}
 	DisableInteriorEnterExits();
//============================[Menus]===========================================
 	Paper = CreateMenu("Paper", 2, 200.0, 100.0, 150.0, 150.0);
    AddMenuItem(Paper, 0, "Next Page");
    AddMenuItem(Paper, 0, "How to get a license");
    AddMenuItem(Paper, 0, "How to call a taxi");
    AddMenuItem(Paper, 0, "Where to live");
    AddMenuItem(Paper, 0, "Medic Help");
    AddMenuItem(Paper, 0, "SAPD help");
    AddMenuItem(Paper, 0, "OOC:Forums");
	Paper2 = CreateMenu("Paper2", 2, 200.0, 100.0, 150.0, 150.0);
    AddMenuItem(Paper2, 0, "Next Page");
    AddMenuItem(Paper2, 0, "Garbage Collector");
    AddMenuItem(Paper2, 0, "Taximeter");
    AddMenuItem(Paper2, 0, "Fishing");
    AddMenuItem(Paper2, 0, "Mechanic");
	Create3DTextLabel("/newspaper for information",COLOR_GREEN, 1707.8434,-2331.6506,-2.6797, 20.0,0,0);
//================================[TIMERS]=========================================
	SetTimer("SyncTime", 60000, 1);
    SetTimer("ScoreUpdate", 1000, 1);
	SetTimer("SetPlayerUnMute", 1000, 1);
    SetTimer("newbietimer", 30000, 1);
//===============================[PICKUPS]==========================================
	AddStaticPickup(1239, 23, 1707.8434,-2331.6506,-2.6797);
	AddStaticPickup(1240, 23, 1173.112426, -1320.917602, 15.396226);
	AddStaticPickup(1318, 23, 1172.914794, -1325.471313, 15.398929);
	AddStaticPickup(1318, 23, 1482.534423, -1771.555541, 18.795755);
	AddStaticPickup(1318, 23, 1555.134277, -1675.773071, 16.195312);
	AddStaticPickup(1318, 23, 1565.185180, -1666.162963, 28.395606);
	AddStaticPickup(1318, 23, 1653.883056, -1655.420898, 22.515625);
	AddStaticPickup(1247, 23, 1525.285278, -1677.911865, 5.890625);
	AddStaticPickup(1318, 23, 1568.560302, -1690.335815, 5.890625);
	AddStaticPickup(1318, 23, 1727.056884, -1636.913208, 20.217334);
	AddStaticPickup(1318, 23, 1797.998046, -1578.819091, 14.090865);
	AddStaticPickup(1240, 23, 2034.583374, -1405.004516, 17.244943);
	AddStaticPickup(1318, 23, 2233.053955, -1333.350463, 23.981575);
	AddStaticPickup(1318, 23, 2232.929931, -1159.893554, 25.890625);
	AddStaticPickup(1318, 23, 2351.947021, -1170.659545, 28.074401);
	AddStaticPickup(1318, 23, 2421.583496, -1219.243041, 25.561477);
	AddStaticPickup(1318, 23, 2166.275634, -1671.659545, 15.073946);
	AddStaticPickup(1239, 23, 2165.229736, -1672.992187, 15.077716);
	AddStaticPickup(1239, 23, 1666.597900, -1524.166992, 13.546875);
	AddStaticPickup(1318, 23, 1667.901611, -1521.946777, 13.546875);
	AddStaticPickup(1318, 23, 1568.028320, -1898.009155, 13.560886);
	AddStaticPickup(1239, 23, 2162.161376, -102.522369, 2.750000);
//==============================[VEHICLES]==========================================
	AddStaticVehicle(596,1535.8279,-1667.0283,13.1042,1.2749,0,1); // //Copcar 1
	AddStaticVehicle(596,1535.7777,-1678.2174,13.1041,359.0435,0,1); // //Copcar 2
	AddStaticVehicle(596,1602.2314,-1688.1366,5.6119,88.9127,0,1); // //Copcar 3
	AddStaticVehicle(596,1602.3998,-1696.2252,5.6117,89.5110,0,1); // //Copcar 4
	AddStaticVehicle(596,1602.2968,-1704.6088,5.6114,89.2925,0,1); // //Copcar 5
	AddStaticVehicle(596,1591.6299,-1711.7292,5.6110,0.5575,0,1); // //Copcar 6
	AddStaticVehicle(596,1583.3506,-1711.8403,5.6123,359.9798,0,1); // //Copcar 7
	AddStaticVehicle(596,1574.4407,-1711.5636,5.6112,0.4981,0,1); // //Copcar 8
	AddStaticVehicle(596,1564.4946,-1711.8907,5.6117,0.0557,0,1); // //Copcar 9
	AddStaticVehicle(597,1602.1552,-1691.9513,5.6600,90.2862,1,0); // //Copcar 10
	AddStaticVehicle(597,1602.1045,-1684.0902,5.6588,89.9887,1,0); // //Copcar 11
	AddStaticVehicle(597,1602.5887,-1700.3116,5.6600,90.1532,1,0); // //Copcar 12
	AddStaticVehicle(597,1595.2753,-1711.4293,5.6598,1.4325,1,93); // //Copcar 13
	AddStaticVehicle(597,1587.3236,-1711.8318,5.6587,359.5460,1,93); // //Copcar 14
	AddStaticVehicle(598,1578.6815,-1712.0513,5.6365,358.1766,1,93); // //Copcar 15
	AddStaticVehicle(598,1570.2655,-1711.8102,5.6356,359.8264,1,93); // //Copcar 16
	AddStaticVehicle(596,1558.4491,-1711.7164,5.6120,0.7168,1,93); // //Copcar 17
	AddStaticVehicle(596,1584.6483,-1671.5382,5.6145,270.2792,1,93); // //Copcar 18
	AddStaticVehicle(596,1584.6222,-1667.4482,5.6145,270.0910,1,93); // //Copcar 19
	AddStaticVehicle(599,1546.2502,-1650.8398,6.0786,90.8912,0,1); // //cop car 20
	AddStaticVehicle(599,1546.8645,-1659.1162,6.0787,90.3100,0,1); // //cop car 21
	AddStaticVehicle(599,1546.6399,-1667.8623,6.0780,90.4493,0,1); // //cop car 22
	AddStaticVehicle(601,1545.8365,-1655.1222,5.6494,89.7686,0,1); // //cop car Swat Tank 23
	AddStaticVehicle(528,1546.2603,-1662.9534,5.9328,89.3495,0,1); // //cop FBI truck(blue one) 24
	AddStaticVehicle(427,1530.1572,-1644.9054,6.0225,179.7986,0,1); // //SWAT Enforcer 25
	AddStaticVehicle(427,1538.6517,-1644.5701,6.0426,180.0564,0,1); // //SWAT Enforcer 26
	AddStaticVehicle(427,1534.6859,-1645.0800,6.0228,178.4550,0,1); // //SWAT Enforcer 27
	AddStaticVehicle(427,1526.0662,-1645.3656,6.0223,180.0917,0,1); // //SWAT Enforcer 28
    AddStaticVehicle(428,570.7433,-1252.2587,17.6663,292.1557,24,1); // //Bank Truck in Rodeo Car 29
	AddStaticVehicle(428,608.0444,-1237.8926,18.4802,111.9092,24,1); // //Bank Truck in Rodeo Car 30
	AddStaticVehicle(426,1543.2870,-1612.4788,13.1262,269.5055,25,25); // //Cop Undercover Car 31
	AddStaticVehicle(426,1543.1644,-1606.7509,13.1253,269.9076,25,25); // //Cop Undercover Car 32
	AddStaticVehicle(421,1555.6886,-1605.9546,13.2653,180.6853,53,53); // //Cop Undercover Car 33
	AddStaticVehicle(421,1561.6571,-1606.0315,13.2653,180.1476,53,53); // //Cop Undercover Car 34
    AddStaticVehicle(416,1177.8341,-1338.3657,14.0368,270.3866,1,3); // //Ambulance EMS Car 35
	AddStaticVehicle(416,1176.9736,-1308.6931,14.0205,267.3689,1,3); // //Ambulance EMS Car 36
    AddStaticVehicle(442,1146.2450,-1295.7229,13.4723,90.3940,1,3); // Hearse for EMS Car 37
	AddStaticVehicle(489,1146.2805,-1302.9196,13.8021,88.5398,1,3); // Rancher for EMS Car 38
	AddStaticVehicle(489,1146.2393,-1309.4309,13.8083,91.4548,1,3); // Rancher for EMS Car 39
	AddStaticVehicle(442,1145.8127,-1316.3143,13.4507,92.9838,1,3); // Hearse for EMS Car 40
	AddStaticVehicle(563,1162.4646,-1301.3418,32.2003,277.2430,1,3); // EMS Heli 41
	AddStaticVehicle(563,1163.9746,-1318.8575,32.1941,271.8757,1,3); // EMS Heli 42
	AddStaticVehicle(490,1666.7798,-1719.3749,20.6192,0.9672,0,0); // FBI 43
	AddStaticVehicle(490,1660.0472,-1719.5132,20.6102,359.8513,0,0); // FBI 44
	AddStaticVehicle(490,1671.4838,-1710.0861,20.6083,90.5516,0,0); // FBI 45
	AddStaticVehicle(490,1671.6444,-1702.4733,20.6114,92.2191,0,0); // FBI 46
	AddStaticVehicle(541,1645.6516,-1695.8042,20.0834,270.8706,0,0); // FBI Bullet Car 47
	AddStaticVehicle(541,1645.8918,-1700.3801,20.1054,270.4592,0,1); // FBI Bullet Car 48
	AddStaticVehicle(421,1646.3101,-1709.2988,20.3669,269.9211,0,1); // FBI Washington Car 49
	AddStaticVehicle(421,1646.3663,-1704.7172,20.3669,268.8617,0,1); // FBI Washington Car 50
	AddStaticVehicle(416,2037.2849,-1425.5010,17.1416,359.6898,1,3); // //County hospital ambulance Car 51
	AddStaticVehicle(416,2007.9158,-1410.9948,17.1415,90.1937,1,3); // //County hospital ambulance Car 52
	AddStaticVehicle(416,2001.8311,-1399.1924,18.3391,181.5330,1,3); // //County hospital ambulance Car 53
	AddStaticVehicle(416,2033.9324,-1447.6057,17.3766,270.3489,1,3); // //County hospital ambulance Car 54
	dmvc = AddStaticVehicle(405,1415.5630,-1706.7310,13.4196,267.9858,1,1); // license1
	dmvc1 = AddStaticVehicle(405,1416.1293,-1712.1976,13.4219,271.2856,1,1); // license2
	dmvc2 = AddStaticVehicle(405,1415.3511,-1718.4138,13.4218,267.3419,1,1); // license3
	return 1;
}
public OnGameModeExit()
{
	return 1;
}
public OnPlayerConnect(playerid)
{
	if(!IsValidName(playerid))
	{
	    SCM(playerid,COLOR_RED,"Please change your name into the following format: Firstname_Lastname");
	    Kick(playerid);
	}
	new string[128];
	new plname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, plname, sizeof(plname));
	PlayerInfo[playerid][pLevel] = 0;
	PlayerInfo[playerid][pCash] = 0;
	PlayerInfo[playerid][pDriveLic] = 0;
	PlayerInfo[playerid][pVip] = 0;
	PlayerInfo[playerid][pAdmin] = 0;
	PlayerInfo[playerid][pTester] = 0;
	PlayerInfo[playerid][pSpawn] = 0;
	PlayerInfo[playerid][pSex] = 0;
	RefuelTime[playerid] = 0;
	TrackCar[playerid] = 0;
	PlayerInfo[playerid][pAge] = 0;
	PlayerInfo[playerid][pOrigin] = 0;
	PlayerInfo[playerid][pModel] = 23;
	PlayerInfo[playerid][pLocked] = 0;
	PlayerInfo[playerid][pExp] = 0;
	PlayerInfo[playerid][pWarns] = 0;
	PlayerNeedsHelp[playerid] = 0;
	Mobile[playerid] = 255;
	PlayerInfo[playerid][pMuted] = 0;
	PlayerInfo[playerid][pMuteTime] = 0;
	gPlayerTutorialing[playerid] = 0;
	format(string, sizeof(string), "/Users/%s.ini", plname);
	new DialogString[1024];
    format(DialogString, sizeof DialogString, "%s%s%s%s%s%s%s%s", reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8);
	ShowPlayerDialog(playerid,1234, DIALOG_STYLE_MSGBOX,"Introduction...", DialogString,"Accept","Refuse");
//===================================[MAPICONS]=================================
	SetPlayerMapIcon(playerid, 1, 597.559509, -1249.448608, 18.307994, 52, 1);
	SetPlayerMapIcon(playerid, 2, 529.425354, -1293.921752, 17.242187, 55, 1);
	SetPlayerMapIcon(playerid, 3, 2127.629394, -1151.914794, 23.988607, 55, 1);
	SetPlayerMapIcon(playerid, 4, 1612.057739, -1892.647338, 13.477849, 55, 1);
	SetPlayerMapIcon(playerid, 5, 2102.669677, -1807.184570, 13.494323, 29, 1);
	SetPlayerMapIcon(playerid, 6, 2218.005126, -1168.782226, 25.655542, 31, 1);
	SetPlayerMapIcon(playerid, 7, 2229.195556, -1722.237670, 13.492409, 54, 1);
	SetPlayerMapIcon(playerid, 8, 2176.778076, -1808.995361, 13.314004, 31, 1);
	SetPlayerMapIcon(playerid, 9, 1552.876464, -1675.246948, 15.951610, 30, 1);
	SetPlayerMapIcon(playerid, 10, 1481.554321, -1769.964111, 18.725217, 32, 1);
	SetPlayerMapIcon(playerid, 11, 1931.436523, -1775.963378, 13.387728, 17, 1);
	SetPlayerMapIcon(playerid, 12, 1832.088745, -1842.122924, 13.516613, 17, 1);
	SetPlayerMapIcon(playerid, 13, 1834.615966, -1682.229736, 13.356820, 49, 1);
	SetPlayerMapIcon(playerid, 14, 1804.492553, -1574.485961, 13.355642, 30, 1);
	SetPlayerMapIcon(playerid, 15, 330.078857, -1518.715820, 35.798629, 30, 1);
	SetPlayerMapIcon(playerid, 16, 212.736221, 1903.069580, 18.079984, 30, 1);
	SetPlayerMapIcon(playerid, 17, 1383.189453, 465.504455, 20.192749, 17, 1);
	SetPlayerMapIcon(playerid, 18, 1365.520019, 249.286941, 19.257095, 29, 1);
	SetPlayerMapIcon(playerid, 19, 1315.100585, -899.391479, 39.282302, 17, 1);
	SetPlayerMapIcon(playerid, 20, 2034.685791, -1404.085327, 16.970668, 22, 1);
	SetPlayerMapIcon(playerid, 21, 1412.8313, -1700.3066, 13.5395, 55, 1);
//==============================================================================
	Textdraw98[playerid] = TextDrawCreate(146.000000, 203.000000, " "); // Tutorial
	TextDrawBackgroundColor(Textdraw98[playerid], 255);
	TextDrawUseBox(Textdraw98[playerid] , 1);
	TextDrawFont(Textdraw98[playerid], 1);
	TextDrawBoxColor(Textdraw98[playerid] ,0x00000066);
	TextDrawLetterSize(Textdraw98[playerid], 0.289899, 1.099900);
	TextDrawColor(Textdraw98[playerid], 13107455);
	TextDrawSetOutline(Textdraw98[playerid], 1);
	TextDrawSetProportional(Textdraw98[playerid], 1);
	TextDrawAlignment(Textdraw98[playerid],2);
	GivePlayerCash(playerid, PlayerInfo[playerid][pCash]);
	SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
	SetOriginalColor(playerid);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    SetPlayerCameraPos(playerid, 1677.4528,-1502.6893,152.1802);
	SetPlayerCameraLookAt(playerid, 1677.4528,-1502.6893,152.1802);
	SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
	return 1;
}
//==================================[PAYDAY]====================================
public Payday()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
		if(IsPlayerConnected(i))
		{
		    new nxtlevel;
			nxtlevel = PlayerInfo[i][pLevel]+1;
			new string[128];
        	format(string, sizeof(string), "~y~PayDay~n~~w~Paycheck");
			GameTextForPlayer(i, string, 5000, 1);
        	new payday = nxtlevel*1000;
			GivePlayerCash(i,payday);
        	PlayerInfo[i][pExp]++;
    	}
	}
	return 1;
}
//==============================================================================
public OnPlayerSpawn(playerid)
{
    if(PlayerInfo[playerid][pSelected] == 0)
	{
		new sexthings[] = "1\tMale \n2\tFemale";
		ShowPlayerDialog(playerid,155,DIALOG_STYLE_LIST,"Hello sir,please select your Sex:((This information is IC.))",sexthings,"Select","Leave Game");
		SetPlayerPos(playerid, 1685.620117,-2331.537353,-2.679687);
		gPlayerRegStep[playerid] = 1;
		new randphone = 100000 + random(899999);
		PlayerInfo[playerid][pNumber] = randphone;
		return 1;
	}
    if(PlayerInfo[playerid][pFirstJoined] == 0)
	{
	    new string[512];
	    gPlayerTutorialing[playerid] = 1;
	    SetPlayerHealth(playerid,100);
	    SetPlayerPos(playerid,1693.0609,-2292.1968,-1.2228);
	    SetPlayerCameraPos(playerid,1668.9324,-2285.8130,21.3266);//The airport
	    SetPlayerCameraLookAt(playerid,1693.0609,-2292.1968,-1.2228);
	    format(string,sizeof(string),"This is the airport,your first spawn place ~n~ You will be able to change it if~n~you will get into a faction~n~or if you will buy a house~n~Basic Commands:/help.");
	    TextDrawSetString(Textdraw98[playerid],string);
	    TextDrawShowForPlayer(playerid,Textdraw98[playerid]);
	    SendClientMessage(playerid,COLOR_WHITE,"{248B10}Tutorial:{FFFFFF}Use SPACEBAR to continue,SHIFT to go back.");
	    SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
	    return 1;
	}
	if(gPlayerLogged[playerid] == 0)
	{
    	SendClientMessage(playerid, COLOR_LIGHTRED, "** This server requires a Login BEFORE spawn (Kicked) **");
        Kick(playerid);
 	}
	SetPlayerPos(playerid, 1685.620117,-2331.537353,-2.679687);
	SetPlayerInterior(playerid,0);
	SetPlayerVirtualWorld(playerid, 0);
	SetOriginalColor(playerid);
	SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	new INI:File = INI_Open(UserPath(playerid));
    INI_SetTag(File,"data");
    INI_WriteInt(File, "Level",PlayerInfo[playerid][pLevel]);
	INI_WriteInt(File, "Money",PlayerInfo[playerid][pCash]);
	INI_WriteInt(File, "Admin",PlayerInfo[playerid][pAdmin]);
	INI_WriteInt(File, "Tester",PlayerInfo[playerid][pTester]);
	INI_WriteInt(File, "Vip",PlayerInfo[playerid][pVip]);
	INI_WriteInt(File, "Spawn",PlayerInfo[playerid][pSpawn]);
	INI_WriteInt(File, "Model",PlayerInfo[playerid][pModel]);
	INI_WriteInt(File, "Locked",PlayerInfo[playerid][pLocked]);
	INI_WriteInt(File, "FirstJoined", PlayerInfo[playerid][pFirstJoined]);
	INI_WriteInt(File, "Sex", PlayerInfo[playerid][pSex]);
	INI_WriteInt(File, "Age", PlayerInfo[playerid][pAge]);
	INI_WriteInt(File, "Origin", PlayerInfo[playerid][pOrigin]);
	INI_WriteInt(File, "Respect", PlayerInfo[playerid][pExp]);
	INI_WriteInt(File, "Warns", PlayerInfo[playerid][pWarns]);
	INI_WriteInt(File, "Selected", PlayerInfo[playerid][pSelected]);
	INI_WriteInt(File, "Continent", PlayerInfo[playerid][pPlace]);
	INI_WriteInt(File, "Muted", PlayerInfo[playerid][pMuted]);
	INI_WriteInt(File, "MuteTime", PlayerInfo[playerid][pMuteTime]);
	INI_WriteInt(File, "Ph", PlayerInfo[playerid][pNumber]);
	INI_WriteInt(File, "DriveLic", PlayerInfo[playerid][pDriveLic]);
    INI_Close(File);
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
//==================================DEALERSHIP=====================================
    if(IsPlayerInAnyVehicle(playerid) && !IsBicycle(GetPlayerVehicleID(playerid)))
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(VehicleSecurity[vehicleid] == 1)
		{
			ToggleAlarm(vehicleid, VEHICLE_PARAMS_ON);
			SetTimerEx("StopAlarm", ALARM_TIME, false, "d", vehicleid);
		}
	}
	else
	{
	}
    if(newstate == PLAYER_STATE_DRIVER)
	{
		new car = GetPlayerVehicleID(playerid);
		if(car == dmvc || car == dmvc1 || car == dmvc2)
		{
		    SCM(playerid, COLOR_GOLD,"Type /takeexam to start the Drivers License test or /exitcar to exit");
		}
		else
		{
			if(PlayerInfo[playerid][pDriveLic] < 1)
			{
				SendClientMessage(playerid, COLOR_GREY, "Get a driving license from DMV, read the newspaper !");
                RemovePlayerFromVehicle(playerid);
                TogglePlayerControllable(playerid, 0);
                SetTimer("Unfreeze", 2000, 0);
			}
		}
		new vehicleid = GetPlayerVehicleID(playerid);
		new id = GetVehicleID(vehicleid);
		if(IsValidVehicle(id))
		{
			if(VehicleCreated[id] == VEHICLE_DEALERSHIP)
			{
				SetPVarInt(playerid, "DialogValue1", id);
				ShowDialog(playerid, DIALOG_VEHICLE_BUY);
				return 1;
			}
		}
		if(IsBicycle(vehicleid))
		{
			ToggleEngine(vehicleid, VEHICLE_PARAMS_ON);
		}
		if(Fuel[vehicleid] <= 0)
		{
			ToggleEngine(vehicleid, VEHICLE_PARAMS_OFF);
		}
//=======================================ENGINE=================================
		if(vehEngine[vehicleid] == 0)
 		{
 			TogglePlayerControllable(playerid, 0);
 			SendClientMessage(playerid, COLOR_GOLD, "To start the vehicle's engine press \"Shift\" or type \"/engine\"");
		}
 		else if(vehEngine[vehicleid] == 1)
 		{
 			TogglePlayerControllable(playerid, 1);
 			SendClientMessage(playerid, COLOR_GREEN, "Vehicle engine running");
 		}
	}
    return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    new string[512];
	if(PRESSED(KEY_SPRINT))
    {
        if(gPlayerTutorialing[playerid] >= 1)
        {
            if(gPlayerTutorialing[playerid] == 1)
            {
			    gPlayerTutorialing[playerid] = 2;
			    SetPlayerPos(playerid,1412.8313, -1700.3066, 13.5395);
			    SetPlayerCameraPos(playerid,1412.8313, -1700.3066, 13.5395);//Driving School
			    SetPlayerCameraLookAt(playerid,1412.8313, -1700.3066, 13.5395);
			    format(string,sizeof(string),"This is the Driving School,you will be able ~n~to take a drive test wich will cost you~n~500$ so you will get a Driving License.~n~REMEBER:The police stops you if you~n~don't have one.");
			    TextDrawSetString(Textdraw98[playerid],string);
			    TextDrawShowForPlayer(playerid,Textdraw98[playerid]);
			    SendClientMessage(playerid,COLOR_WHITE,"{248B10}Tutorial:{FFFFFF}Use SPACEBAR to continue,SHIFT to go back.");
			    return 1;
			}
            if(gPlayerTutorialing[playerid] == 2)
            {
			    gPlayerTutorialing[playerid] = 3;
			    SetPlayerPos(playerid,1380.7892,-1088.5284,27.3844);
			    SetPlayerCameraPos(playerid,1349.7155,-1115.9375,47.7593);//Jobs Building
			    SetPlayerCameraLookAt(playerid,1380.7892,-1088.5284,27.3844);
			    format(string,sizeof(string),"If you want to earn money,you will be able to ~n~get a job.There will be a list so you~n~will have to choose one job.~n~REMEBER:Some of these jobs requests~n~a owned vehicle!");
			    TextDrawSetString(Textdraw98[playerid],string);
			    TextDrawShowForPlayer(playerid,Textdraw98[playerid]);
			    SendClientMessage(playerid,COLOR_WHITE,"{248B10}Tutorial:{FFFFFF}Use SPACEBAR to continue,SHIFT to go back.");
			    return 1;
			}
            if(gPlayerTutorialing[playerid] == 3)
            {
			    gPlayerTutorialing[playerid] = 4;
			    SetPlayerPos(playerid,1482.2841,-1025.5725,24.352);
			    SetPlayerCameraPos(playerid,1522.6703,-1041.8273,60.2691);//Casino
			    SetPlayerCameraLookAt(playerid,1482.2841,-1025.5725,24.3520);
			    format(string,sizeof(string),"If you got tired of working ~n~for someone or for your job~n~you have the possibility to play.~n~here,at the Casino!~n~Commands:/casino");
			    TextDrawSetString(Textdraw98[playerid],string);
			    TextDrawShowForPlayer(playerid,Textdraw98[playerid]);
			    SendClientMessage(playerid,COLOR_WHITE,"{248B10}Tutorial:{FFFFFF}Use SPACEBAR to continue,SHIFT to go back.");
			    return 1;
			}
            if(gPlayerTutorialing[playerid] == 4)
            {
			    gPlayerTutorialing[playerid] = 5;
			    SetPlayerPos(playerid,590.7849,-1243.1808,17.9521);
			    SetPlayerCameraPos(playerid,609.0580,-1219.5914,29.2979);//Bank
			    SetPlayerCameraLookAt(playerid,590.7849,-1243.1808,17.9521);
			    format(string,sizeof(string),"Your paydays,your money will be deposited ~n~here,at the Bank.~n~You have the possibility to:.~n~/bank deposit,withdraw,transfer,savings,etc.~n~Remember:Minimum savings value:50.000$.");
			    TextDrawSetString(Textdraw98[playerid],string);
			    TextDrawShowForPlayer(playerid,Textdraw98[playerid]);
			    SendClientMessage(playerid,COLOR_WHITE,"{248B10}Tutorial:{FFFFFF}Use SPACEBAR to continue,SHIFT to go back.");
			    return 1;
			}
            if(gPlayerTutorialing[playerid] == 5)
            {
			    gPlayerTutorialing[playerid] = 6;
			    SetPlayerPos(playerid,543.6426,-1277.8851,17.2422);
			    SetPlayerCameraPos(playerid,538.1927,-1259.2106,29.4667);//Grotti Dealership
			    SetPlayerCameraLookAt(playerid,543.6426,-1277.8851,17.2422);
			    format(string,sizeof(string),"If you have enough money,you will ~n~be able to buy a new car.");
			    TextDrawSetString(Textdraw98[playerid],string);
			    TextDrawShowForPlayer(playerid,Textdraw98[playerid]);
			    SendClientMessage(playerid,COLOR_WHITE,"{248B10}Tutorial:{FFFFFF}Use SPACEBAR to continue,SHIFT to go back.");
			    return 1;
			}
            if(gPlayerTutorialing[playerid] == 6)
            {
			    gPlayerTutorialing[playerid] = 7;
			    SetPlayerPos(playerid,617.2159,-1330.5415,13.6447);
			    SetPlayerCameraPos(playerid,652.8370,-1335.8909,28.2059);//Sector 1 Jail
			    SetPlayerCameraLookAt(playerid,617.2159,-1330.5415,13.6447);
			    format(string,sizeof(string),"If the police officers catch you ~n~they will jail you in one~n~of the jails around the city.");
			    TextDrawSetString(Textdraw98[playerid],string);
			    TextDrawShowForPlayer(playerid,Textdraw98[playerid]);
			    SendClientMessage(playerid,COLOR_WHITE,"{248B10}Tutorial:{FFFFFF}Use SPACEBAR to continue,SHIFT to go back.");
			    return 1;
			}
            if(gPlayerTutorialing[playerid] == 7)
            {
			    gPlayerTutorialing[playerid] = 8;
			    SetPlayerPos(playerid,1187.1349,-1323.7538,13.5591);
			    SetPlayerCameraPos(playerid,1206.7904,-1365.1343,27.3433);//Al Saints Hospital
			    SetPlayerCameraLookAt(playerid,1187.1349,-1323.7538,13.5591);
			    format(string,sizeof(string),"If you die,you will be asked to /accept death ~n~.When your really dead ,you will be ~n~spawned here,at Al Saints Hospital.");
			    TextDrawSetString(Textdraw98[playerid],string);
			    TextDrawShowForPlayer(playerid,Textdraw98[playerid]);
			    SendClientMessage(playerid,COLOR_WHITE,"{248B10}Tutorial:{FFFFFF}Use SPACEBAR to continue,SHIFT to go back.");
			    return 1;
			}
            if(gPlayerTutorialing[playerid] == 8)
            {
			    gPlayerTutorialing[playerid] = 9;
			    SetPlayerPos(playerid,1479.8079,-1674.9541,14.6260);
			    SetPlayerCameraPos(playerid,1396.1614,-1650.0144,59.4351);//Pershing Square
			    SetPlayerCameraLookAt(playerid,1479.8079,-1674.9541,14.6260);
			    format(string,sizeof(string),"This place is the most ~n~ safest place in Los Santos.~n~You have no right to kill/rob/rape noone here");
			    TextDrawSetString(Textdraw98[playerid],string);
			    TextDrawShowForPlayer(playerid,Textdraw98[playerid]);
			    SendClientMessage(playerid,COLOR_WHITE,"{248B10}Tutorial:{FFFFFF}Use SPACEBAR to continue,SHIFT to go back.");
			    return 1;
			}
            if(gPlayerTutorialing[playerid] == 9)
            {
			    gPlayerTutorialing[playerid] = 0;
			    PlayerInfo[playerid][pFirstJoined] = 1;
			    PlayerInfo[playerid][pSelected] = 0;
			    SpawnPlayer(playerid);
			    SetPlayerVirtualWorld(playerid,0);
			    TextDrawHideForPlayer(playerid,Textdraw98[playerid]);
			    SetCameraBehindPlayer(playerid);
			    TogglePlayerControllable(playerid, 1);
			    SendClientMessage(playerid,COLOR_WHITE,"{248B10}Tutorial:{FFFFFF}Now we will need some data from you!.");
			    return 1;
			}
		}
	}


	if(PRESSED(KEY_JUMP))
    {
        if(gPlayerTutorialing[playerid] >= 1)
        {
            if(gPlayerTutorialing[playerid] == 9)
            {
			    gPlayerTutorialing[playerid] = 8;
			    SetPlayerPos(playerid,1187.1349,-1323.7538,13.5591);
			    SetPlayerCameraPos(playerid,1206.7904,-1365.1343,27.3433);//Al Saints Hospital
			    SetPlayerCameraLookAt(playerid,1187.1349,-1323.7538,13.5591);
			    format(string,sizeof(string),"If you die,you will be asked to /accept death ~n~.When your really dead ,you will be ~n~spawned here,at Al Saints Hospital.");
			    TextDrawSetString(Textdraw98[playerid],string);
			    TextDrawShowForPlayer(playerid,Textdraw98[playerid]);
			    SendClientMessage(playerid,COLOR_WHITE,"{248B10}Tutorial:{FFFFFF}Use SPACEBAR to continue,SHIFT to go back.");
			    return 1;
			}
            if(gPlayerTutorialing[playerid] == 8)
            {
			    gPlayerTutorialing[playerid] = 7;
			    SetPlayerPos(playerid,617.2159,-1330.5415,13.6447);
			    SetPlayerCameraPos(playerid,652.8370,-1335.8909,28.2059);//Sector 1 Jail
			    SetPlayerCameraLookAt(playerid,617.2159,-1330.5415,13.6447);
			    format(string,sizeof(string),"If the police officers catch you ~n~they will jail you in one~n~of the jails around the city.");
			    TextDrawSetString(Textdraw98[playerid],string);
			    TextDrawShowForPlayer(playerid,Textdraw98[playerid]);
			    SendClientMessage(playerid,COLOR_WHITE,"{248B10}Tutorial:{FFFFFF}Use SPACEBAR to continue,SHIFT to go back.");
			    return 1;
			}
            if(gPlayerTutorialing[playerid] == 7)
            {
			    gPlayerTutorialing[playerid] = 6;
			    SetPlayerPos(playerid,543.6426,-1277.8851,17.2422);
			    SetPlayerCameraPos(playerid,538.1927,-1259.2106,29.4667);//Grotti Dealership
			    SetPlayerCameraLookAt(playerid,543.6426,-1277.8851,17.2422);
			    format(string,sizeof(string),"If you have enough money,you will ~n~be able to buy a new car.~n~Command:/v.");
			    TextDrawSetString(Textdraw98[playerid],string);
			    TextDrawShowForPlayer(playerid,Textdraw98[playerid]);
			    SendClientMessage(playerid,COLOR_WHITE,"{248B10}Tutorial:{FFFFFF}Use SPACEBAR to continue,SHIFT to go back.");
			    return 1;
			}
            if(gPlayerTutorialing[playerid] == 6)
            {
			    gPlayerTutorialing[playerid] = 5;
			    SetPlayerPos(playerid,590.7849,-1243.1808,17.9521);
			    SetPlayerCameraPos(playerid,609.0580,-1219.5914,29.2979);//Bank
			    SetPlayerCameraLookAt(playerid,590.7849,-1243.1808,17.9521);
			    format(string,sizeof(string),"Your paydays,your money will be deposited ~n~here,at the Bank.~n~You have the possibility to:.~n~/bank deposit,withdraw,transfer,savings,etc.~n~Remember:Minimum savings value:50.000$.");
			    TextDrawSetString(Textdraw98[playerid],string);
			    TextDrawShowForPlayer(playerid,Textdraw98[playerid]);
			    SendClientMessage(playerid,COLOR_WHITE,"{248B10}Tutorial:{FFFFFF}Use SPACEBAR to continue,SHIFT to go back.");
			    return 1;
			}
            if(gPlayerTutorialing[playerid] == 5)
            {
			    gPlayerTutorialing[playerid] = 4;
			    SetPlayerPos(playerid,1482.2841,-1025.5725,24.352);
			    SetPlayerCameraPos(playerid,1522.6703,-1041.8273,60.2691);//Casino
			    SetPlayerCameraLookAt(playerid,1482.2841,-1025.5725,24.3520);
			    format(string,sizeof(string),"If you got tired of working ~n~for someone or for your job~n~you have the possibility to play.~n~here,at the Casino!~n~Commands:/casino");
			    TextDrawSetString(Textdraw98[playerid],string);
			    TextDrawShowForPlayer(playerid,Textdraw98[playerid]);
			    SendClientMessage(playerid,COLOR_WHITE,"{248B10}Tutorial:{FFFFFF}Use SPACEBAR to continue,SHIFT to go back.");
			    return 1;
			}
            if(gPlayerTutorialing[playerid] == 4)
            {
			    gPlayerTutorialing[playerid] = 3;
			    SetPlayerPos(playerid,1380.7892,-1088.5284,27.3844);
			    SetPlayerCameraPos(playerid,1349.7155,-1115.9375,47.7593);//Jobs Building
			    SetPlayerCameraLookAt(playerid,1380.7892,-1088.5284,27.3844);
			    format(string,sizeof(string),"If you want to earn money,you will be able to ~n~get a job.There will be a list so you~n~will have to choose one job.~n~REMEBER:Some of these jobs requests~n~a owned vehicle!");
			    TextDrawSetString(Textdraw98[playerid],string);
			    TextDrawShowForPlayer(playerid,Textdraw98[playerid]);
			    SendClientMessage(playerid,COLOR_WHITE,"{248B10}Tutorial:{FFFFFF}Use SPACEBAR to continue,SHIFT to go back.");
			    return 1;
			}
            if(gPlayerTutorialing[playerid] == 3)
            {
			    gPlayerTutorialing[playerid] = 2;
			    SetPlayerPos(playerid,1412.8313, -1700.3066, 13.5395);
			    SetPlayerCameraPos(playerid,1412.8313, -1700.3066, 13.5395);//Driving School
			    SetPlayerCameraLookAt(playerid,1412.8313, -1700.3066, 13.5395);
			    format(string,sizeof(string),"This is the Driving School,you will be able ~n~to take a drive test wich will cost you~n~5.000$ so you will get a Driving License.~n~REMEBER:The police stops you if you~n~don't have one.");
			    TextDrawSetString(Textdraw98[playerid],string);
			    TextDrawShowForPlayer(playerid,Textdraw98[playerid]);
			    SendClientMessage(playerid,COLOR_WHITE,"{248B10}Tutorial:{FFFFFF}Use SPACEBAR to continue,SHIFT to go back.");
			    return 1;
			}
            if(gPlayerTutorialing[playerid] == 2)
            {
			    gPlayerTutorialing[playerid] = 1;
			    SetPlayerPos(playerid,1479.8079,-1674.9541,14.6260);
			    SetPlayerCameraPos(playerid,1396.1614,-1650.0144,59.4351);//Pershing Square
			    SetPlayerCameraLookAt(playerid,1479.8079,-1674.9541,14.6260);
			    format(string,sizeof(string),"This place is the most ~n~ safest place in Los Santos.~n~You have no right to kill/rob/rape noone here");
			    TextDrawSetString(Textdraw98[playerid],string);
			    TextDrawShowForPlayer(playerid,Textdraw98[playerid]);
			    SendClientMessage(playerid,COLOR_WHITE,"{248B10}Tutorial:{FFFFFF}Use SPACEBAR to continue,SHIFT to go back.");
			    return 1;
			}
		}
	}
//==================================ENGINE======================================
    new vehicleid = GetPlayerVehicleID(playerid);
    if(IsPlayerInAnyVehicle(playerid))
    {
    	if(vehEngine[vehicleid] == 0)
	    {
	    	if(newkeys == KEY_JUMP)
    		{
			    new vid, sendername[MAX_PLAYER_NAME], vmodel[128];
			   	vehEngine[vehicleid] = 2;
			   	SetTimerEx("StartEngine", 3000, 0, "i", playerid);
			   	SendClientMessage(playerid, COLOR_GREEN, "Vehicle engine starting");
			   	vid = GetPlayerVehicleID(playerid);
			   	GetVehicleName(vid,vmodel,sizeof(vmodel));
			   	GetPlayerName(playerid,sendername,sizeof(sendername));
			   	format(string, sizeof(string), "* %s is starting the engine of the %s", sendername, vmodel);
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			}
			if(newkeys == KEY_SECONDARY_ATTACK)
			{
				RemovePlayerFromVehicle(playerid);
				TogglePlayerControllable(playerid, 1);
			}
		}
	}
	return 1;
}
//========================================DEALERSHIP============================
public OnVehicleMod(playerid, vehicleid, componentid)
{
	new id = GetVehicleID(vehicleid);
	if(IsValidVehicle(id))
	{
		VehicleMods[id][GetVehicleComponentType(componentid)] = componentid;
		SaveVehicle(id);
	}
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	new id = GetVehicleID(vehicleid);
	if(IsValidVehicle(id))
	{
		VehiclePaintjob[id] = paintjobid;
		SaveVehicle(id);
	}
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	new id = GetVehicleID(vehicleid);
	if(IsValidVehicle(id))
	{
		VehicleColor[id][0] = color1;
		VehicleColor[id][1] = color2;
		SaveVehicle(id);
	}
	return 1;
}

ShowDialog(playerid, dialogid)
{
	switch(dialogid)
	{
		case DIALOG_VEHICLE:
		{
			new vehicleid = GetPVarInt(playerid, "DialogValue1");
			new caption[32], info[256];
			format(caption, sizeof(caption), "Vehicle ID %d", vehicleid);
			strcat(info, "\nTrunk", sizeof(info));
			strcat(info, "\nFill Tank", sizeof(info));
			switch(GetPlayerVehicleAccess(playerid, vehicleid))
			{
				case 1:
				{
					new value = VehicleValue[vehicleid]/2;
					format(info, sizeof(info), "%s\nSell Vehicle  ($%d)\nPark Vehicle\nEdit License Plate", info, value);
				}
			}
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, caption, info, "Select", "Cancel");
		}
		case DIALOG_VEHICLE_BUY:
		{
			new vehicleid = GetPVarInt(playerid, "DialogValue1");
			new caption[32], info[256];
			format(caption, sizeof(caption), "Vehicle ID %d", vehicleid);
			format(info, sizeof(info), "This vehicle is for sale ($%d)\nWould you like to buy it?", VehicleValue[vehicleid]);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, caption, info, "Yes", "No");
		}
		case DIALOG_VEHICLE_SELL:
		{
			new targetid = GetPVarInt(playerid, "DialogValue1");
			new id = GetPVarInt(playerid, "DialogValue2");
			new price = GetPVarInt(playerid, "DialogValue3");
			new info[256];
			format(info, sizeof(info), "%s (%d) wants to sell you a %s for $%d.", PlayerName(targetid), targetid,
				VehicleNames[VehicleModel[id]-400], price);
			strcat(info, "\n\nWould you like to buy?", sizeof(info));
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, "Buy Vehicle", info, "Yes", "No");
		}
		case DIALOG_TRUNK:
		{
			new vehicleid = GetPVarInt(playerid, "DialogValue1");
			new name[32], info[256];
			for(new i=0; i < sizeof(VehicleTrunk[]); i++)
			{
				if(VehicleTrunk[vehicleid][i][1] > 0)
				{
					GetWeaponName(VehicleTrunk[vehicleid][i][0], name, sizeof(name));
					format(info, sizeof(info), "%s%d. %s (%d)\n", info, i+1, name, VehicleTrunk[vehicleid][i][1]);
				}
				else
				{
					format(info, sizeof(info), "%s%d. Empty\n", info, i+1);
				}
			}
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, "Trunk", info, "Select", "Cancel");
		}
		case DIALOG_TRUNK_ACTION:
		{
			new info[128];
			strcat(info, "Put Into Trunk\nTake From Trunk", sizeof(info));
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, "Trunk", info, "Select", "Cancel");
		}
		case DIALOG_VEHICLE_PLATE:
		{
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, "Edit License Plate", "Enter new license plate:", "Change", "Back");
		}
		case DIALOG_FUEL:
		{
			new info[128];
			strcat(info, "Refuel Vehicle  ($" #FUEL_PRICE ")\nBuy Gas Can  ($" #GAS_CAN_PRICE ")", sizeof(info));
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, "Fuel Station", info, "OK", "Cancel");
		}
		case DIALOG_EDITVEHICLE:
		{
			new vehicleid = GetPVarInt(playerid, "DialogValue1");
			new caption[32], info[256];
			format(caption, sizeof(caption), "Edit Vehicle ID %d", vehicleid);
			format(info, sizeof(info), "1. Value: [$%d]\n2. Model: [%d (%s)]\n3. Colors: [%d]  [%d]\n4. License Plate: [%s]",
				VehicleValue[vehicleid], VehicleModel[vehicleid], VehicleNames[VehicleModel[vehicleid]-400],
				VehicleColor[vehicleid][0], VehicleColor[vehicleid][1], VehicleNumberPlate[vehicleid]);
			strcat(info, "\n5. Delete Vehicle\n6. Park Vehicle\n7. Go To Vehicle", sizeof(info));
			strcat(info, "\n\nEnter: [nr] [value1] [value2]", sizeof(info));
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, caption, info, "OK", "Cancel");
		}
	}
}
public OnVehicleSpawn(vehicleid)
{
	VehicleSecurity[vehicleid] = 0;
	new id = GetVehicleID(vehicleid);
	if(IsValidVehicle(id))
	{
		if(VehicleColor[id][0] >= 0 && VehicleColor[id][1] >= 0)
		ChangeVehicleColor(vehicleid, VehicleColor[id][0], VehicleColor[id][1]);
		LinkVehicleToInterior(vehicleid, VehicleInterior[id]);
		SetVehicleVirtualWorld(vehicleid, VehicleWorld[id]);
		for(new i=0; i < sizeof(VehicleMods[]); i++)
		{
			AddVehicleComponent(vehicleid, VehicleMods[id][i]);
		}
		ChangeVehiclePaintjob(vehicleid, VehiclePaintjob[id]);
	}
	return 1;
}
public MainTimer()
{
	new string[128];
	new Float:x, Float:y, Float:z;

	for(new i=0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPlayerState(i) == PLAYER_STATE_DRIVER)
			{
				new vehicleid = GetPlayerVehicleID(i);
				if(!IsBicycle(vehicleid) && Fuel[vehicleid] > 0)
				{
					if(Fuel[vehicleid] <= 0)
					{
						ToggleEngine(vehicleid, VEHICLE_PARAMS_OFF);
						GameTextForPlayer(i, "~r~out of fuel", 3000, 3);
						SendClientMessage(i, COLOR_RED, "This vehicle is out of fuel!");
					}
				}
			}
			if(RefuelTime[i] > 0 && GetPVarInt(i, "FuelStation"))
			{
				new vehicleid = GetPlayerVehicleID(i);
				Fuel[vehicleid] += 2.0;
				RefuelTime[i]--;
				if(RefuelTime[i] == 0)
				{
					if(Fuel[vehicleid] >= 100.0) Fuel[vehicleid] = 100.0;
					new stationid = GetPVarInt(i, "FuelStation");
					new cost = floatround(Fuel[vehicleid]-GetPVarFloat(i, "Fuel"))*FUEL_PRICE;
					if(GetPlayerState(i) != PLAYER_STATE_DRIVER || Fuel[vehicleid] >= 100.0 || GetPlayerMoney(i) < cost
					|| !IsPlayerInRangeOfPoint(i, 10.0, FuelStationPos[stationid][0], FuelStationPos[stationid][1], FuelStationPos[stationid][2]))
					{
						if(GetPlayerMoney(i) < cost) cost = GetPlayerMoney(i);
						GivePlayerCash(i, -cost);
						format(string, sizeof(string), "~r~-$%d", cost);
						GameTextForPlayer(i, string, 2000, 3);
						format(string, sizeof(string), "You pay $%d for fuel", cost);
						SendClientMessage(i, COLOR_WHITE, string);
						SetPVarInt(i, "FuelStation", 0);
						SetPVarFloat(i, "Fuel", 0.0);
					}
					else
					{
						RefuelTime[i] = 5;
						format(string, sizeof(string), "~w~refueling...~n~~r~-$%d", cost);
						GameTextForPlayer(i, string, 2000, 3);
					}
				}
			}
			if(TrackCar[i])
			{
				GetVehiclePos(TrackCar[i], x, y, z);
				SetPlayerCheckpoint(i, x, y, z, 3);
			}
		}
	}
}
public SaveTimer()
{
	SaveVehicleIndex++;
	if(SaveVehicleIndex >= MAX_DVEHICLES) SaveVehicleIndex = 1;
	if(IsValidVehicle(SaveVehicleIndex)) SaveVehicle(SaveVehicleIndex);
}

public StopAlarm(vehicleid)
{
	ToggleAlarm(vehicleid, VEHICLE_PARAMS_OFF);
}
//====================================ENGINE====================================
public StartEngine(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    new Float:health;
    new rand = random(2);
    GetVehicleHealth(vehicleid, health);
    if(IsPlayerInAnyVehicle(playerid))
    {
    	if(vehEngine[vehicleid] == 2)
    	{
    		if(health > 300)
    		{
    			if(rand == 0)
    			{
				    vehEngine[vehicleid] = 1;
				    TogglePlayerControllable(playerid, 1);
				    SetTimerEx("DamagedEngine", 1000, 1, "i", playerid);
				    SendClientMessage(playerid, COLOR_GREEN, "Vehicle engine started");
    			}
    			if(rand == 1)
    			{
				    vehEngine[vehicleid] = 0;
				    TogglePlayerControllable(playerid, 0);
				    SendClientMessage(playerid, COLOR_RED, "Vehicle engine failed to start");
    			}
   			}
    		else
    		{
    			vehEngine[vehicleid] = 0;
    			TogglePlayerControllable(playerid, 0);
    			SendClientMessage(playerid, COLOR_RED, "Vehicle engine failed to start due to damage");
    		}
    	}
    }
    return 1;
}

public DamagedEngine(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    new Float:health;
   	GetVehicleHealth(vehicleid, health);
   	if(IsPlayerInAnyVehicle(playerid))
   	{
   		if(vehEngine[vehicleid] == 1)
   		{
   			if(health < 300)
   			{
   				vehEngine[vehicleid] = 0;
   				TogglePlayerControllable(playerid, 0);
   				SendClientMessage(playerid, COLOR_RED, "Vehicle engine stopped due to damage");
   			}
   		}
   	}
   	return 1;
}
public OnPlayerExitVehicle(playerid, vehicleid)
{
	TogglePlayerControllable(playerid, 1);
 	return 1;
}
//==============================================================================
public FixHour(hour)
{
	hour = timeshift+hour;
	if (hour < 0)
	{
		hour = hour+24;
	}
	else if (hour > 23)
	{
		hour = hour-24;
	}
	shifthour = hour;
	return 1;
}
public SetOriginalColor(playerid)
{
	if(IsPlayerConnected(playerid))
	{
 		SetPlayerColor(playerid, COLOR_WHITE);
	}
}
public PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z)
{
    if(IsPlayerConnected(playerid))
	{
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		tempposx = (oldposx -x);
		tempposy = (oldposy -y);
		tempposz = (oldposz -z);
		//printf("DEBUG: X:%f Y:%f Z:%f",posx,posy,posz);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
			return 1;
		}
	}
	return 0;
}
public ShowStats(playerid,targetid)
{
    if(IsPlayerConnected(playerid)&&IsPlayerConnected(targetid))
	{
		new cash =  GetPlayerMoney(targetid);
		new atext[20];
		if(PlayerInfo[targetid][pSex] == 1)
		{ atext = "Male"; }
		else if(PlayerInfo[targetid][pSex] == 2)
		{ atext = "Female"; }
  		new otext[20];
		if(PlayerInfo[targetid][pPlace] == 1)
		{ otext = "Europe"; }
		else if(PlayerInfo[targetid][pPlace] == 2)
		{ otext = "America"; }
		new drank[20];
		if(PlayerInfo[targetid][pVip] == 1)
		{ drank = "Gold Donator"; }
		else if(PlayerInfo[targetid][pVip] == 2)
		{ drank = "Silver Donator"; }
		else { drank = "None"; }
		new age = PlayerInfo[targetid][pAge];
		new warns = PlayerInfo[targetid][pWarns];
		new level = PlayerInfo[targetid][pLevel];
		new exp = PlayerInfo[targetid][pExp];
		new nxtlevel = PlayerInfo[targetid][pLevel]+1;
		new expamount = nxtlevel*levelexp;
		new costlevel = nxtlevel*levelcost;
		new name[MAX_PLAYER_NAME];
		new pnumber = PlayerInfo[targetid][pNumber];
		GetPlayerName(targetid, name, sizeof(name));
		new Float:px,Float:py,Float:pz;
		GetPlayerPos(targetid, px, py, pz);
		new coordsstring[128];
		SendClientMessage(playerid, COLOR_GREEN,"_____________________________________________________________________________________________");
		format(coordsstring, sizeof(coordsstring),"*** %s ***",name);
		SendClientMessage(playerid, COLOR_YELLOW,coordsstring);
		format(coordsstring, sizeof(coordsstring), "Level:[%d] Sex:[%s] Age:[%d] Origin:[%s] Cash:[$%d] Phone:[%d] ", level,atext,age,otext, cash, pnumber);
		SendClientMessage(playerid, COLOR_WHITE,coordsstring);
		format(coordsstring, sizeof(coordsstring), "DonateRank:[%s] Warns:[%d/5]", drank, warns);
		SendClientMessage(playerid, COLOR_LIGHTBLUE,coordsstring);
		format(coordsstring, sizeof(coordsstring), "NextLevel:[$%d] Respect:[%d/%d]",costlevel,exp,expamount);
		SendClientMessage(playerid, COLOR_LIGHTBLUE,coordsstring);
		SendClientMessage(playerid, COLOR_GREEN,"____________________________________________________________________________________________");
	}
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == 1234)
	{
		if(!response)  return Kick(playerid);
		if(response)
		{
			if(fexist(UserPath(playerid)))
			{
				INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
				ShowPlayerDialog(playerid, 2, DIALOG_STYLE_INPUT,""COL_WHITE"Login",""COL_WHITE"Type your password below to login.","Login","Quit");
			}
			else
			{
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_INPUT,""COL_WHITE"Registering...",""COL_WHITE"Type your password below to register a new account.","Register","Quit");
			}
		}
	}
	if(dialogid == 1)
	{
		if (!response) return Kick(playerid);
		if(response)
		{
			if(!strlen(inputtext)) return ShowPlayerDialog(playerid, 1, DIALOG_STYLE_INPUT, ""COL_WHITE"Registering...",""COL_RED"You have entered an invalid password.\n"COL_WHITE"Type your password below to register a new account.","Register","Quit");
			new INI:File = INI_Open(UserPath(playerid));
			INI_SetTag(File,"data");
			INI_WriteInt(File,"Password",udb_hash(inputtext));
			INI_WriteInt(File, "Level",PlayerInfo[playerid][pLevel] = 1);
			INI_WriteInt(File, "Money",PlayerInfo[playerid][pCash] = 0);
			INI_WriteInt(File, "Admin",PlayerInfo[playerid][pAdmin] = 0);
			INI_WriteInt(File, "Tester",PlayerInfo[playerid][pTester] = 0);
			INI_WriteInt(File, "Vip", PlayerInfo[playerid][pVip] = 0);
			INI_WriteInt(File, "Spawn", PlayerInfo[playerid][pSpawn] = 1);
			INI_WriteInt(File, "Model", PlayerInfo[playerid][pModel] = 23);
			INI_WriteInt(File, "Locked", PlayerInfo[playerid][pLocked] = 0);
			INI_WriteInt(File, "FirstJoined", PlayerInfo[playerid][pFirstJoined] = 0);
			INI_WriteInt(File, "Continent", PlayerInfo[playerid][pPlace] = 0);
			INI_WriteInt(File, "Sex", PlayerInfo[playerid][pSex] = 0);
			INI_WriteInt(File, "Selected", PlayerInfo[playerid][pSelected] = 1);
			INI_WriteInt(File, "Age", PlayerInfo[playerid][pAge] = 0);
			INI_WriteInt(File, "Origin", PlayerInfo[playerid][pOrigin] = 0);
			INI_WriteInt(File, "Respect", PlayerInfo[playerid][pExp] = 0);
			INI_WriteInt(File, "Warns", PlayerInfo[playerid][pWarns] = 0);
			INI_WriteInt(File, "Muted", PlayerInfo[playerid][pMuted] = 0);
			INI_WriteInt(File, "MuteTime", PlayerInfo[playerid][pMuteTime] = 0);
   			new rp = 100000 + random(899999);
			INI_WriteInt(File, "Ph", PlayerInfo[playerid][pNumber] = rp);
			INI_WriteInt(File, "DriveLic",PlayerInfo[playerid][pDriveLic] = 0);
			INI_Close(File);
			SpawnPlayer(playerid);
			SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
		}
	}
	if(dialogid == 2)
	{
		if(!response ) return Kick (playerid);
		if(response)
		{
			if(udb_hash(inputtext) == PlayerInfo[playerid][pPass])
			{
				INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
				SpawnPlayer(playerid);
				gPlayerLogged[playerid] = 1;
				GivePlayerCash(playerid, PlayerInfo[playerid][pCash]);
			}
			else
			{
				ShowPlayerDialog(playerid, 2, DIALOG_STYLE_INPUT,""COL_WHITE"Login",""COL_RED"You have entered an incorrect password.\n"COL_WHITE"Type your password below to login.","Login","Quit");
				gPlayerLogTries[playerid] += 1;
				if(gPlayerLogTries[playerid] == 3)
				{
					Kick(playerid);
				}		
			}
		}
	}
	if(dialogid == 155)
		{
		    if(response)
		    {
   				if (listitem == 0)
				{
					PlayerInfo[playerid][pSex] = 1;
					SendClientMessage(playerid, COLOR_YELLOW2,"So you are Male");
					ShowPlayerDialog(playerid,156,DIALOG_STYLE_INPUT,"Age","How old are you?:((This information is IC.))","Next","Leave Game");
   				}
				else if (listitem == 1)
				{
					PlayerInfo[playerid][pSex] = 2;
					SendClientMessage(playerid, COLOR_YELLOW2,"So you are Female");
					ShowPlayerDialog(playerid,156,DIALOG_STYLE_INPUT,"Age","How old are you?:((This information is IC.))","Next","Leave Game");
                }
			}
			else
			{
			    Kick(playerid);
			}
		}
	if(dialogid == 156)
	{
	    if(response)
	    {
	        PlayerInfo[playerid][pAge] = strval(inputtext);
        	new string[64];
			format(string, sizeof(string),"So you are %s years old", inputtext);
			SendClientMessage(playerid, COLOR_YELLOW2, string);
			new sexthings[] = " Europe \n America \n Russia";
			if(strval(inputtext) <= 15)
			{
				SendClientMessage(playerid, COLOR_WHITE, "SERVER: This is a 16+ Only Server, Grow up and Come Back.");
				Kick(playerid);
				return 1;


			}
			if(strval(inputtext) >= 60)
			{
				SendClientMessage(playerid, COLOR_WHITE, "SERVER: Incorrect Age, You need to enter a Real Age.");
				ShowPlayerDialog(playerid,156,DIALOG_STYLE_INPUT,"Age","How old are you?:((This information is IC.))","Next","Leave Game");
				return 1;


			}
			ShowPlayerDialog(playerid,157,DIALOG_STYLE_LIST,"Where are you from?:((This information is IC.))",sexthings,"Select","Leave Game");
		}
		else
		{
		    Kick(playerid);
		}
	}
	if(dialogid == 157)
	{
	    if(response)
	    {
   			if (listitem == 0)
			{
			    PlayerInfo[playerid][pPlace] = 1;
			    SendClientMessage(playerid, COLOR_YELLOW2, "So you are from the Europe.");
				gPlayerRegStep[playerid] = 0;
				PlayerInfo[playerid][pSelected] = 1;
   			}
			else if (listitem == 1)
			{
			   	PlayerInfo[playerid][pPlace] = 2;
			    SendClientMessage(playerid, COLOR_YELLOW2, "So you are from United States.");
				gPlayerRegStep[playerid] = 0;
				PlayerInfo[playerid][pSelected] = 1;
			}
			else if (listitem == 2)
			{
			    PlayerInfo[playerid][pPlace] = 3;
			    SendClientMessage(playerid, COLOR_YELLOW2, "So you are from Russia.");
				gPlayerRegStep[playerid] = 0;
				PlayerInfo[playerid][pSelected] = 1;
			}
			gPlayerLogged[playerid] = 1;
			new packthings[] = " Package 1 \n Package 2";
			ShowPlayerDialog(playerid,158,DIALOG_STYLE_LIST,"Please select a package that you want to start with",packthings,"Select","Leave Game");
		}
		else
		{
		    Kick(playerid);
		}
	}
	if(dialogid == 158)
	{
	    if(response)
	    {
   			if (listitem == 0)
			{
			    new DialogString[1024];
    			format(DialogString, sizeof DialogString, "Level 2 \n 4 Respect Points \n 1000$");
			    ShowPlayerDialog(playerid,159,DIALOG_STYLE_MSGBOX,"Package 1", DialogString,"Accept","Back");
			}
			else if (listitem == 1)
			{
			    new DialogString[1024];
    			format(DialogString, sizeof DialogString, "Level 1 \n 4000$");
			    ShowPlayerDialog(playerid,160,DIALOG_STYLE_MSGBOX,"Package 1", DialogString,"Accept","Back");
			}
		}
		else
		{
		    Kick(playerid);
		}
	}
	if(dialogid == 159)
	{
	    if(response)
	    {
            new playerexp = PlayerInfo[playerid][pExp];
            PlayerInfo[playerid][pExp] = playerexp + 4;
            new playerlvl = PlayerInfo[playerid][pLevel];
            PlayerInfo[playerid][pLevel] = playerlvl + 1;
            GivePlayerCash(playerid, 1000);
            TogglePlayerControllable(playerid, 1);
            SendClientMessage(playerid, COLOR_YELLOW2,"That's all, if you need help you can /helpme, have fun!");
            SendClientMessage(playerid, COLOR_LIGHTBLUE,"A taxi has bringed you to the DMV so you can take your Drivers License");
            SetPlayerPos(playerid, 1424.1869,-1696.1482,13.5469);
		}
		else
		{
		    new packthings[] = "Package 1 \n Package 2";
			ShowPlayerDialog(playerid,158,DIALOG_STYLE_LIST,"Please select a package that you want to start with",packthings,"Select","Leave Game");
		}
	}
	if(dialogid == 160)
	{
	    if(response)
	    {
            GivePlayerCash(playerid, 4000);
            TogglePlayerControllable(playerid, 1);
            SendClientMessage(playerid, COLOR_YELLOW2,"That's all, if you need help you can /helpme, have fun!");
            SendClientMessage(playerid, COLOR_LIGHTBLUE,"A taxi has bringed you to the DMV so you can take your Drivers License");
            SetPlayerPos(playerid, 1424.1869,-1696.1482,13.5469);
		}
		else
		{
     		new packthings[] = "Package 1 \n Package 2";
			ShowPlayerDialog(playerid,158,DIALOG_STYLE_LIST,"Please select a package that you want to start with",packthings,"Select","Leave Game");
		}
	}
//==========================DEALERSHIP==========================================
    if(dialogid == DIALOG_ERROR)
	{
		ShowDialog(playerid, GetPVarInt(playerid, "DialogReturn"));
		return 1;
	}
	SetPVarInt(playerid, "DialogReturn", dialogid);
	if(dialogid == DIALOG_VEHICLE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new vehicleid = GetPlayerVehicleID(playerid);
					new engine, lights, alarm, doors, bonnet, boot, objective;
					GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
					if(boot == 1) boot = 0; else boot = 1;
					SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
				}
				case 1:
				{
					new vehicleid = GetPlayerVehicleID(playerid);
					new engine, lights, alarm, doors, bonnet, boot, objective;
					GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
					if(engine == 0 && Fuel[vehicleid] <= 0)
					{
						ShowErrorDialog(playerid, "This vehicle is out of fuel!");
						return 1;
					}
					if(engine == 1) { engine = 0; lights = 0; }
					else { engine = 1; lights = 1; }
					SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
				}
				case 2:
				{
					new id = GetPVarInt(playerid, "DialogValue1");
					if(GetPlayerVehicleAccess(playerid, id) != 1)
					{
						ShowErrorDialog(playerid, "You are not the owner of this vehicle!");
						return 1;
					}
					new msg[128];
					VehicleCreated[id] = 0;
					new money = VehicleValue[id]/2;
					GivePlayerCash(playerid, money);
					format(msg, sizeof(msg), "You have sold your vehicle for $%d", money);
					SendClientMessage(playerid, COLOR_WHITE, msg);
					RemovePlayerFromVehicle(playerid);
					DestroyVehicle(VehicleID[id]);
					SaveVehicle(id);
				}
				case 3:
				{
					new vehicleid = GetPVarInt(playerid, "DialogValue1");
					if(GetPlayerVehicleAccess(playerid, vehicleid) != 1 && GetPlayerVehicleAccess(playerid, vehicleid) != 3)
					{
						ShowErrorDialog(playerid, "You are not the owner of this vehicle!");
						return 1;
					}
					GetVehiclePos(VehicleID[vehicleid], VehiclePos[vehicleid][0], VehiclePos[vehicleid][1], VehiclePos[vehicleid][2]);
					GetVehicleZAngle(VehicleID[vehicleid], VehiclePos[vehicleid][3]);
					SendClientMessage(playerid, COLOR_WHITE, "You have parked this vehicle here");
					UpdateVehicle(vehicleid, 1);
					PutPlayerInVehicle(playerid, VehicleID[vehicleid], 0);
					SaveVehicle(vehicleid);
				}
				case 4:
				{
					ShowDialog(playerid, DIALOG_VEHICLE_PLATE);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_VEHICLE_BUY)
	{
		if(response)
		{
			if(GetPlayerVehicles(playerid) >= MAX_PLAYER_VEHICLES)
			{
				ShowErrorDialog(playerid, "You can't buy any more vehicles! Max: " #MAX_PLAYER_VEHICLES );
				return 1;
			}
			new id = GetPVarInt(playerid, "DialogValue1");
			if(GetPlayerMoney(playerid) < VehicleValue[id])
			{
				ShowErrorDialog(playerid, "You don't have enough money to buy this vehicle!");
				return 1;
			}
			new freeid;
			for(new i=1; i < MAX_DVEHICLES; i++)
			{
				if(!VehicleCreated[i])
				{
					freeid = i; break;
				}
			}
			if(!freeid)
			{
				ShowErrorDialog(playerid, "Vehicle dealership is out of stock!");
				return 1;
			}
			GivePlayerCash(playerid, -VehicleValue[id]);
			new dealerid = strval(VehicleOwner[id]);
			VehicleCreated[freeid] = VEHICLE_PLAYER;
			VehicleModel[freeid] = VehicleModel[id];
			VehiclePos[freeid][0] = DealershipPos[dealerid][0];
			VehiclePos[freeid][1] = DealershipPos[dealerid][1];
			VehiclePos[freeid][2] = DealershipPos[dealerid][2];
			VehicleColor[freeid][0] = VehicleColor[id][0];
			VehicleColor[freeid][1] = VehicleColor[id][0];
			VehicleInterior[freeid] = VehicleInterior[id];
			VehicleWorld[freeid] = VehicleWorld[id];
			VehicleValue[freeid] = VehicleValue[id];
			strcpy(VehicleOwner[freeid], sizeof(VehicleOwner[]), PlayerName(playerid));
			VehicleNumberPlate[freeid] = DEFAULT_NUMBER_PLATE;
			for(new d=0; d < sizeof(VehicleTrunk[]); d++)
			{
				VehicleTrunk[freeid][d][0] = 0;
				VehicleTrunk[freeid][d][1] = 0;
			}
			for(new d=0; d < sizeof(VehicleMods[]); d++)
			{
				VehicleMods[freeid][d] = 0;
			}
			VehiclePaintjob[freeid] = 255;
			UpdateVehicle(freeid, 0);
			SaveVehicle(freeid);
			new msg[128];
			format(msg, sizeof(msg), "You have bought this vehicle for $%d", VehicleValue[id]);
			SendClientMessage(playerid, COLOR_WHITE, msg);
			RemovePlayerFromVehicle(playerid);
			SetTimer("Unfreeze", 1000, 0);
		}
		else
		{
			new vehicleid = GetPVarInt(playerid, "DialogValue1");
			if(GetPlayerVehicleAccess(playerid, vehicleid) != 3)
			{
				RemovePlayerFromVehicle(playerid);
			}
			RemovePlayerFromVehicle(playerid);
		}
		return 1;
	}
	if(dialogid == DIALOG_VEHICLE_SELL)
	{
		if(response)
		{
			if(GetPlayerVehicles(playerid) >= MAX_PLAYER_VEHICLES)
			{
				ShowErrorDialog(playerid, "You can't buy any more vehicles! Max: " #MAX_PLAYER_VEHICLES );
				return 1;
			}
			new targetid = GetPVarInt(playerid, "DialogValue1");
			new vehicleid = GetPVarInt(playerid, "DialogValue2");
			new price = GetPVarInt(playerid, "DialogValue3");
			if(GetPlayerMoney(playerid) < price)
			{
				ShowErrorDialog(playerid, "You don't have enough money to buy this vehicle!");
				return 1;
			}
			new msg[128];
			strcpy(VehicleOwner[vehicleid], sizeof(VehicleOwner[]), PlayerName(playerid));
			GivePlayerCash(playerid, -price);
			GivePlayerCash(targetid, price);
			SaveVehicle(vehicleid);
			format(msg, sizeof(msg), "You have bought this vehicle for $%d", price);
			SendClientMessage(playerid, COLOR_WHITE, msg);
			format(msg, sizeof(msg), "%s (%d) has accepted your offer and bought the vehicle", PlayerName(playerid), playerid);
			SendClientMessage(targetid, COLOR_WHITE, msg);
		}
		else
		{
			new targetid = GetPVarInt(playerid, "DialogValue1");
			new msg[128];
			format(msg, sizeof(msg), "%s (%d) refused your offer", PlayerName(playerid), playerid);
			SendClientMessage(targetid, COLOR_WHITE, msg);
		}
		return 1;
	}
	if(dialogid == DIALOG_FINDVEHICLE)
	{
		if(response)
		{
			new id;
			sscanf(inputtext[4], "d", id);
			if(IsValidVehicle(id))
			{
				TrackCar[playerid] = VehicleID[id];
				SendClientMessage(playerid, COLOR_WHITE, "You vehicle's location is shown on your radar");
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_TRUNK)
	{
		if(response)
		{
			SetPVarInt(playerid, "DialogValue2", listitem);
			ShowDialog(playerid, DIALOG_TRUNK_ACTION);
		}
		else
		{
			new vehicleid = GetPVarInt(playerid, "DialogValue1");
			new engine, lights, alarm, doors, bonnet, boot, objective;
			GetVehicleParamsEx(VehicleID[vehicleid], engine, lights, alarm, doors, bonnet, boot, objective);
			SetVehicleParamsEx(VehicleID[vehicleid], engine, lights, alarm, doors, bonnet, 0, objective);
		}
		return 1;
	}
	if(dialogid == DIALOG_TRUNK_ACTION)
	{
		if(response)
		{
			new vehicleid = GetPVarInt(playerid, "DialogValue1");
			new slot = GetPVarInt(playerid, "DialogValue2");
			switch(listitem)
			{
			case 0:
			{
				new weaponid = GetPlayerWeapon(playerid);
				if(weaponid == 0)
				{
					ShowPlayerDialog(playerid, DIALOG_ERROR, DIALOG_STYLE_MSGBOX, "ERROR", "You don't have a weapon in your hands!", "OK", "");
					return 1;
				}
				VehicleTrunk[vehicleid][slot][0] = weaponid;
				if(IsMeleeWeapon(weaponid)) VehicleTrunk[vehicleid][slot][1] = 1;
				else VehicleTrunk[vehicleid][slot][1] = GetPlayerAmmo(playerid);
				RemovePlayerWeapon(playerid, weaponid);
				SaveVehicle(vehicleid);
			}
			case 1:
			{
				if(VehicleTrunk[vehicleid][slot][1] <= 0)
				{
					ShowPlayerDialog(playerid, DIALOG_ERROR, DIALOG_STYLE_MSGBOX, "ERROR", "This slot is empty!", "OK", "");
					return 1;
				}
				GivePlayerWeapon(playerid, VehicleTrunk[vehicleid][slot][0], VehicleTrunk[vehicleid][slot][1]);
				VehicleTrunk[vehicleid][slot][0] = 0;
				VehicleTrunk[vehicleid][slot][1] = 0;
				SaveVehicle(vehicleid);
			}
			}
		}
		ShowDialog(playerid, DIALOG_TRUNK);
		return 1;
	}
	if(dialogid == DIALOG_VEHICLE_PLATE)
	{
		if(response)
		{
			if(strlen(inputtext) < 1 || strlen(inputtext) >= sizeof(VehicleNumberPlate[]))
			{
				ShowErrorDialog(playerid, "Invalid length!");
				return 1;
			}
			new id = GetPVarInt(playerid, "DialogValue1");
			new vehicleid = VehicleID[id];
			strcpy(VehicleNumberPlate[id], sizeof(VehicleNumberPlate[]), inputtext);
			SaveVehicle(id);
			SetVehicleNumberPlate(vehicleid, inputtext);
			SetVehicleToRespawn(vehicleid);
			new msg[128];
			format(msg, sizeof(msg), "You have changed vehicle number plate to %s", inputtext);
			SendClientMessage(playerid, COLOR_WHITE, msg);
		}
		else ShowDialog(playerid, DIALOG_VEHICLE);
		return 1;
	}
	if(dialogid == DIALOG_FUEL)
	{
		if(response)
		{
			switch(listitem)
			{
			case 0:
			{
				if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
				{
					ShowErrorDialog(playerid, "You are not driving a vehicle!");
					return 1;
				}
				new vehicleid = GetPlayerVehicleID(playerid);
				if(IsBicycle(vehicleid))
				{
					ShowErrorDialog(playerid, "Your vehicle doesn't have a fuel tank!");
					return 1;
				}
				if(Fuel[vehicleid] >= 100.0)
				{
					ShowErrorDialog(playerid, "Your vehicle fuel tank is full!");
					return 1;
				}
				if(GetPlayerMoney(playerid) < FUEL_PRICE)
				{
					ShowErrorDialog(playerid, "You don't have enough money!");
					return 1;
				}
				RefuelTime[playerid] = 5;
				SetPVarFloat(playerid, "Fuel", Fuel[vehicleid]);
				GameTextForPlayer(playerid, "~w~refueling...", 2000, 3);
			}
			case 1:
			{
				if(GetPVarInt(playerid, "GasCan"))
				{
					ShowErrorDialog(playerid, "You already have a gas can!");
					return 1;
				}
				if(GetPlayerMoney(playerid) < GAS_CAN_PRICE)
				{
					ShowErrorDialog(playerid, "You don't have enough money!");
					return 1;
				}
				GivePlayerCash(playerid, -GAS_CAN_PRICE);
				SetPVarInt(playerid, "GasCan", 1);
				SendClientMessage(playerid, COLOR_WHITE, "You have bought a gas can for $" #GAS_CAN_PRICE );
			}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_EDITVEHICLE)
	{
		if(response)
		{
			new id = GetPVarInt(playerid, "DialogValue1");
			new nr, params[128];
			sscanf(inputtext, "ds", nr, params);
			switch(nr)
			{
			case 1:
			{
				new value = strval(params);
				if(value < 0) value = 0;
				VehicleValue[id] = value;
				UpdateVehicleLabel(id, 1);
				SaveVehicle(id);
				ShowDialog(playerid, DIALOG_EDITVEHICLE);
			}
			case 2:
			{
				new value;
				if(IsNumeric(params)) value = strval(params);
				else value = GetVehicleModelIDFromName(params);
				if(value < 400 || value > 611)
				{
					ShowErrorDialog(playerid, "Invalid vehicle model!");
					return 1;
				}
				VehicleModel[id] = value;
				for(new i=0; i < sizeof(VehicleMods[]); i++)
				{
					VehicleMods[id][i] = 0;
				}
				VehiclePaintjob[id] = 255;
				UpdateVehicle(id, 1);
				SaveVehicle(id);
				ShowDialog(playerid, DIALOG_EDITVEHICLE);
			}
			case 3:
			{
				new color1, color2;
				sscanf(params, "dd", color1, color2);
				VehicleColor[id][0] = color1;
				VehicleColor[id][1] = color2;
				SaveVehicle(id);
				ChangeVehicleColor(VehicleID[id], color1, color2);
				ShowDialog(playerid, DIALOG_EDITVEHICLE);
			}
			case 4:
			{
				if(strlen(params) < 1 || strlen(params) > 8)
				{
					ShowErrorDialog(playerid, "Invalid length!");
					return 1;
				}
				strcpy(VehicleNumberPlate[id], sizeof(VehicleNumberPlate[]), params);
				SaveVehicle(id);
				SetVehicleNumberPlate(VehicleID[id], params);
				SetVehicleToRespawn(VehicleID[id]);
				ShowDialog(playerid, DIALOG_EDITVEHICLE);
			}
			case 5:
			{
				DestroyVehicle(VehicleID[id]);
				if(VehicleCreated[id] == VEHICLE_DEALERSHIP)
				{
					Delete3DTextLabel(VehicleLabel[id]);
				}
				VehicleCreated[id] = 0;
				SaveVehicle(id);
				new msg[128];
				format(msg, sizeof(msg), "You have deleted vehicle id %d", id);
				SendClientMessage(playerid, COLOR_WHITE, msg);
			}
			case 6:
			{
				if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
				{
					ShowErrorDialog(playerid, "You are not driving the vehicle!");
					return 1;
				}
				GetVehiclePos(VehicleID[id], VehiclePos[id][0], VehiclePos[id][1], VehiclePos[id][2]);
				GetVehicleZAngle(VehicleID[id], VehiclePos[id][3]);
				SendClientMessage(playerid, COLOR_WHITE, "You have parked this vehicle here");
				UpdateVehicle(id, 1);
				PutPlayerInVehicle(playerid, VehicleID[id], 0);
				SaveVehicle(id);
				ShowDialog(playerid, DIALOG_EDITVEHICLE);
			}
			case 7:
			{
				new Float:x, Float:y, Float:z;
				GetVehiclePos(VehicleID[id], x, y, z);
				SetPlayerPos(playerid, x, y, z+1);
				new msg[128];
				format(msg, sizeof(msg), "You have teleported to vehicle id %d", id);
				SendClientMessage(playerid, COLOR_WHITE, msg);
			}
			}
		}
	}
	return 1;
}
public ClearChatboxToAll(playerid, lines)
{
	if (IsPlayerConnected(playerid))
	{
		for(new i=0; i<lines; i++)
		{
			SendClientMessageToAll(COLOR_GREY, " ");
		}
	}
	return 1;
}
public OOCOff(color,const string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(!gOoc[i])
		    {
				SendClientMessage(i, color, string);
			}
		}
	}
}
public ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5)
{
	if(IsPlayerConnected(playerid))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		//radi = 2.0; //Trigger Radius
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i) && (GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i)))
			{
				if(!BigEar[i])
				{
					GetPlayerPos(i, posx, posy, posz);
					tempposx = (oldposx -posx);
					tempposy = (oldposy -posy);
					tempposz = (oldposz -posz);
					//printf("DEBUG: X:%f Y:%f Z:%f",posx,posy,posz);
					if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
					{
						SendClientMessage(i, col1, string);
					}
					else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
					{
						SendClientMessage(i, col2, string);
					}
					else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
					{
						SendClientMessage(i, col3, string);
					}
					else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
					{
						SendClientMessage(i, col4, string);
					}
					else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
					{
						SendClientMessage(i, col5, string);
					}
				}
				else
				{
					SendClientMessage(i, col1, string);
				}
			}
		}
	}//not connected
	return 1;
}
public ClearChatboxToAll2(playerid, lines)//newbie chat
{
    for(new k=0; k<MAX_PLAYERS; k++)
    {
	   if (IsPlayerConnected(k))
	   {
		  for(new i=0; i<lines; i++)
		  {
              if (PlayerInfo[k][pLevel] < 4)
              {
                 SendClientMessage(k, COLOR_GREY, " ");
              }
          }
       }
	}
	return 1;
}
public split(const strsrc[], strdest[][], delimiter)
{
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc)){
	    if(strsrc[i]==delimiter || i==strlen(strsrc)){
	        len = strmid(strdest[aNum], strsrc, li, i, 128);
	        strdest[aNum][len] = 0;
	        li = i+1;
	        aNum++;
		}
		i++;
	}
	return 1;
}
public SendAdminMessage(color, string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(PlayerInfo[i][pAdmin] >= 1)
		    {
				SendClientMessage(i, color, string);
			}
		}
	}
}
public SendTesterMessage(color, string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(PlayerInfo[i][pTester] >= 1)
		    {
				SendClientMessage(i, color, string);
			}
		}
	}
}
public ProxDetectorS(Float:radi, playerid, targetid)
{
    if(IsPlayerConnected(playerid)&&IsPlayerConnected(targetid))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		//radi = 2.0; //Trigger Radius
		GetPlayerPos(targetid, posx, posy, posz);
		tempposx = (oldposx -posx);
		tempposy = (oldposy -posy);
		tempposz = (oldposz -posz);
		//printf("DEBUG: X:%f Y:%f Z:%f",posx,posy,posz);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
			return 1;
		}
	}
	return 0;
}
public OnPlayerText(playerid, text[])
{
    if(PlayerInfo[playerid][pMuted] == 1)
	{
		SendClientMessage(playerid, COLOR_RED, "You cannot speak, you have been silenced");
		return 0;
	}
	if(Mobile[playerid] != 255)
	{
		new string[128], sendername[MAX_PLAYER_NAME];
		GetPlayerName(playerid, sendername, sizeof(sendername));
		sendername[strfind(sendername,"_")] = ' ';
		format(string, sizeof(string), "%s Says (cellphone): %s", sendername, text);
        ProxDetector(20.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
	}
    if (realchat)
	{
      	new sendername[MAX_PLAYER_NAME], string[128];
		GetPlayerName(playerid, sendername, sizeof(sendername));
		sendername[strfind(sendername,"_")] = ' ';
		format(string, sizeof(string), "%s Says: %s", sendername, text);
		ProxDetector(20.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
		new lengthtime = strlen(text);
        new time = lengthtime*50;
		ApplyAnimation(playerid,"PED","IDLE_CHAT",4.0,0,0,0,0,time);
		return 0;
	}
	return 1;
}
public newbietimer()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
        ntimer[i] -= 10;
    }
}
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    if(!ispassenger)
	{
		new id = GetVehicleID(vehicleid);
		if(IsValidVehicle(id) && VehicleCreated[id] == VEHICLE_PLAYER)
		{
			new msg[128];
			format(msg, sizeof(msg), "This vehicle belongs to %s", VehicleOwner[id]);
			SendClientMessage(playerid, COLOR_GREY, msg);
		}
	}
	return 1;
}
public RACtime(playerid)
{
	  for(new player=0; player<MAX_PLAYERS; player++)
      {
  	  	if(!IsVehicleOccupied(player)) SetVehicleToRespawn(player);
      }
      for(new car = 1; car <= 1000; car++)
      {
          if(!IsVehicleOccupied(car)) SetVehicleToRespawn(car);
      }
      return 1;
}
public ABroadCast(color,const string[],level)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if (PlayerInfo[i][pAdmin] >= level)
			{
				SendClientMessage(i, color, string);
			}
		}
	}
	return 1;
}
public TBroadCast(color,const string[],level)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if (PlayerInfo[i][pTester] >= level)
			{
				SendClientMessage(i, color, string);
			}
		}
	}
	return 1;
}

//================================[COMMANDS]====================================
	CMD:veh(playerid, params[])
    {
            if(PlayerInfo[playerid][pAdmin] >= 4)
            {
            new veh,color1,color2;
            if (!sscanf(params, "iii", veh, color1,color2))
            {
                      new Float:x, Float:y, Float:z;
                      GetPlayerPos(playerid, x,y,z);
                      AddStaticVehicle(veh, x,y,z,0,color1, color2);
            }
            else SendClientMessage(playerid, 0xFFFFFFFF, "Usage: /veh [carid] [Color 1] [Color 2]");
            }
            else SendClientMessage(playerid, 0xFFFFFFFF, "You do not have the rights to use that command!");
        	return 1;
    }
   
    CMD:stats(playerid, params[])
    {
        if(gPlayerLogged[playerid] == 1)
        {
			ShowStats(playerid, playerid);
		}
		else
		{
		    SCM(playerid, COLOR_GREY,"You are not logged in!");
		}
		return 1;
	}
	CMD:th(playerid, params[])
	{
	    new string[128];
	    if(!(PlayerInfo[playerid][pTester] == 1)) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
	    if(PlayerInfo[playerid][pTester] == 1)
	    {
	        format(string, sizeof(string),"***Testers Commands:{C3C3C3} /goto /gethere /respawn /cc /cnc /mute /unmute /tc [text] (tester/admin chat) /tod /sendtols");
	        SendClientMessage(playerid, COLOR_GRAD1, string);
		}
	    return 1;
	}
	CMD:ah(playerid, params[])
	{
	    if(!(PlayerInfo[playerid][pAdmin] >= 1)) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
	    new string[128];
	    if(PlayerInfo[playerid][pAdmin] >= 1)
		{
		    format(string, sizeof(string),"***Admin Level 1:{C3C3C3} /goto /gethere /respawn /healall /kick /ban /cc /cnc /a [text] (admin chat)");
		    SendClientMessage(playerid, COLOR_GRAD1, string);
		   	format(string, sizeof(string),"***Admin Level 1:{C3C3C3} /warn /aod /unban /unbanip /freeze /unfreeze /check /mute /unmute /acceptreport /markfalse");
            SendClientMessage(playerid, COLOR_GRAD1, string);
		}
		if(PlayerInfo[playerid][pAdmin] >= 2)
		{
		    format(string, sizeof(string),"***Admin Level 2:{C3C3C3} /gotols /gotolv /gotosf /sendtols");
		    SendClientMessage(playerid, COLOR_GRAD1, string);
		}
		if(PlayerInfo[playerid][pAdmin] >= 4)
		{
			format(string, sizeof(string),"***Admin Level 4:{C3C3C3} /veh /setskin /sethp /givegun");
			SendClientMessage(playerid, COLOR_GRAD1, string);
		}
		if(PlayerInfo[playerid][pAdmin] >= 1337)
		{
		    format(string, sizeof(string),"***Admin Level 1337:{C3C3C3} /rac /setlevel /givemoney");
		    SendClientMessage(playerid, COLOR_GRAD1, string);
		}
		if(PlayerInfo[playerid][pAdmin] >= 1338)
		{
		    format(string, sizeof(string),"***Admin Level 1338:{C3C3C3} /maketester /makeadmin /changename /addv /editv /setfuel");
		    SendClientMessage(playerid, COLOR_GRAD1,  string);
		    format(string, sizeof(string),"***Admin Level 1338:{C3C3C3} /adddealership /deletedealership /movedealership /gotodealership");
		    SendClientMessage(playerid, COLOR_GRAD1,  string);
		    format(string, sizeof(string),"***Admin Level 1338:{C3C3C3} /addfuelstation /deletefuelstation /movefuelstation /gotofuelstation");
		    SendClientMessage(playerid, COLOR_GRAD1,  string);
		}
		return 1;
	}

CMD:help(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1)
	{
		SendClientMessage(playerid, COLOR_GRAD2,"***Admin: /ah");
	}
	if(PlayerInfo[playerid][pTester] >= 1)
	{
		SendClientMessage(playerid, COLOR_GRAD2,"***Tester: /th");
	}
	SendClientMessage(playerid, COLOR_GRAD1,"{FFAF00}*** ACCOUNT *** {C3C3C3}/rules /forum /stats /buylevel");
	SendClientMessage(playerid, COLOR_GRAD2,"{FFAF00}*** GENERAL *** {C3C3C3}/me /anims /do /time /helpme /report /(c)all /(h)angup /(p)ickup /number");
	SendClientMessage(playerid, COLOR_GRAD2,"{FFAF00}*** GENERAL *** {C3C3C3}/admins /testers /id /pay /newspaper /stopanim /takeexam");
	SendClientMessage(playerid, COLOR_GRAD2,"{FFAF00}*** CAR *** {C3C3C3}/v /tow /eject /ejectall /vlock /valarm /fuel /trunk");
	SendClientMessage(playerid, COLOR_GRAD2,"{FFAF00}*** CAR *** {C3C3C3}/clearmods /sellv /givecarkeys /trackcar /engine");
	SendClientMessage(playerid, COLOR_GRAD2,"{FFAF00}*** CHAT *** {C3C3C3}/b [local ooc chat] /s (shout) /low [low chat]");
	SendClientMessage(playerid, COLOR_GRAD2,"{FFAF00}*** CHAT *** {C3C3C3}/n (newbie chat) /w (whisper) /pm (private message ooc)");
	return 1;
}
CMD:setskin(playerid, params[])
{
	new id, ammount, name[MAX_PLAYER_NAME], string[128];
	if(!(PlayerInfo[playerid][pAdmin] >= 4)) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
	else if(sscanf(params,"ui", id, ammount)) return SCM(playerid, COLOR_GREY,"USAGE: /setskin [playerid/partofname] [skinmodel]");
	else if(ammount > 299 || ammount < 1) return SCM(playerid, COLOR_GREY,"Wrong Skin ID! Available ID's: 1-299");
	else if(!IsPlayerConnected(id)) return SCM(playerid, COLOR_GREY,"Invalid player id");
	else
	{
	GetPlayerName(playerid, name, sizeof(name));
	format(string, sizeof(string),"Your skin have been setted to %i by admin %s", ammount, name);
	SendClientMessage(id, COLOR_GREEN, string);
	PlayerInfo[id][pModel] = ammount;
	SetPlayerSkin(id, PlayerInfo[id][pModel]);
	}
	return 1;
}
CMD:sendtols(playerid, params[])
{
	new id, sendername[MAX_PLAYER_NAME], string[128];
	if(PlayerInfo[playerid][pAdmin] < 2 && PlayerInfo[playerid][pTester] < 1) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
	else if(sscanf(params,"u", id)) return SCM(playerid, COLOR_GREY,"USAGE: /sendtols [playerid/partofname]");
	else if(GetPlayerState(id) == 2)
	{
	    new tmpcar = GetPlayerVehicleID(id);
	    SetVehiclePos(tmpcar,1529.6,-1691.2,13.3);
	}
	else
	{
		SetPlayerPos(id, 1529.6,-1691.2,13.3);
	}
	GetPlayerName(playerid, sendername, sizeof(sendername));
	sendername[strfind(sendername,"_")] = ' ';
	format(string, sizeof(string),"You have been teleported to Los Santos by admin %s !", sendername);
	SendClientMessage(id, COLOR_GRAD1, string);
	SetPlayerInterior(id,0);
	SetPlayerVirtualWorld(id, 0);
	return 1;
}
CMD:setlevel(playerid, params[])
{
	new id, level, sendername[MAX_PLAYER_NAME], string[128];
	if(!(PlayerInfo[playerid][pAdmin] >= 1337)) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
	else if(sscanf(params,"ui", id, level)) return SCM(playerid, COLOR_GREY,"USAGE: /setlevel [playerid/partofname] [level]");
	else if(!IsPlayerConnected(id)) return SCM(playerid, COLOR_GREY,"Invalid player ID");
	else
	{
	    PlayerInfo[id][pLevel] = level;
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    sendername[strfind(sendername,"_")] = ' ';
	    format(string, sizeof(string),"Your level has been set to %i by admin %s", level, sendername);
	    SendClientMessage(id, COLOR_YELLOW, string);
	}
	return 1;
}
CMD:sethp(playerid, params[])
{
	new id, hp, sendername[MAX_PLAYER_NAME], string[128];
	if(!(PlayerInfo[playerid][pAdmin] >= 4)) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
	else if(sscanf(params,"ui", id, hp)) return SCM(playerid, COLOR_GREY,"USAGE: /sethp [playerid/partofname] [ammount]");
	else if(!IsPlayerConnected(id)) return SCM(playerid, COLOR_GREY,"Invalid player ID");
	else
	{
	    SetPlayerHealth(id, hp);
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    sendername[strfind(sendername,"_")] = ' ';
	    format(string, sizeof(string),"Your health has been set to %i by admin %s", hp, sendername);
	    SendClientMessage(id, COLOR_YELLOW, string);
	}
	return 1;
}
CMD:givegun(playerid, params[])
{
	new id, gun, ammo;
	if(!(PlayerInfo[playerid][pAdmin] >= 4)) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
	else if(sscanf(params,"uii", id, gun, ammo)) return SCM(playerid, COLOR_GREY,"USAGE: /givegun [playerid/partofname] [gunid] [ammo]");
	else if(gun > 47 || gun < 1) return SCM(playerid, COLOR_GREY,"GUN ID'S: 1-47");
	else if(ammo > 999 || ammo < 1) return SCM(playerid, COLOR_GREY,"Ammo 1-999");
	else
	{
	    GivePlayerWeapon(id, gun, ammo);
	}
	return 1;
}
	CMD:admins(playerid, params[])
	{
        if(IsPlayerConnected(playerid))
	    {
	        SendClientMessage(playerid, COLOR_GREY, " ");
	        SendClientMessage(playerid, COLOR_GREY, "-| Online Admins |-");
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
				    if(PlayerInfo[i][pAdmin] >= 1 && PlayerInfo[i][pAdmin] < 1339)
				    {
				        new admtext[64], sendername[MAX_PLAYER_NAME], string[128];
			         	if(PlayerInfo[i][pAdmin] == 1338) { admtext = "Owner"; }
		         	    else if(PlayerInfo[i][pAdmin] == 1337) { admtext = "Admin Level 1337"; }
				        else if(PlayerInfo[i][pAdmin] == 4) { admtext = "Admin Level 4"; }
						else if(PlayerInfo[i][pAdmin] == 3) { admtext = "Admin Level 3"; }
						else if(PlayerInfo[i][pAdmin] == 2)	{ admtext = "Admin Level 2"; }
						else if(PlayerInfo[i][pAdmin] == 1) { admtext = "Admin Level 1"; }
						else { admtext = "Admin Level 1"; }
						GetPlayerName(i, sendername, sizeof(sendername));
						sendername[strfind(sendername,"_")] = ' ';
						if(AdminDuty[i] == 0)
						{
							format(string, 128, "%s: %s (AdminDuty: No)", admtext, sendername);
							SendClientMessage(playerid, random(0xFFFFFFFF), string);
						}
						else
						{
						    format(string, 128, "%s: %s (AdminDuty: Yes)", admtext, sendername);
							SendClientMessage(playerid, 0xFAAFBEFF, string);

						}
					}
				}
			}
		}
		return 1;
	}
	CMD:testers(playerid, params[])
	{
        if(IsPlayerConnected(playerid))
	    {
	        SendClientMessage(playerid, COLOR_WHITE, " ");
	        SendClientMessage(playerid, COLOR_WHITE, "-| Online Testers |-");
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
				    if(PlayerInfo[i][pTester] >= 1 && PlayerInfo[i][pTester] < 1339)
				    {
				        new admtext[64], sendername[MAX_PLAYER_NAME], string[128];
						if(PlayerInfo[i][pTester] == 1) { admtext = "Tester"; }
						else { admtext = "Tester"; }
						GetPlayerName(i, sendername, sizeof(sendername));
						sendername[strfind(sendername,"_")] = ' ';
						if(TesterDuty[i] == 0)
						{
							format(string, 128, "%s: %s (TesterDuty: No)", admtext, sendername);
							SendClientMessage(playerid, random(0xFFFFFFFF), string);
						}
						else
						{
						    format(string, 128, "%s: %s (TesterDuty: Yes)", admtext, sendername);
							SendClientMessage(playerid, COLOR_GREEN, string);

						}
					}
				}
			}
		}
		return 1;
	}
	
CMD:gotols(playerid, params[])
{
	if(!(PlayerInfo[playerid][pAdmin] >= 2)) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
	else if(GetPlayerState(playerid) == 2)
	{
	    new tmpcar = GetPlayerVehicleID(playerid);
	    SetVehiclePos(tmpcar,1529.6,-1691.2,13.3);
	}
	else
	{
		SetPlayerPos(playerid, 1529.6,-1691.2,13.3);
	}
	SendClientMessage(playerid, COLOR_GRAD1, "   You have been teleported !");
	SetPlayerInterior(playerid,0);
	SetPlayerVirtualWorld(playerid, 0);
	return 1;
}
CMD:gotolv(playerid, params[])
{
	if(!(PlayerInfo[playerid][pAdmin] >= 2)) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
	else if(GetPlayerState(playerid) == 2)
	{
	    new tmpcar = GetPlayerVehicleID(playerid);
	    SetVehiclePos(tmpcar,1699.2, 1435.1, 10.7);
	}
	else
	{
		SetPlayerPos(playerid, 1699.2, 1435.1, 10.7);
	}
	SendClientMessage(playerid, COLOR_GRAD1, "   You have been teleported !");
	SetPlayerInterior(playerid,0);
	SetPlayerVirtualWorld(playerid, 0);
	return 1;
}
CMD:gotosf(playerid, params[])
{
	if(!(PlayerInfo[playerid][pAdmin] >= 2)) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
	else if(GetPlayerState(playerid) == 2)
	{
	    new tmpcar = GetPlayerVehicleID(playerid);
	    SetVehiclePos(tmpcar,-1417.0,-295.8,14.1);
	}
	else
	{
		SetPlayerPos(playerid, -1417.0,-295.8,14.1);
	}
	SendClientMessage(playerid, COLOR_GRAD1, "   You have been teleported !");
	SetPlayerInterior(playerid,0);
	SetPlayerVirtualWorld(playerid, 0);
	return 1;
}
CMD:gethere(playerid,params[])
{
    new targetid, Float:x, Float:y, Float:z;
    if(PlayerInfo[playerid][pAdmin] < 1 && PlayerInfo[playerid][pTester] < 1) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
    else if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /gethere [playerid/partofname]");
    else if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, "That player is not connected");
    else
    {
    	GetPlayerPos(playerid, x, y, z);
    	SetPlayerPos(targetid, x, y+0.5, z+0.5);
    }
    return 1;
}
CMD:goto(playerid, params[])
{
    new ID;
    if(PlayerInfo[playerid][pAdmin] < 1 && PlayerInfo[playerid][pTester] < 1) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
    else if(sscanf(params, "u", ID)) SendClientMessage(playerid, 0xF97804FF, "USAGE: /goto [partofname/playerid]");
    else if(!IsPlayerConnected(ID)) SendClientMessage(playerid, 0xF97804FF, "Player is not connected!");
    else
    {
    	new Float:x, Float:y, Float:z;
    	GetPlayerPos(ID, x, y, z);
    	SetPlayerPos(playerid, x+1, y+1, z);
    }
    return 1;
}
CMD:respawn(playerid, params[])
{
	new id, sendername[MAX_PLAYER_NAME], name[MAX_PLAYER_NAME], string[128];
	if(PlayerInfo[playerid][pAdmin] < 1 && PlayerInfo[playerid][pTester] < 1) return SCM(playerid, COLOR_GREY,"You are not authorized to use  this command");
	else if(sscanf(params,"u", id)) return SCM(playerid, COLOR_GREY,"USAGE: /respawn [playerid/partofname]");
	else if(!IsPlayerConnected(id)) return SCM(playerid, COLOR_GREY,"Invalid player ID");
	else
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    sendername[strfind(sendername,"_")] = ' ';
	    GetPlayerName(id, name, sizeof(name));
	    SpawnPlayer(id);
	    format(string, sizeof(string), "*You have respawned player %s", name);
	    SendClientMessage(playerid, COLOR_YELLOW, string);
	    format(string, sizeof(string), "*You have been respawned by admin %s", sendername);
	    SendClientMessage(id, COLOR_YELLOW, string);
	    ABroadCast(COLOR_YELLOW,string,1);
	   	TBroadCast(COLOR_YELLOW,string,1);
	}
	return 1;
}
CMD:healall(playerid, params[])
{
	new sendername[MAX_PLAYER_NAME], string[128];
	GetPlayerName(playerid, sendername, sizeof(sendername));
	sendername[strfind(sendername,"_")] = ' ';
	if(!(PlayerInfo[playerid][pAdmin] >= 4)) return SCM(playerid, COLOR_GREY,"you are not authorized to use this command");
	else
	{
 	format(string, sizeof(string), "Admin %s has healed everyone", sendername);
 	SendClientMessageToAll(COLOR_GREEN, string);
	for(new i = 0; i < MAX_PLAYERS; i ++)
	SetPlayerHealth(i,100);
	}
	return 1;
}
CMD:makeadmin(playerid, params[])
{
    new pID, value;
	if(PlayerInfo[playerid][pAdmin] < 1338 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, 0xFF0000AA, " you are not authorized to use this command!");
	else if (sscanf(params, "ui", pID, value)) return SendClientMessage(playerid, 0xFF0000AA, "Usage: /makeadmin [playerid/partofname] [level 1-1338]");
	else if (value < 0 || value > 1338) return SendClientMessage(playerid, 0xFF0000AA, "Unknown level! Only 0 to 1338");
	else if(pID == INVALID_PLAYER_ID) return SCM(playerid, COLOR_GREY,"Invalid player id");
	else
	{
	   	new pName[MAX_PLAYER_NAME], tName[MAX_PLAYER_NAME], string[128];
	   	GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
	    GetPlayerName(pID, tName, MAX_PLAYER_NAME);
	    format(string, sizeof(string), "You have promoted %s to Admin level %i", tName, value);
	    SCM(playerid, COLOR_LIGHTBLUE, string);
	    format(string, sizeof(string), "You have been promoted to Admin level %i by %s", value, pName);
	    SCM(pID, COLOR_LIGHTBLUE, string);
	    PlayerInfo[pID][pAdmin] = value;
    }
    return 1;
}
CMD:maketester(playerid, params[])
{
    new pID, value;
	if(PlayerInfo[playerid][pAdmin] < 1338 && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, 0xFF0000AA, " you are not authorized to use this command!");
	else if (sscanf(params, "ui", pID, value)) return SendClientMessage(playerid, 0xFF0000AA, "Usage: /maketester [playerid/partofname] [1]");
	else if (value < 0 || value > 1) return SendClientMessage(playerid, 0xFF0000AA, "Unknown level! Available level: 1");
	else if(pID == INVALID_PLAYER_ID) return SCM(playerid, COLOR_GREY,"Invalid player id");
	else
	{
	   	new pName[MAX_PLAYER_NAME], tName[MAX_PLAYER_NAME], string[128];
	   	GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
	    GetPlayerName(pID, tName, MAX_PLAYER_NAME);
	    format(string, sizeof(string), "You have promoted %s to Tester", tName);
	    SCM(playerid, COLOR_LIGHTBLUE, string);
	    format(string, sizeof(string), "You have been promoted to Tester by %s", pName);
	    SCM(pID, COLOR_LIGHTBLUE, string);
	    PlayerInfo[pID][pTester] = value;
    }
    return 1;
}
CMD:warn(playerid, params[])
{
	new id, sendername[MAX_PLAYER_NAME], name[MAX_PLAYER_NAME], reason[35], string[128];
	if(PlayerInfo[playerid][pAdmin] < 1) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
	if(sscanf(params,"uz",id,reason)) return SCM(playerid, COLOR_WHITE,"USAGE: /warn [playerid/partofname] [reason]");
	if(!IsPlayerConnected(id)) return SCM(playerid, COLOR_GREY,"Invalid player id");
	else
	{
	    if(PlayerInfo[id][pWarns] >= 5)
	    {
	        format(string, sizeof(string), "AdmCmd: %s was banned by %s (Had 5 Warnings) reason %s", name, sendername, reason);
	        SendClientMessageToAll(COLOR_LIGHTRED, string);
			PlayerInfo[id][pLocked] = 1;
			new plrIP[16];
		 	GetPlayerIp(id,plrIP, sizeof(plrIP));
		  	SendClientMessage(id,COLOR_DBLUE,"|___________[BAN INFO]___________|");
		  	format(string, sizeof(string), "Your name: %s.",name);
		  	SendClientMessage(id, COLOR_WHITE, string);
		  	format(string, sizeof(string), "Your ip is: %s.",plrIP);
		  	SendClientMessage(id, COLOR_WHITE, string);
		  	format(string, sizeof(string), "You were banned by: %s.",sendername);
		  	SendClientMessage(id, COLOR_WHITE, string);
		  	format(string, sizeof(string), "You were banned for: %s.",reason);
		  	SendClientMessage(id, COLOR_WHITE, string);
		  	SendClientMessage(id,COLOR_DBLUE,"|___________[BAN INFO]___________|");
			Ban(id);
		}
		PlayerInfo[id][pWarns] += 1;
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    sendername[strfind(sendername,"_")] = ' ';
	    GetPlayerName(id, name, sizeof(name));
	    format(string, sizeof(string), "You were warned by %s, reason: %s", sendername, reason);
	    SendClientMessage(id, COLOR_LIGHTRED, string);
	    format(string, sizeof(string), "AdmCmd: %s was warned by %s, reason %s", name, sendername, reason);
	    SendClientMessageToAll(COLOR_LIGHTRED,string);
	}
	return 1;
}
CMD:unmute(playerid,params[])
{
	new id, name1[MAX_PLAYER_NAME], name2[MAX_PLAYER_NAME], string[128];
	if(PlayerInfo[playerid][pAdmin] < 1 && PlayerInfo[playerid][pTester] < 1) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
	if(sscanf(params,"u", id)) return SCM(playerid, COLOR_GREY,"USAGE: /unmute [playerid/partofname]");
	if(!IsPlayerConnected(id)) return SCM(playerid, COLOR_GREY,"Invalid player ID");
	else
	{
	    PlayerInfo[id][pMuted] = 0;
	    PlayerInfo[id][pMuteTime] = 0;
	    GetPlayerName(playerid,name1,sizeof(name1));
		GetPlayerName(id,name2,sizeof(name2));
		format(string, sizeof(string),"%s has been unsilenced by %s", name2, name1);
		SendClientMessageToAll(COLOR_LIGHTRED,string);
	}
	return 1;
}
CMD:mute(playerid,params[])
{
	new id,time,name1[MAX_PLAYER_NAME],reason[35],name2[MAX_PLAYER_NAME], string[128];
	if(PlayerInfo[playerid][pAdmin] < 1 && PlayerInfo[playerid][pTester] < 1) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
	if(sscanf(params,"uiz", id, time, reason)) return SCM(playerid, COLOR_GREY,"USAGE: /mute [playerid/partofname] [minutes] [reason]");
	if(!IsPlayerConnected(id)) return SCM(playerid, COLOR_GREY,"Invalid player id");
	else
	{
	    PlayerInfo[id][pMuted] = 1;
	    PlayerInfo[id][pMuteTime] = time*60;
	    GetPlayerName(playerid,name1,sizeof(name1));
	    GetPlayerName(id,name2,sizeof(name2));
	    format(string, sizeof(string), "AdmCmd: %s was silenced by %s for %d minute(s) reason: %s",name2 ,name1,time,reason);
		SendClientMessageToAll(COLOR_LIGHTRED,string);
	}
	return 1;
}
CMD:report(playerid,params[])
{
	new id, reason[35], string[128], sendername[MAX_PLAYER_NAME], name[MAX_PLAYER_NAME];
	if(sscanf(params,"uz", id, reason)) return SCM(playerid, COLOR_GREY,"USAGE: /report [playerid/partofname] [reason]");
	if(!IsPlayerConnected(id)) return SCM(playerid, COLOR_GREY,"Invalid player ID");
	else
	{
		GetPlayerName(id, name,sizeof(name));
		GetPlayerName(playerid, sendername, sizeof(sendername));
		sendername[strfind(sendername,"_")] = ' ';
 		format(string, sizeof(string), "[ID:%d] %s has reported %s: %s.", playerid, sendername, name, reason);
		ABroadCast(COLOR_LIGHTRED,string,1);
		format(string, sizeof(string), "Use /markfalse [id] or /acceptreport [id]");
		ABroadCast(COLOR_LIGHTBLUE,string,1);
		format(string, sizeof(string), "Your report was just send to the online admins, please wait for a reply");
		SendClientMessage(playerid,COLOR_LIGHTRED,string);
		PlayerNeedsHelp[playerid] = 1;
		return 1;
	}
}
CMD:kick(playerid,params[])
{
    new id,name1[MAX_PLAYER_NAME], reason[35],name2[MAX_PLAYER_NAME], string[128];
    if(PlayerInfo[playerid][pAdmin] < 1) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
    if(sscanf(params,"uz",id,reason)) return SCM(playerid, COLOR_WHITE,"USAGE: /kick [playerid/partofname] [reason]");
    if(!IsPlayerConnected(id)) return SCM(playerid, COLOR_GREY,"Invalid player id");
    else
    {
	    GetPlayerName(playerid,name1,sizeof(name1));
	    GetPlayerName(id,name2,sizeof(name2));
	    format(string, sizeof(string),"AdmCmd: %s was kicked by %s, reason: %s",name2,name1,reason);
	    SendClientMessageToAll(COLOR_LIGHTRED,string);
	    Kick(id);
    }
    return 1;
}
CMD:ban(playerid, params[])
{
	new id, name[MAX_PLAYER_NAME], reason[35], name1[MAX_PLAYER_NAME], name2[MAX_PLAYER_NAME], string[128];
	if(!(PlayerInfo[playerid][pAdmin] >= 1)) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
	if(sscanf(params,"uz", id, reason)) return SCM(playerid, COLOR_WHITE,"USAGE: /ban [playerid/partofname] [reason]");
	if(id == INVALID_PLAYER_ID) return SCM(playerid, COLOR_GREY,"Invalid player id");
	else
	{
	    if(PlayerInfo[id][pAdmin] >= 1)
	    {
	        SendClientMessage(playerid,COLOR_GREY,"That player can not be banned");
         	GetPlayerName(playerid, name, sizeof(name));
         	format(string, 128, "AdmWarning: %s tryes banning an admin!", name);
         	ABroadCast(COLOR_YELLOW,string,1);
         	return 1;
		}
		GetPlayerName(playerid, name1, sizeof(name1));
		GetPlayerName(id, name2, sizeof(name2));
 		format(string, sizeof(string), "AdmCmd: %s was banned by %s, reason: %s", name2, name1, reason);
 		SendClientMessageToAll(COLOR_LIGHTRED, string);
 		PlayerInfo[id][pLocked] = 1;
	 	new plrIP[16];
	 	GetPlayerIp(id,plrIP, sizeof(plrIP));
	  	SendClientMessage(id,COLOR_DBLUE,"|___________[BAN INFO]___________|");
	  	format(string, sizeof(string), "Your name: %s.",name2);
	  	SendClientMessage(id, COLOR_WHITE, string);
	  	format(string, sizeof(string), "Your ip is: %s.",plrIP);
	  	SendClientMessage(id, COLOR_WHITE, string);
	  	format(string, sizeof(string), "You were banned by: %s.",name1);
	  	SendClientMessage(id, COLOR_WHITE, string);
	  	format(string, sizeof(string), "You were banned for: %s.",reason);
	  	SendClientMessage(id, COLOR_WHITE, string);
	  	SendClientMessage(id,COLOR_DBLUE,"|___________[BAN INFO]___________|");
		Ban(id);
	}
	return 1;
}
CMD:unbanip(playerid, params[])
{
	new id, string[128], sendername[MAX_PLAYER_NAME];
    if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid, COLOR_GRAD1, "   you are not authorized to use that command!");
	if(isnull(params)) return SCM(playerid,COLOR_WHITE,"USAGE: /unbanip [playerIP]");
	format(string,sizeof(string),"unbanip %s",params);
	SendRconCommand(string);
	SendRconCommand("reloadbans");
	PlayerInfo[id][pLocked] = 0;
	GetPlayerName(playerid, sendername, sizeof(sendername));
	format(string, 128, "[ADMIN]: %s has unbanned IP %s", sendername,params);
	ABroadCast(COLOR_YELLOW,string,1);
	return 1;
}
CMD:unban(playerid, params[])
{
	new id, string[128], sendername[MAX_PLAYER_NAME], name[MAX_PLAYER_NAME];
	if(PlayerInfo[playerid][pAdmin] < 1) return SCM(playerid, COLOR_GRAD1,"You are not authorized to use this command");
	else if(sscanf(params,"u", id)) return SCM(playerid, COLOR_GREY,"USAGE: /unban [playername]");
	else
	{
		PlayerInfo[id][pLocked] = 0;
		GetPlayerName(playerid, sendername, sizeof(sendername));
		GetPlayerName(id, name, sizeof(name));
		format(string, sizeof(string),"%s has been unbanned by admin %s", name, sendername);
		ABroadCast(COLOR_YELLOW,string,1);
		TBroadCast(COLOR_YELLOW,string,1);
	}
	return 1;
}
CMD:a(playerid, params[])
{
    new sendername[MAX_PLAYER_NAME], string[160];
    if(!(PlayerInfo[playerid][pAdmin] >= 1)) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
    if(isnull(params)) return SCM(playerid,COLOR_GOLD,"USAGE: /a [chat]");
    GetPlayerName(playerid,sendername,sizeof(sendername));
    sendername[strfind(sendername,"_")] = ' ';
    format(string,160,"*%d Admin %s: %s",PlayerInfo[playerid][pAdmin],sendername,params);
    SendAdminMessage(COLOR_GOLD, string);
    SendTesterMessage(COLOR_GOLD, string);
    return 1;
}
CMD:tc(playerid, params[])
{
    new sendername[MAX_PLAYER_NAME], string[160];
    if(!(PlayerInfo[playerid][pTester] >= 1)) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
    if(isnull(params)) return SCM(playerid,COLOR_GOLD,"USAGE: /tc [chat]");
    GetPlayerName(playerid,sendername,sizeof(sendername));
    sendername[strfind(sendername,"_")] = ' ';
    format(string,160,"*Tester %s: %s",sendername,params);
    SendAdminMessage(COLOR_GOLD, string);
    SendTesterMessage(COLOR_GOLD, string);
    return 1;
}
CMD:n(playerid, params[])
{
	new sendername[MAX_PLAYER_NAME], string[160];
	if(isnull(params)) return SCM(playerid,COLOR_GREEN,"USAGE: /n [AskQustions/Help]");
	GetPlayerName(playerid,sendername,sizeof(sendername));
	sendername[strfind(sendername,"_")] = ' ';
	if(PlayerInfo[playerid][pMuted] == 1)
	{
		SendClientMessage(playerid, COLOR_RED, "   You can't speak, you have been silenced !");
		return 1;
	}
	if (PlayerInfo[playerid][pAdmin] < 1)
 	{
 		format(string, sizeof(string), "* Newbie Level %d (%d)%s: %s", PlayerInfo[playerid][pLevel], playerid, sendername, params);
   	}
 	else
 	{
  		format(string, sizeof(string), "* %d Admin {FFAF00}%s: {C9FFAB}%s", PlayerInfo[playerid][pAdmin],sendername, params);
 	}
	if(PlayerInfo[playerid][pTester] == 1)
	{
	    format(string, sizeof(string), "* Tester {C9FFAB}%s: {FFAF00}%s", sendername, params);
	}
 	if(ntimer[playerid] < 1 || PlayerInfo[playerid][pAdmin] >=1 || PlayerInfo[playerid][pTester] >= 1)
	{ }
	else
 	{
 		SendClientMessage(playerid, COLOR_GREY, "You must wait 30 seconds for every message");
 		return 1;
 	}
	for (new n=0; n<MAX_PLAYERS; n++)
 	{
  		if (IsPlayerConnected(n) && (PlayerInfo[n][pLevel] < 4 || PlayerInfo[n][pAdmin] > 0) || PlayerInfo[n][pTester] > 0)
    	{
     		SendClientMessage(n, COLOR_LIGHTGREEN, string);
     		ntimer[playerid] = 30;
     	}
    }
    return 1;
}
CMD:cc(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1 && PlayerInfo[playerid][pTester] < 1) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
	else
	{
	    new string[128], sendername[MAX_PLAYER_NAME];
		ClearChatboxToAll(playerid,100);
		GetPlayerName(playerid, sendername, sizeof(sendername));
		sendername[strfind(sendername,"_")] = ' ';
		format(string, sizeof(string),"AdmCmd: %s has cleared the chat", sendername);
		SendClientMessageToAll(COLOR_LIGHTRED,string);
	}
	return 1;
}
CMD:o(playerid, params[])
{
	new sendername[MAX_PLAYER_NAME], string[160];
	if(!(PlayerInfo[playerid][pAdmin] >= 1)) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
	if(isnull(params)) return SCM(playerid, COLOR_GREY,"USAGE: /o [chat]");
	if(gPlayerLogged[playerid] == 0)
 	{
 		SendClientMessage(playerid, COLOR_GREY, "   You havent logged in yet !");
 		return 1;
 	}
	if ((noooc) && PlayerInfo[playerid][pAdmin] < 1 && PlayerInfo[playerid][pTester] < 1)
	{
		SendClientMessage(playerid, COLOR_GRAD2, "   The OOC channel has been disabled by an Admin !");
		return 1;
	}
	GetPlayerName(playerid,sendername,sizeof(sendername));
	sendername[strfind(sendername,"_")] = ' ';
	format(string,160,"(( %s: %s ))", sendername, params);
	printf("%s", string);
	OOCOff(COLOR_OOC,string);
	return 1;
}
CMD:noooc(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] >= 4 && (!noooc))
	{
		noooc = 1;
		SendClientMessageToAll(COLOR_GRAD2, "   OOC chat channel disabled by an Admin !");
	}
	else if (PlayerInfo[playerid][pAdmin] >= 3 && (noooc))
	{
		noooc = 0;
		SendClientMessageToAll(COLOR_GRAD2, "   OOC chat channel enabled by an Admin !");
	}
	else
	{
		SendClientMessage(playerid, COLOR_GRAD1, "   you are not authorized to use that command!");
	}
	return 1;
}

CMD:me(playerid, params[])
{
    new sendername[MAX_PLAYER_NAME], string[128];
	GetPlayerName(playerid, sendername, sizeof(sendername));
	sendername[strfind(sendername,"_")] = ' ';
	if(isnull(params)) return SCM(playerid,COLOR_GREY,"USAGE: /me [action]");
    format(string, sizeof(string), "*%s %s", sendername, params);
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	return 1;
}
CMD:do(playerid, params[])
{
    new sendername[MAX_PLAYER_NAME], string[128];
	GetPlayerName(playerid, sendername, sizeof(sendername));
	sendername[strfind(sendername,"_")] = ' ';
	if(isnull(params)) return SCM(playerid,COLOR_GREY,"USAGE: /do [action]");
    format(string, sizeof(string), "***%s (( %s ))", params, sendername);
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	return 1;
}
CMD:cnc(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1 && PlayerInfo[playerid][pTester] < 1) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
	else
	{
		new string[128], sendername[MAX_PLAYER_NAME];
		ClearChatboxToAll2(playerid,100);
		GetPlayerName(playerid, sendername, sizeof(sendername));
		format(string, sizeof(string), "AdmCmd: %s has cleared the newbie chat", sendername);
		SendClientMessageToAll(COLOR_LIGHTRED, string);
	}
	return 1;
}
CMD:rac(playerid, params[])
{
	if(!(PlayerInfo[playerid][pAdmin] >= 1337)) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
	else
	{
	    new string[128], sendername[MAX_PLAYER_NAME];
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    format(string, sizeof(string),"All unused cars will be respawned in 10 seconds by admin %s", sendername);
	    SendClientMessageToAll(COLOR_RED,string);
	    SetTimer("RACtime", 10000, 0);
	}
	return 1;
}
CMD:buylevel(playerid, params[])
{
    if(IsPlayerConnected(playerid))
    {
		if (gPlayerLogged[playerid] != 0)
		{
			PlayerInfo[playerid][pCash] = GetPlayerMoney(playerid);
			if(PlayerInfo[playerid][pLevel] >= 0)
			{
				new nxtlevel = PlayerInfo[playerid][pLevel]+1;
				new costlevel = nxtlevel*levelcost;
				new expamount = nxtlevel*levelexp;
				new infostring[128];
				if(GetPlayerMoney(playerid) < costlevel)
				{
					format(infostring, 128, "   You do not have enough Cash ($%d) !",costlevel);
					SendClientMessage(playerid, COLOR_GRAD1, infostring);
					return 1;
				}
				else if (PlayerInfo[playerid][pExp] < expamount)
				{
					format(infostring, 128, "   You need %d Respect Points, you curently have [%d] !",expamount,PlayerInfo[playerid][pExp]);
					SendClientMessage(playerid, COLOR_GRAD1, infostring);
					return 1;
				}
				else
				{
				        new string[128];
						format(string, sizeof(string), "~g~LEVEL UP~n~~w~You Are Now Level %d", PlayerInfo[playerid][pLevel]);
						GivePlayerCash(playerid, (-costlevel));
						PlayerInfo[playerid][pLevel]++;
						if(PlayerInfo[playerid][pVip] > 0)
						{
						    PlayerInfo[playerid][pExp] -= expamount;
						    new total = PlayerInfo[playerid][pExp];
						    if(total > 0)
						    {
						        PlayerInfo[playerid][pExp] = total;
						    }
						    else
						    {
						        PlayerInfo[playerid][pExp] -= expamount;
						    }
						}
						else
						{
							PlayerInfo[playerid][pExp] -= expamount;
						}
						GameTextForPlayer(playerid, string, 5000, 1);
				}
			}
			return 1;
		}
		else
		{
			SendClientMessage(playerid, COLOR_GRAD1, "   You are not Logged in !");
		}
	}
	return 1;
}
CMD:aod(playerid, params[])
{
	new sendername[MAX_PLAYER_NAME], string[128];
	if(PlayerInfo[playerid][pAdmin] < 1) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
	else if(AdminDuty[playerid] == 1)
 	{
  		GetPlayerName(playerid, sendername, sizeof(sendername));
  		sendername[strfind(sendername,"_")] = ' ';
	   	format(string, sizeof(string), "Admin %s is now off duty.", sendername,playerid);
	   	SendClientMessageToAll(COLOR_DBLUE,string);
	   	AdminDuty[playerid] = 0;
	   	SetPlayerHealth(playerid,100);
	   	SetPlayerArmour(playerid,0);
	   	SetOriginalColor(playerid);
   	}
   	else
   	{
   		GetPlayerName(playerid, sendername, sizeof(sendername));
   		sendername[strfind(sendername,"_")] = ' ';
  		format(string, sizeof(string), "Admin %s is now on duty.",sendername,playerid);
		SendClientMessageToAll(0xFAAFBEFF,string);
		AdminDuty[playerid] = 1;
		SetPlayerHealth(playerid,999);
		SetPlayerArmour(playerid,999);
		SetPlayerColor(playerid,0xFAAFBEFF);
  	}
	return 1;
}
CMD:tod(playerid, params[])
{
	new sendername[MAX_PLAYER_NAME], string[128];
	if(PlayerInfo[playerid][pTester] < 1) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
	else if(TesterDuty[playerid] == 1)
 	{
  		GetPlayerName(playerid, sendername, sizeof(sendername));
  		sendername[strfind(sendername,"_")] = ' ';
	   	format(string, sizeof(string), "Tester %s is now off duty.", sendername,playerid);
	   	SendClientMessageToAll(COLOR_DBLUE,string);
	   	TesterDuty[playerid] = 0;
	   	SetPlayerHealth(playerid,100);
	   	SetPlayerArmour(playerid,0);
	   	SetOriginalColor(playerid);
   	}
   	else
   	{
   		GetPlayerName(playerid, sendername, sizeof(sendername));
   		sendername[strfind(sendername,"_")] = ' ';
  		format(string, sizeof(string), "Tester %s is now on duty.",sendername,playerid);
		SendClientMessageToAll(0xFAAFBEFF,string);
		TesterDuty[playerid] = 1;
		SetPlayerHealth(playerid,999);
		SetPlayerArmour(playerid,999);
		SetPlayerColor(playerid,0xFAAFBEFF);
  	}
	return 1;
}
CMD:time(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
		    new mtext[20];
			new year, month,day;
			getdate(year, month, day);
			if(month == 1) { mtext = "January"; }
			else if(month == 2) { mtext = "February"; }
			else if(month == 3) { mtext = "March"; }
			else if(month == 4) { mtext = "April"; }
			else if(month == 5) { mtext = "May"; }
			else if(month == 6) { mtext = "June"; }
			else if(month == 7) { mtext = "Juli"; }
			else if(month == 8) { mtext = "August"; }
			else if(month == 9) { mtext = "September"; }
			else if(month == 10) { mtext = "October"; }
			else if(month == 11) { mtext = "November"; }
			else if(month == 12) { mtext = "December"; }
		    new hour,minuite,second;
			gettime(hour,minuite,second);
			FixHour(hour);
			hour = shifthour;
			new string[128];
			format(string, sizeof(string), "~y~%d %s~n~~g~|~w~%d:%d~g~|", day, mtext, hour, minuite);
			GameTextForPlayer(playerid, string, 5000, 1);
	}
	return 1;
}
CMD:rules(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GRAD1,"Read our /forum rules");
	return 1;
}
CMD:forum(playerid, params[])
{
	SCM(playerid, COLOR_GRAD1,"Forum not yet ^^ ");
	return 1;
}
CMD:s(playerid,params[])
{
	if(PlayerInfo[playerid][pMuted] == 1)
	{
	    SendClientMessage(playerid, COLOR_RED,"You can't speak you have been silenced");
	    return 1;
	}
	if(isnull(params)) return SCM(playerid, COLOR_GREY,"/s [text]");
	new sendername[MAX_PLAYER_NAME], string[128];
	GetPlayerName(playerid, sendername, sizeof(sendername));
	format(string, sizeof(string), "%s Shouts: %s!!", sendername, params);
	ProxDetector(30.0, playerid, string,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_FADE1,COLOR_FADE2);
	return 1;
}
CMD:shout(playerid, params[])
{
  return cmd_s(playerid, params);
}
CMD:b(playerid,params[])
{
	if(PlayerInfo[playerid][pMuted] == 1)
	{
	    SCM(playerid, COLOR_RED,"You can't speak you have been silenced");
	    return 1;
	}
	if(isnull(params)) return SCM(playerid, COLOR_GREY,"/b [local ooc chat]");
	new sendername[MAX_PLAYER_NAME], string[128];
	GetPlayerName(playerid,sendername,sizeof(sendername));
	sendername[strfind(sendername,"_")] = ' ';
	format(string, sizeof(string), "%s Says: (( %s ))", sendername, params);
	ProxDetector(20.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
	return 1;
}
CMD:booc(playerid, params[])
{
  return cmd_b(playerid, params);
}
CMD:low(playerid,params[])
{
	if(PlayerInfo[playerid][pMuted] == 1)
	{
		SCM(playerid, COLOR_RED,"You can't speec you have been silenced");
		return 1;
	}
	if(isnull(params)) return SCM(playerid, COLOR_GREY,"/low [low chat]");
	new sendername[MAX_PLAYER_NAME], string[128];
	GetPlayerName(playerid,sendername,sizeof(sendername));
	sendername[strfind(sendername,"_")] = ' ';
	format(string,sizeof(string), "%s Says [Low]: %s", sendername, params);
	ProxDetector(3.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
	return 1;
}
CMD:acceptreport(playerid, params[])
{
	new id, sendername[MAX_PLAYER_NAME], name[MAX_PLAYER_NAME], string[128];
	if(PlayerInfo[playerid][pAdmin] < 1) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
	if(sscanf(params,"u", id)) return SCM(playerid, COLOR_GREY," USAGE: /acceptreport [playerid]");
	if(!IsPlayerConnected(id)) return SCM(playerid, COLOR_GREY,"Player not connected");
	else
	{
	    if(PlayerNeedsHelp[id] == 1)
	    {
	        PlayerNeedsHelp[id] = 0;
     		GetPlayerName(playerid, sendername, sizeof(sendername));
			GetPlayerName(id, name, sizeof(name));
			format(string, sizeof(string), "[AdminCMD]: %s has just accepted the report of [ID:%d]%s.", sendername, id, name);
			ABroadCast(COLOR_YELLOW, string, 1);
			format(string, sizeof(string), "**[ID:%d] %s has accepted your report and now ready to assist you! Please be patience.", playerid, sendername);
			SendClientMessage(id, 0x4D903DAA, string);
		}
		else return SCM(playerid, COLOR_GREY,"Player don't need help!");
	}
	return 1;
}
CMD:markfalse(playerid, params[])
{
	new id, sendername[MAX_PLAYER_NAME], name[MAX_PLAYER_NAME], string[128];
	if(PlayerInfo[playerid][pAdmin] < 1) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
	if(sscanf(params,"u", id)) return SCM(playerid, COLOR_GREY," USAGE: /markfalse [playerid]");
	if(!IsPlayerConnected(id)) return SCM(playerid, COLOR_GREY,"Player not connected");
	else
	{
	    if(PlayerNeedsHelp[id] == 1)
	    {
	        PlayerNeedsHelp[id] = 0;
     		GetPlayerName(playerid, sendername, sizeof(sendername));
			GetPlayerName(id, name, sizeof(name));
			format(string, sizeof(string), "[AdminCMD]: %s has just marked as fals the report of [ID:%d]%s.", sendername, id, name);
			ABroadCast(COLOR_YELLOW, string, 1);
			format(string, sizeof(string), "**[ID:%d] %s has denied your report, please next time make sure what you report.", playerid, sendername);
			SendClientMessage(id, 0x4D903DAA, string);
		}
		else return SCM(playerid, COLOR_GREY,"Player don't need help!");
	}
	return 1;
}
CMD:id(playerid, params[])
{
	new id, name[MAX_PLAYER_NAME], string[128];
	if(sscanf(params,"u", id)) return SCM(playerid, COLOR_GREY,"USAGE: /id [playerid/partofname]");
	if(!IsPlayerConnected(id)) return SCM(playerid, COLOR_GREY,"Player not connected");
	else
	{
	    GetPlayerName(id, name, sizeof(name));
	    format(string,sizeof(string), "ID: (%d) %s", id, name);
	    SendClientMessage(playerid, COLOR_GRAD1, string);
	}
	return 1;
}

CMD:pm(playerid, params[])
{
    new PID, reason[35], pName[MAX_PLAYER_NAME], Sender[MAX_PLAYER_NAME];
    if(sscanf(params, "uz", PID, reason)) return SendClientMessage(playerid, 0xFF0000FF, "Usage: /PM < PlayerID > < Message >");
    if(!IsPlayerConnected(PID)) return SendClientMessage(playerid, 0xFF0000FF, "That user is not connected!");
    else
    {
    new Str[128];
    GetPlayerName(PID, pName, sizeof(pName));
    GetPlayerName(playerid, Sender, sizeof(Sender));
    format(Str, sizeof(Str), "(( PM From: %s(%d): %s ))", Sender, playerid, reason);
    SendClientMessage(PID, COLOR_GOLD, Str);
    format(Str, sizeof(Str), "(( PM Sent To: %s(%d): %s ))", pName, PID, reason);
    SendClientMessage(playerid, COLOR_GOLD, Str);
	}
    return 1;
}
CMD:whisper(playerid, params[])
{
	new id, text[35], sendername[MAX_PLAYER_NAME], name[MAX_PLAYER_NAME], string[128];
	if(sscanf(params,"uz", id, text)) return SCM(playerid, COLOR_GREY,"USAGE: /(w)hisper [playerid/partofname] [text]");
	if(!IsPlayerConnected(id)) return SCM(playerid, COLOR_GREY,"Invalid player ID");
	else
	{
	    new Float:x, Float:y, Float:z;
	    GetPlayerPos(id,x,y,z);
	    if(PlayerToPoint(5, playerid, x,y,z))
	    {
	        GetPlayerName(playerid, sendername,sizeof(sendername));
	        GetPlayerName(id, name, sizeof(name));
	        if(id == playerid)
	        {
	            format(string,sizeof(string),"%s mutters something", sendername);
	            ProxDetector(5.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			}
			else
			{
			    format(string,sizeof(string),"%s whispers something to %s", sendername, name);
			    ProxDetector(15.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			}
			format(string, sizeof(string), "%s whispers: %s", sendername, text);
			SendClientMessage(id, COLOR_YELLOW3, string);
			format(string, sizeof(string), "%s whispers: %s", sendername, text);
			SendClientMessage(playerid,  COLOR_YELLOW3, string);
		}
		else return SCM(playerid, COLOR_GREY,"That player is not near you");
	}
	return 1;
}
CMD:w(playerid, params[])
{
  return cmd_whisper(playerid, params);
}
CMD:helpme(playerid, params[])
{
	new string[128], sendername[MAX_PLAYER_NAME], name[MAX_PLAYER_NAME], id;
	if(isnull(params)) return SCM(playerid, COLOR_GREY,"USAGE:/helpme [description]");
	GetPlayerName(playerid,sendername,sizeof(sendername));
	GetPlayerName(id,name,sizeof(name));
	format(string,sizeof(string),"TesterCmd: %s has requested for help: %s", sendername, params);
	TBroadCast(COLOR_LIGHTBLUE,string,1);
	SendClientMessage(playerid, COLOR_LIGHTBLUE,"You have requested for help, please wait for a reply");
	return 1;
}
CMD:ad(playerid, params[])
{
	new string[128], sendername[MAX_PLAYER_NAME];
	if(isnull(params)) return SCM(playerid, COLOR_GREY,"USAGE:/ad [advertisement]");
	if(PlayerInfo[playerid][pMuted] == 1) return SendClientMessage(playerid, COLOR_RED, "You can't speak, you have been silenced");
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1738.7830, -1269.8062, 13.5433)) return SendClientMessage(playerid,COLOR_RED,"Your far than 50 metters from the Advertisment Building!");
	GetPlayerName(playerid, sendername, sizeof(sendername));
	format(string, sizeof(string), "[Advertisment]: %s, Contact %s ,Phone: %d",  params, sendername ,PlayerInfo[playerid][pNumber]);
	SendClientMessageToAll(COLOR_GREEN,string);
	GivePlayerCash(playerid, -50);
	SendClientMessage(playerid,COLOR_WHITE,"The advertisment costs 50$!");
	return 1;
}
CMD:pay(playerid, params[])
{
	new id, money, sendername[MAX_PLAYER_NAME], name[MAX_PLAYER_NAME], string[128];
	if(sscanf(params,"ui", id, money)) return SCM(playerid, COLOR_GREY,"USAGE:/pay [playerid/partofname] [ammount]");
	if(money < 1 || money > 100000) return SendClientMessage(playerid, COLOR_GRAD1, "You can't pay less than 1$ or more than 100k $.");
	if(!ProxDetectorS(5.0, playerid, id)) return SCM(playerid, COLOR_GRAD1,"You are too far away from that player");
	else
	{
 		GetPlayerName(id, name, sizeof(name));
		GetPlayerName(playerid, sendername, sizeof(sendername));
		new pmoney = GetPlayerMoney(playerid);
		if (money > 0 && pmoney >= money)
		{
			GivePlayerCash(playerid, (0 - money));
			GivePlayerCash(id, money);
			format(string, sizeof(string), "You payed %s(ID: %d) $%d.", name,id, money);
			SendClientMessage(playerid, COLOR_GREEN, string);
			format(string, sizeof(string), "You recieved $%d from %s(ID: %d).", money, sendername, playerid);
			SendClientMessage(id, COLOR_GREEN, string);
			format(string, sizeof(string), "[AdminCMD]: %s payed $%d to %s.", sendername, money, name);
			if(money >= 70000)
			{
				ABroadCast(COLOR_RED,string,1);
			}
			format(string, sizeof(string), "* %s takes out %d$ from his pocket and hands it to %s.", sendername , money ,name);
			ProxDetector(30.0, playerid, string, COLOR_RED,COLOR_RED,COLOR_RED,COLOR_RED,COLOR_RED);
			ApplyAnimation(playerid,"DEALER","shop_pay",4.1,0,0,0,0,0);
		}
	}
	return 1;
}
CMD:givemoney(playerid, params[])
{
	new id, cash, sendername[MAX_PLAYER_NAME], name[MAX_PLAYER_NAME], string[128];
	if(PlayerInfo[playerid][pAdmin] < 1337) return SCM(playerid, COLOR_GREY,"You are not authorized to use this command");
	if(sscanf(params,"ui", id, cash)) return SCM(playerid, COLOR_GREY,"USAGE: /givemoney [playerid/partofname] [ammount]");
	if(!IsPlayerConnected(id)) return SCM(playerid, COLOR_GREY,"Invalid player ID");
	else
	{
	    GivePlayerCash(id, cash);
		GetPlayerName(playerid,sendername,sizeof(sendername));
		GetPlayerName(id,name,sizeof(name));
		format(string,sizeof(string),"%s has given %s money to %d", sendername, name, cash);
		ABroadCast(COLOR_YELLOW,string,1);
		format(string,sizeof(string),"You have recieved %d money from admin %s", cash, sendername);
		SendClientMessage(id, COLOR_YELLOW, string);
	}
	return 1;
}
CMD:call(playerid, params[])
{
	new number, sendername[MAX_PLAYER_NAME], string[128];
	if(sscanf(params,"i", number))
	{
 		SendClientMessage(playerid, COLOR_GREEN, "____________Services number list____________");
 		SendClientMessage(playerid, COLOR_GREEN, "/call [number]");
   		SendClientMessage(playerid, COLOR_WHITE, "[Emergency]911 - Emergency Line || 103 - L.S-E.M.S");
   		SendClientMessage(playerid, COLOR_WHITE, "[Services]445 - Taxi Company || 235 - Mechanic");
   		SendClientMessage(playerid, COLOR_GREEN, "____________________________________________");
   		return 1;
   	}
   	if(number == PlayerInfo[playerid][pNumber]) return SCM(playerid, COLOR_GREY,"Can't call yourself");
   	if(Mobile[playerid] != 255) return SCM(playerid, COLOR_GREY,"Already in a call");
   	GetPlayerName(playerid,sendername,sizeof(sendername));
   	format(string, sizeof(string), "* %s takes his cellphone out.", sendername);
   	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
   	ProxDetector(30.0, playerid, string, COLOR_CHAT1,COLOR_CHAT2,COLOR_CHAT3,COLOR_CHAT4,COLOR_CHAT5);
   	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pNumber] == number && number != 0)
			{
 				new giveplayerid;
				giveplayerid = i;
				Mobile[playerid] = giveplayerid;
				if(IsPlayerConnected(giveplayerid))
				{
					if(giveplayerid != INVALID_PLAYER_ID)
 					{
						if (Mobile[giveplayerid] == 255)
						{
							format(string, sizeof(string), "[Mobile] Your mobile phone is ringing (/pickup) Caller: %d", PlayerInfo[playerid][pNumber]);
							SendClientMessage(giveplayerid, COLOR_YELLOW, string);
							GetPlayerName(giveplayerid, sendername, sizeof(sendername));
							RingTone[giveplayerid] = 10;
							format(string, sizeof(string), "* %s's phone is ringing.", sendername);
							ProxDetector(30.0, i, string, COLOR_CHAT1,COLOR_CHAT2,COLOR_CHAT3,COLOR_CHAT4,COLOR_CHAT5);
							CellTime[playerid] = 1;
							return 1;
						}
					}
				}
			}
		}
	}
	return 1;
   		
}
CMD:c(playerid, params[])
{
  return cmd_call(playerid, params);
}
CMD:pickup(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
		if(Mobile[playerid] != 255)
		{
			SendClientMessage(playerid, COLOR_GREY, "You are already on a call...");
			return 1;
		}
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				if(Mobile[i] == playerid)
				{
					Mobile[playerid] = i;
					new string[128], sendername[MAX_PLAYER_NAME];
					GetPlayerName(playerid,sendername,sizeof(sendername));
					SendClientMessage(i, COLOR_YELLOW2, "They Picked up the call...");
					format(string, sizeof(string), "* %s answers his cellphone.", sendername);
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
					ProxDetector(30.0, playerid, string, COLOR_CHAT1,COLOR_CHAT2,COLOR_CHAT3,COLOR_CHAT4,COLOR_CHAT5);
					RingTone[playerid] = 0;
				}

			}
		}
	}
	return 1;
}
CMD:p(playerid, params[])
{
  return cmd_pickup(playerid, params);
}
CMD:hangup(playerid, params[])
{
    if(IsPlayerConnected(playerid))
	{
		new caller = Mobile[playerid];
		if(IsPlayerConnected(caller))
		{
			if(caller != INVALID_PLAYER_ID)
			{
				if(caller != 255)
				{
					if(caller < 255)
					{
						SendClientMessage(caller,  COLOR_GREY, "They hung up...");
						CellTime[caller] = 0;
						CellTime[playerid] = 0;
						SendClientMessage(playerid,  COLOR_GREY, "You hung up....");
						Mobile[caller] = 255;
					}
				}
			}
		}
		new string[128];
		GivePlayerCash(playerid,-CellTime[playerid]);
		format(string,sizeof(string),"You have paid %d $ for your conversation!",CellTime[playerid]);
		GameTextForPlayer(playerid,string,5000,1);
		Mobile[playerid] = 255;
		CellTime[playerid] = 0;
		RingTone[playerid] = 0;
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
	}
	return 1;
}
CMD:h(playerid, params[])
{
  return cmd_hangup(playerid, params);
}
CMD:number(playerid, params[])
{
	new id, sendername[MAX_PLAYER_NAME], string[128];
	if(sscanf(params,"u", id)) return SCM(playerid, COLOR_GREY,"USAGE: /number [playerid/partofname]");
	if(!IsPlayerConnected(id)) return SCM(playerid, COLOR_GREY,"Invalid player ID");
	else
	{
	    GetPlayerName(id, sendername, sizeof(sendername));
		format(string, 256, "Name: %s, Ph: %d",sendername,PlayerInfo[id][pNumber]);
		SendClientMessage(playerid, COLOR_GRAD1, string);
	}
	return 1;
}
CMD:stopanim(playerid, params[])
{
	ClearAnimations(playerid);
	ApplyAnimation(playerid, "CARRY", "crry_prtial", 1.0, 0, 0, 0, 0, 0);
    TogglePlayerControllable(playerid, 1);
	return 1;
}
CMD:newspaper(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 4,1707.8434,-2331.6506,-2.6797)) return SCM(playerid, COLOR_GREY,"You are not near the news paper");
	else
	{
	    SetPlayerPos(playerid,1708.1606,-2333.2563,-2.3670);
	    SetPlayerFacingAngle(playerid, 353.5373);
    	TogglePlayerControllable(playerid, 0);
    	LoopingAnim(playerid,"BEACH", "bather", 4.0, 1, 0, 0, 0, 0); // Lay down
		ShowMenuForPlayer(Paper, playerid);
	}
	return 1;
}
CMD:exitcar(playerid, params[])
{
	if(IsPlayerInVehicle(playerid, dmvc) || IsPlayerInVehicle(playerid, dmvc1) || IsPlayerInVehicle(playerid,dmvc2))
	{
		RemovePlayerFromVehicle(playerid);
		TogglePlayerControllable(playerid, 1);
		SetTimer("Unfreeze", 1000, 1);
	}
	return 1;
}
CMD:takeexam(playerid, params[])
{
	if(PlayerInfo[playerid][pDriveLic] == 1) return SCM(playerid, COLOR_GREY,"You already have Driving License!");
	if(IsPlayerInVehicle(playerid, dmvc) || IsPlayerInVehicle(playerid, dmvc1) || IsPlayerInVehicle(playerid,dmvc2))
	{
	    TogglePlayerControllable(playerid, 1);
	    CP[playerid] = 200;
		SetPlayerCheckpoint(playerid, 1421.1475,-1699.3237,13.2888, 4.0);
		TakingLesson[playerid] = 1;
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "DMV: Please follow the checkpoints and drive safety!");
	}
	else return SCM(playerid, COLOR_GREY,"You are not in a DMV car");
	return 1;
}
CMD:freeze(playerid, params[])
{
	new id, sendername[MAX_PLAYER_NAME], name[MAX_PLAYER_NAME], string[128];
	if(PlayerInfo[playerid][pAdmin] < 1) return SCM(playerid,COLOR_GREY,"You are not authorized to use this command");
	if(sscanf(params,"u", id)) return SCM(playerid, COLOR_GREY,"USAGE: /freeze [playerid/partofname]");
	if(!IsPlayerConnected(id)) return SCM(playerid, COLOR_GREY,"Invalid player ID");
	else
	{
	    GetPlayerName(playerid,sendername,sizeof(sendername));
	    GetPlayerName(id,name,sizeof(name));
	    TogglePlayerControllable(id, 0);
	    format(string, sizeof(string), "AdmCmd: %s has freezed %s", sendername, name);
		ABroadCast(COLOR_YELLOW,string,1);
		format(string, sizeof(string),"You have been frozen by admin %s", sendername);
		SendClientMessage(id, COLOR_LIGHTRED, string);
	}
	return 1;
}
CMD:unfreeze(playerid, params[])
{
	new id, sendername[MAX_PLAYER_NAME], name[MAX_PLAYER_NAME], string[128];
	if(PlayerInfo[playerid][pAdmin] < 1) return SCM(playerid,COLOR_GREY,"You are not authorized to use this command");
	if(sscanf(params,"u", id)) return SCM(playerid, COLOR_GREY,"USAGE: /unfreeze [playerid/partofname]");
	if(!IsPlayerConnected(id)) return SCM(playerid, COLOR_GREY,"Invalid player ID");
	else
	{
	    GetPlayerName(playerid,sendername,sizeof(sendername));
	    GetPlayerName(id,name,sizeof(name));
	    TogglePlayerControllable(id, 1);
	    format(string, sizeof(string), "AdmCmd: %s has unfreezed %s", sendername, name);
		ABroadCast(COLOR_YELLOW,string,1);
		format(string, sizeof(string),"You have been unfreezed by admin %s", sendername);
		SendClientMessage(id, COLOR_LIGHTRED, string);
	}
	return 1;
}
CMD:check(playerid, params[])
{
	new id;
	if(PlayerInfo[playerid][pAdmin] < 1) return SCM(playerid,COLOR_GREY,"You are not authorized to use this command");
	if(sscanf(params,"u", id)) return SCM(playerid, COLOR_GREY,"USAGE: /check [playerid/partofname]");
	if(!IsPlayerConnected(id)) return SCM(playerid, COLOR_GREY,"Invalid player ID");
	else
	{
	    ShowStats(playerid, id);
	}
	return 1;
}
//===================================================DEALERSHIP=============================================================
CMD:tow(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_RED, "You are not driving a vehicle!");
	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsTrailerAttachedToVehicle(vehicleid))
	{
		DetachTrailerFromVehicle(vehicleid);
		SendClientMessage(playerid, COLOR_WHITE, "You are not towing anymore");
		return 1;
	}
	new Float:x, Float:y, Float:z;
	new Float:dist, Float:closedist=8, closeveh;
	for(new i=1; i < MAX_VEHICLES; i++)
	{
		if(i != vehicleid && GetVehiclePos(i, x, y, z))
		{
			dist = GetPlayerDistanceFromPoint(playerid, x, y, z);
			if(dist < closedist)
			{
				closedist = dist;
				closeveh = i;
			}
		}
	}
	if(!closeveh) return SendClientMessage(playerid, COLOR_RED, "You are not close to a vehicle!");
	AttachTrailerToVehicle(closeveh, vehicleid);
	SendClientMessage(playerid, COLOR_WHITE, "You are now towing a vehicle");
	return 1;
}

CMD:eject(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_RED, "You are not driving a vehicle!");
	new pid, msg[128];
	if(sscanf(params, "u", pid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /eject [player]");
	if(!IsPlayerConnected(pid)) return SendClientMessage(playerid, COLOR_RED, "Invalid player!");
	new vehicleid = GetPlayerVehicleID(playerid);
	if(!IsPlayerInVehicle(pid, vehicleid)) return SendClientMessage(playerid, COLOR_RED, "Player is not in your vehicle!");
	RemovePlayerFromVehicle(pid);
	format(msg, sizeof(msg), "Vehicle driver %s (%d) has ejected you", PlayerName(playerid), playerid);
	SendClientMessage(pid, COLOR_WHITE, msg);
	format(msg, sizeof(msg), "You have ejected %s (%d) from your vehicle", PlayerName(pid), pid);
	SendClientMessage(playerid, COLOR_WHITE, msg);
	return 1;
}

CMD:ejectall(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_RED, "You are not driving a vehicle!");
	new vehicleid = GetPlayerVehicleID(playerid);
	new msg[128];
	format(msg, sizeof(msg), "Vehicle driver %s (%d) has ejected you", PlayerName(playerid), playerid);
	for(new i=0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && i != playerid && IsPlayerInVehicle(i, vehicleid))
		{
			RemovePlayerFromVehicle(i);
			SendClientMessage(i, COLOR_WHITE, msg);
		}
	}
	SendClientMessage(playerid, COLOR_WHITE, "You have ejected all passengers");
	return 1;
}

CMD:clearmods(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_RED, "You are not driving a vehicle!");
	new vehicleid = GetPlayerVehicleID(playerid);
	new id = GetVehicleID(vehicleid);
	if(GetPlayerVehicleAccess(playerid, id) != 1)
		return SendClientMessage(playerid, COLOR_RED, "This is not your vehicle vehicle!");
	for(new i=0; i < sizeof(VehicleMods[]); i++)
	{
		RemoveVehicleComponent(VehicleID[id], GetVehicleComponentInSlot(VehicleID[id], i));
		VehicleMods[id][i] = 0;
	}
	VehiclePaintjob[id] = 255;
	ChangeVehiclePaintjob(VehicleID[id], 255);
	SaveVehicle(id);
	SendClientMessage(playerid, COLOR_WHITE, "You have removed all modifications from your vehicle");
	return 1;
}

CMD:trackcar(playerid, params[])
{
	if(TrackCar[playerid])
	{
		TrackCar[playerid] = 0;
		DisablePlayerCheckpoint(playerid);
		SendClientMessage(playerid, COLOR_WHITE, "You are not tracking your vehicle anymore");
		return 1;
	}
	new info[256], bool:found;
	for(new i=1; i < MAX_DVEHICLES; i++)
	{
		if(VehicleCreated[i] == VEHICLE_PLAYER && strcmp(VehicleOwner[i], PlayerName(playerid)) == 0)
		{
			found = true;
			format(info, sizeof(info), "%sID: %d  Name: %s\n", info, i, VehicleNames[VehicleModel[i]-400]);
		}
	}
	if(!found) return SendClientMessage(playerid, COLOR_RED, "You don't have any vehicles!");
	ShowPlayerDialog(playerid, DIALOG_FINDVEHICLE, DIALOG_STYLE_LIST, "Find Your Vehicle", info, "Find", "Cancel");
	return 1;
}

CMD:v(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_RED, "You are not driving a vehicle!");
	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsBicycle(vehicleid)) return SendClientMessage(playerid, COLOR_RED, "You are not driving a vehicle!");
	new id = GetVehicleID(vehicleid);
	if(!GetPlayerVehicleAccess(playerid, id))
		return SendClientMessage(playerid, COLOR_RED, "You don't have the keys for this vehicle!");
	SetPVarInt(playerid, "DialogValue1", id);
	ShowDialog(playerid, DIALOG_VEHICLE);
	return 1;
}

CMD:sellv(playerid, params[])
{
	new pid, id, price, msg[128];
	if(sscanf(params, "udd", pid, id, price)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /sellv [player] [vehicleid] [price]");
	if(!IsPlayerConnected(pid)) return SendClientMessage(playerid, COLOR_RED, "Invalid player!");
	if(GetPlayerVehicleAccess(playerid, id) != 1)
		return SendClientMessage(playerid, COLOR_RED, "You are not the owner of this vehicle!");
	if(price < 1) return SendClientMessage(playerid, COLOR_RED, "Invalid price!");
	if(!PlayerToPlayer(playerid, pid, 10.0)) return SendClientMessage(playerid, COLOR_RED, "Player is too far!");
	SetPVarInt(pid, "DialogValue1", playerid);
	SetPVarInt(pid, "DialogValue2", id);
	SetPVarInt(pid, "DialogValue3", price);
	ShowDialog(pid, DIALOG_VEHICLE_SELL);
	format(msg, sizeof(msg), "You have offered %s (%d) to buy your vehicle for $%d", PlayerName(pid), pid, price);
	SendClientMessage(playerid, COLOR_WHITE, msg);
	return 1;
}

CMD:givecarkeys(playerid, params[])
{
	new pid, id, msg[128];
	if(sscanf(params, "ud", pid, id)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /givecarkeys [player] [vehicleid]");
	if(!IsPlayerConnected(pid)) return SendClientMessage(playerid, COLOR_RED, "Invalid player!");
	if(!IsValidVehicle(id)) return SendClientMessage(playerid, COLOR_RED, "Invalid vehicleid!");
	if(GetPlayerVehicleAccess(playerid, id) != 1)
		return SendClientMessage(playerid, COLOR_RED, "You are not the owner of this vehicle!");
	if(!PlayerToPlayer(playerid, pid, 10.0)) return SendClientMessage(playerid, COLOR_RED, "Player is too far!");
	SetPVarInt(pid, "CarKeys", id);
	format(msg, sizeof(msg), "You have given your car keys to %s (%d)", PlayerName(pid), pid);
	SendClientMessage(playerid, COLOR_WHITE, msg);
	format(msg, sizeof(msg), "%s (%d) has given you car keys", PlayerName(playerid), playerid);
	SendClientMessage(pid, COLOR_WHITE, msg);
	return 1;
}

CMD:vlock(playerid, params[])
{
	new vehicleid;
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		vehicleid = GetPlayerVehicleID(playerid);
	}
	else
	{
		vehicleid = GetClosestVehicle(playerid);
		if(!PlayerToVehicle(playerid, vehicleid, 5.0)) vehicleid = 0;
	}
	if(!vehicleid) return SendClientMessage(playerid, COLOR_RED, "You are not close to a vehicle!");
	new id = GetVehicleID(vehicleid);
	if(!IsValidVehicle(id)) return SendClientMessage(playerid, COLOR_RED, "You don't have the keys for this vehicle!");
	if(!GetPlayerVehicleAccess(playerid, id))
		return SendClientMessage(playerid, COLOR_RED, "You don't have the keys for this vehicle!");
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	if(doors == 1)
	{
		doors = 0;
		GameTextForPlayer(playerid, "~g~doors unlocked", 3000, 6);
	}
	else
	{
		doors = 1;
		GameTextForPlayer(playerid, "~r~doors locked", 3000, 6);
	}
	SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return 1;
}

CMD:valarm(playerid, params[])
{
	new vehicleid;
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		vehicleid = GetPlayerVehicleID(playerid);
	}
	else
	{
		vehicleid = GetClosestVehicle(playerid);
		if(!PlayerToVehicle(playerid, vehicleid, 5.0)) vehicleid = 0;
	}
	if(!vehicleid) return SendClientMessage(playerid, COLOR_RED, "You are not close to a vehicle!");
	new id = GetVehicleID(vehicleid);
	if(!IsValidVehicle(id)) return SendClientMessage(playerid, COLOR_RED, "You don't have the keys for this vehicle!");
	if(GetPlayerVehicleAccess(playerid, id) != 1)
		return SendClientMessage(playerid, COLOR_RED, "You don't have the keys for this vehicle!");
	if(VehicleSecurity[vehicleid] == 0)
	{
		VehicleSecurity[vehicleid] = 1;
		GameTextForPlayer(playerid, "~g~alarm on", 3000, 6);
	}
	else
	{
		ToggleAlarm(vehicleid, VEHICLE_PARAMS_OFF);
		VehicleSecurity[vehicleid] = 0;
		GameTextForPlayer(playerid, "~r~alarm off", 3000, 6);
	}
	return 1;
}

CMD:trunk(playerid, params[])
{
	new vehicleid;
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		vehicleid = GetPlayerVehicleID(playerid);
	}
	else
	{
		vehicleid = GetClosestVehicle(playerid);
		if(!PlayerToVehicle(playerid, vehicleid, 5.0)) vehicleid = 0;
	}
	if(!vehicleid)
		return SendClientMessage(playerid, COLOR_RED, "You are not close to a vehicle!");
	new id = GetVehicleID(vehicleid);
	if(!IsValidVehicle(id)) return SendClientMessage(playerid, COLOR_RED, "You don't have the keys for this vehicle!");
	if(!GetPlayerVehicleAccess(playerid, id))
		return SendClientMessage(playerid, COLOR_RED, "You don't have the keys for this vehicle!");
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, 1, objective);
	SetPVarInt(playerid, "DialogValue1", id);
	ShowDialog(playerid, DIALOG_TRUNK);
	return 1;
}

CMD:fuel(playerid, params[])
{
	for(new i=1; i < MAX_FUEL_STATIONS; i++)
	{
		if(FuelStationCreated[i])
		{
			if(IsPlayerInRangeOfPoint(playerid, 15.0, FuelStationPos[i][0], FuelStationPos[i][1], FuelStationPos[i][2]))
			{
				SetPVarInt(playerid, "FuelStation", i);
				ShowDialog(playerid, DIALOG_FUEL);
				return 1;
			}
		}
	}
	SendClientMessage(playerid, COLOR_RED, "You are not in a fuel station!");
	return 1;
}

CMD:setfuel(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1338) return SendClientMessage(playerid, COLOR_RED, "You are not admin!");
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_RED, "You are not in a vehicle!");
	new amount, msg[128];
	if(sscanf(params, "d", amount)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /setfuel [amount]");
	if(amount < 0 || amount > 100) return SendClientMessage(playerid, COLOR_RED, "Invalid amount! (0-100)");
	Fuel[GetPlayerVehicleID(playerid)] = amount;
	format(msg, sizeof(msg), "You have set your vehicle fuel to %d", amount);
	SendClientMessage(playerid, COLOR_WHITE, msg);
	return 1;
}

CMD:addv(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1338) return SendClientMessage(playerid, COLOR_RED, "You are not admin!");
	if(!IsPlayerSpawned(playerid)) return SendClientMessage(playerid, COLOR_RED, "You can't use this command now!");
	new model[32], modelid, dealerid, color1, color2, price;
	if(sscanf(params, "dsddd", dealerid, model, color1, color2, price))
		return SendClientMessage(playerid, COLOR_GREY, "USAGE: /addv [dealerid] [model] [color1] [color2] [price]");
	if(!IsValidDealership(dealerid)) return SendClientMessage(playerid, COLOR_RED, "Invalid dealerid!");
	if(IsNumeric(model)) modelid = strval(model);
	else modelid = GetVehicleModelIDFromName(model);
	if(modelid < 400 || modelid > 611) return SendClientMessage(playerid, COLOR_RED, "Invalid model ID!");
	if(color1 < 0 || color2 < 0) return SendClientMessage(playerid, COLOR_RED, "Invalid color!");
	if(price < 0) return SendClientMessage(playerid, COLOR_RED, "Invalid price!");
	new Float:X, Float:Y, Float:Z, Float:angle;
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, angle);
	X += floatmul(floatsin(-angle, degrees), 4.0);
	Y += floatmul(floatcos(-angle, degrees), 4.0);
	for(new i=1; i < MAX_DVEHICLES; i++)
	{
		if(!VehicleCreated[i])
		{
			new msg[128];
			VehicleCreated[i] = VEHICLE_DEALERSHIP;
			VehicleModel[i] = modelid;
			VehiclePos[i][0] = X;
			VehiclePos[i][1] = Y;
			VehiclePos[i][2] = Z;
			VehiclePos[i][3] = angle+90.0;
			VehicleColor[i][0] = color1;
			VehicleColor[i][1] = color2;
			VehicleInterior[i] = GetPlayerInterior(playerid);
			VehicleWorld[i] = GetPlayerVirtualWorld(playerid);
			VehicleValue[i] = price;
			valstr(VehicleOwner[i], dealerid);
			VehicleNumberPlate[i] = DEFAULT_NUMBER_PLATE;
			for(new d=0; d < sizeof(VehicleTrunk[]); d++)
			{
				VehicleTrunk[i][d][0] = 0;
				VehicleTrunk[i][d][1] = 0;
			}
			for(new d=0; d < sizeof(VehicleMods[]); d++)
			{
				VehicleMods[i][d] = 0;
			}
			VehiclePaintjob[i] = 255;
			UpdateVehicle(i, 0);
			SaveVehicle(i);
			format(msg, sizeof(msg), "Added vehicle id %d to dealerid %d", i, dealerid);
			SendClientMessage(playerid, COLOR_WHITE, msg);
			return 1;
		}
	}
	SendClientMessage(playerid, COLOR_RED, "Can't add any more vehicles!");
	return 1;
}

CMD:editv(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1338) return SendClientMessage(playerid, COLOR_RED, "You are not admin!");
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new id = GetVehicleID(GetPlayerVehicleID(playerid));
		if(!IsValidVehicle(id)) return SendClientMessage(playerid, COLOR_RED, "This is not a dynamic vehicle!");
		SetPVarInt(playerid, "DialogValue1", id);
		ShowDialog(playerid, DIALOG_EDITVEHICLE);
		return 1;
	}
	new vehicleid;
	if(sscanf(params, "d", vehicleid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /editv [vehicleid]");
	if(!IsValidVehicle(vehicleid)) return SendClientMessage(playerid, COLOR_RED, "Invalid vehicleid!");
	SetPVarInt(playerid, "DialogValue1", vehicleid);
	ShowDialog(playerid, DIALOG_EDITVEHICLE);
	return 1;
}

CMD:adddealership(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1338) return SendClientMessage(playerid, COLOR_RED, "You are not admin!");
	if(!IsPlayerSpawned(playerid)) return SendClientMessage(playerid, COLOR_RED, "You can't use this command now!");
	for(new i=1; i < MAX_DEALERSHIPS; i++)
	{
		if(!DealershipCreated[i])
		{
			new msg[128];
			DealershipCreated[i] = 1;
			GetPlayerPos(playerid, DealershipPos[i][0], DealershipPos[i][1], DealershipPos[i][2]);
			UpdateDealership(i, 0);
			SaveDealership(i);
			format(msg, sizeof(msg), "Added dealership id %d", i);
			SendClientMessage(playerid, COLOR_WHITE, msg);
			return 1;
		}
	}
	SendClientMessage(playerid, COLOR_RED, "Can't add any more dealerships!");
	return 1;
}

CMD:deletedealership(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1338) return SendClientMessage(playerid, COLOR_RED, "You are not admin!");
	new dealerid, msg[128];
	if(sscanf(params, "d", dealerid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /deletedealership [dealerid]");
	if(!IsValidDealership(dealerid)) return SendClientMessage(playerid, COLOR_RED, "Invalid dealerid!");
	for(new i=1; i < MAX_DVEHICLES; i++)
	{
		if(VehicleCreated[i] == VEHICLE_DEALERSHIP && strval(VehicleOwner[i]) == dealerid)
		{
			DestroyVehicle(VehicleID[i]);
			Delete3DTextLabel(VehicleLabel[i]);
			VehicleCreated[i] = 0;
		}
	}
	DealershipCreated[dealerid] = 0;
	Delete3DTextLabel(DealershipLabel[dealerid]);
	SaveDealership(dealerid);
	format(msg, sizeof(msg), "Deleted dealership id %d", dealerid);
	SendClientMessage(playerid, COLOR_WHITE, msg);
	return 1;
}

CMD:movedealership(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1338) return SendClientMessage(playerid, COLOR_RED, "You are not admin!");
	new dealerid, msg[128];
	if(sscanf(params, "d", dealerid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /movedealership [dealerid]");
	if(!IsValidDealership(dealerid)) return SendClientMessage(playerid, COLOR_RED, "Invalid dealerid!");
	GetPlayerPos(playerid, DealershipPos[dealerid][0], DealershipPos[dealerid][1], DealershipPos[dealerid][2]);
	UpdateDealership(dealerid, 1);
	SaveDealership(dealerid);
	format(msg, sizeof(msg), "Moved dealership id %d here", dealerid);
	SendClientMessage(playerid, COLOR_WHITE, msg);
	return 1;
}

CMD:gotodealership(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1338) return SendClientMessage(playerid, COLOR_RED, "You are not admin!");
	new dealerid, msg[128];
	if(sscanf(params, "d", dealerid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /gotodealership [dealerid]");
	if(!IsValidDealership(dealerid)) return SendClientMessage(playerid, COLOR_RED, "Invalid dealerid!");
	SetPlayerPos(playerid, DealershipPos[dealerid][0], DealershipPos[dealerid][1], DealershipPos[dealerid][2]);
	format(msg, sizeof(msg), "Teleported to dealership id %d", dealerid);
	SendClientMessage(playerid, COLOR_WHITE, msg);
	return 1;
}

CMD:addfuelstation(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1338) return SendClientMessage(playerid, COLOR_RED, "You are not admin!");
	if(!IsPlayerSpawned(playerid)) return SendClientMessage(playerid, COLOR_RED, "You can't use this command now!");
	for(new i=1; i < MAX_FUEL_STATIONS; i++)
	{
		if(!FuelStationCreated[i])
		{
			new msg[128];
			FuelStationCreated[i] = 1;
			GetPlayerPos(playerid, FuelStationPos[i][0], FuelStationPos[i][1], FuelStationPos[i][2]);
			UpdateFuelStation(i, 0);
			SaveFuelStation(i);
			format(msg, sizeof(msg), "Added fuel station id %d", i);
			SendClientMessage(playerid, COLOR_WHITE, msg);
			return 1;
		}
	}
	SendClientMessage(playerid, COLOR_RED, "Can't add any more fuel stations!");
	return 1;
}

CMD:deletefuelstation(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1338) return SendClientMessage(playerid, COLOR_RED, "You are not admin!");
	new stationid, msg[128];
	if(sscanf(params, "d", stationid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /deletefuelstation [stationid]");
	if(!IsValidFuelStation(stationid)) return SendClientMessage(playerid, COLOR_RED, "Invalid stationid!");
	FuelStationCreated[stationid] = 0;
	Delete3DTextLabel(FuelStationLabel[stationid]);
	SaveFuelStation(stationid);
	format(msg, sizeof(msg), "Deleted fuel station id %d", stationid);
	SendClientMessage(playerid, COLOR_WHITE, msg);
	return 1;
}

CMD:movefuelstation(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1338) return SendClientMessage(playerid, COLOR_RED, "You are not admin!");
	new stationid, msg[128];
	if(sscanf(params, "d", stationid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /movefuelstation [stationid]");
	if(!IsValidFuelStation(stationid)) return SendClientMessage(playerid, COLOR_RED, "Invalid stationid!");
	GetPlayerPos(playerid, FuelStationPos[stationid][0], FuelStationPos[stationid][1], FuelStationPos[stationid][2]);
	UpdateFuelStation(stationid, 1);
	SaveFuelStation(stationid);
	format(msg, sizeof(msg), "Moved fuel station id %d here", stationid);
	SendClientMessage(playerid, COLOR_WHITE, msg);
	return 1;
}

CMD:gotofuelstation(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1338) return SendClientMessage(playerid, COLOR_RED, "You are not admin!");
	new stationid, msg[128];
	if(sscanf(params, "d", stationid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /gotofuelstation [stationid]");
	if(!IsValidFuelStation(stationid)) return SendClientMessage(playerid, COLOR_RED, "Invalid stationid!");
	SetPlayerPos(playerid, FuelStationPos[stationid][0], FuelStationPos[stationid][1], FuelStationPos[stationid][2]);
	format(msg, sizeof(msg), "Teleported to fuel station id %d", stationid);
	SendClientMessage(playerid, COLOR_WHITE, msg);
	return 1;
}
CMD:anims(playerid, params[])
	{
	    SendClientMessage(playerid,COLOR_GRAD2," ____________Character Animations____________");
	    SendClientMessage(playerid,COLOR_GRAD2,"[Sit/Lay] /sit /seat /lay /sleep /lean /lean2");
        SendClientMessage(playerid,COLOR_GRAD2,"[Signs] /gsign1 /gsign2 /gsign4 /gsign5 /gsign7");
        SendClientMessage(playerid,COLOR_GRAD2,"[Communication] /greet1 /greet2 /greet3 ");
        SendClientMessage(playerid,COLOR_GRAD2,"[Communication] /fuckyou /wave /argue /kiss");
        SendClientMessage(playerid,COLOR_GRAD2,"[Physical Actions] /bat /bat2 /punch /aim /slapass");
        SendClientMessage(playerid,COLOR_GRAD2,"[Physical Actions] /taxiL /flip /crack");
        SendClientMessage(playerid,COLOR_GRAD2,"[Emotions] /injured");
        SendClientMessage(playerid,COLOR_GRAD2,"_____________________________________________");
		return true;
	}
//================================ANIMATIONS====================================
CMD:taxiL(playerid, params[])
	{
		 LoopingAnim(playerid,"PED","IDLE_taxi",4.0,0,1,1,1,0);
         return 1;
    }
CMD:punch(playerid, params[])
	{
		 LoopingAnim(playerid,"MD_CHASE","MD_BIKE_Punch",4.0,0,1,1,1,0);
         return 1;
    }
CMD:greet1(playerid, params[])
	{
		 LoopingAnim(playerid,"WUZI","Wuzi_Greet_Plyr",4.0,0,1,1,1,0);
         return 1;
    }
CMD:greet2(playerid, params[])
	{
		 LoopingAnim(playerid,"WUZI","Wuzi_Greet_Wuzi",4.0,0,1,1,1,0);
         return 1;
    }
CMD:wave(playerid, params[])
	{
		 LoopingAnim(playerid,"BD_FIRE ","BD_GF_Wave",4.0,0,1,1,1,0);
         return 1;
    }
CMD:argue(playerid, params[])
	{
		 LoopingAnim(playerid,"PAULNMAC","PnM_Argue1_A",4.0,0,1,1,1,0);
         return 1;
    }
CMD:sleep(playerid, params[])
	{
		 LoopingAnim(playerid,"INT_HOUSE","BED_In_L",4.0,0,1,1,1,0);
         return 1;
    }
CMD:lean2(playerid, params[])
	{
		 LoopingAnim(playerid,"RYDER","Van_Lean_L",4.0,0,1,1,1,0);
         return 1;
    }

CMD:gsign1(playerid, params[])
	{
		 LoopingAnim(playerid,"GHANDS","gsign1",4.0,0,1,1,1,0);
         return 1;
    }
CMD:gsign2(playerid, params[])
	{
		 LoopingAnim(playerid,"GHANDS","gsign1LH",4.0,0,1,1,1,0);
         return 1;
    }
CMD:gsign3(playerid, params[])
	{
		 LoopingAnim(playerid,"GHANDS","gsign2",4.0,0,1,1,1,0);
         return 1;
    }
CMD:gsign4(playerid, params[])
	{
		 LoopingAnim(playerid,"GHANDS","gsign2LH",4.0,0,1,1,1,0);
         return 1;
    }
CMD:gsign5(playerid, params[])
	{
		 LoopingAnim(playerid,"GHANDS","gsign3",4.0,0,1,1,1,0);
         return 1;
    }
CMD:gsign6(playerid, params[])
	{
		 LoopingAnim(playerid,"GHANDS","gsign3LH",4.0,0,1,1,1,0);
         return 1;
    }
CMD:gsign7(playerid, params[])
	{
		 LoopingAnim(playerid,"GHANDS","gsign4",4.0,0,1,1,1,0);
         return 1;
    }



CMD:carjacked1(playerid, params[])
{
		 LoopingAnim(playerid,"PED","CAR_jackedLHS",4.0,0,1,1,1,0);
         return 1;
    }



CMD:carjacked2(playerid, params[])
{
		 LoopingAnim(playerid,"PED","CAR_jackedRHS",4.0,0,1,1,1,0);
         return 1;
    }



CMD:handsup(playerid, params[])
{
		LoopingAnim(playerid, "ROB_BANK","SHP_HandsUp_Scr", 4.0, 0, 1, 1, 1, 0);
        return 1;
    }



CMD:cellin(playerid, params[])
{
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USECELLPHONE);
        return 1;
    }



CMD:cellout(playerid, params[])
{
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_STOPUSECELLPHONE);
        return 1;
    }



CMD:drunk(playerid, params[])
{
		LoopingAnim(playerid,"PED","WALK_DRUNK",4.1,1,1,1,1,1);
		return 1;
    }



CMD:bomb(playerid, params[])
{
		ClearAnimations(playerid);
		LoopingAnim(playerid, "BOMBER","BOM_Plant_Loop",4.0,1,0,0,1,0); // Place Bomb
		return 1;
	}


CMD:getarrested(playerid, params[])
{
	      LoopingAnim(playerid,"ped", "ARRESTgun", 4.0, 0, 1, 1, 1, -1); // Gun Arrest
		  return 1;
    }


CMD:laugh(playerid, params[])
{
          OnePlayAnim(playerid, "RAPPING", "Laugh_01", 4.0, 0, 0, 0, 0, 0); // Laugh
		  return 1;
	}


CMD:lookout(playerid, params[])
{
          OnePlayAnim(playerid, "SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0); // Rob Lookout
		  return 1;
	}


CMD:robman(playerid, params[])
{
          LoopingAnim(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 1, 0, 0, 0, 0); // Rob
		  return 1;
	}


CMD:crossarms(playerid, params[])
{
          LoopingAnim(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1); // Arms crossed
		  return 1;
	}


CMD:lay(playerid, params[])
{
          LoopingAnim(playerid,"BEACH", "bather", 4.0, 1, 0, 0, 0, 0); // Lay down
		  return 1;
    }


CMD:hide(playerid, params[])
{
          LoopingAnim(playerid, "ped", "cower", 3.0, 1, 0, 0, 0, 0); // Taking Cover
		  return 1;
	}


CMD:vomit(playerid, params[])
{
	      OnePlayAnim(playerid, "FOOD", "EAT_Vomit_P", 3.0, 0, 0, 0, 0, 0); // Vomit BAH!
		  return 1;
	}


CMD:eat(playerid, params[])
{
	      OnePlayAnim(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0); // Eat Burger
		  return 1;
	}
	// Wave



CMD:slapass(playerid, params[])
{
   		OnePlayAnim(playerid, "SWEET", "sweet_ass_slap", 4.0, 0, 0, 0, 0, 0); // Ass Slapping
 		return 1;
	}


CMD:deal(playerid, params[])
{
          OnePlayAnim(playerid, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0); // Deal Drugs
		  return 1;
	}



CMD:crack(playerid, params[])
{
          LoopingAnim(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0); // Dieing of Crack
		  return 1;
	}

	// Sit
CMD:sit(playerid, params[])
{
          LoopingAnim(playerid,"BEACH", "ParkSit_M_loop", 4.0, 1, 0, 0, 0, 0); // Sit
		  return 1;
    }
    // Idle Chat
CMD:chat(playerid, params[])
{
		 LoopingAnim(playerid,"PED","IDLE_CHAT",4.0,1,0,0,1,1);
         return 1;
    }
    // Idle Chat2
CMD:chat2(playerid, params[])
{
		 LoopingAnim(playerid,"MISC","Idle_Chat_02",4.0,1,0,0,1,1);
         return 1;
    }
    // Fucku
CMD:fuckyou(playerid, params[])
{
		 OnePlayAnim(playerid,"PED","fucku",4.0,0,0,0,0,0);
         return 1;
    }
    // TaiChi
CMD:taichi(playerid, params[])
{
		 LoopingAnim(playerid,"PARK","Tai_Chi_Loop",4.0,1,0,0,0,0);
         return 1;
    }

    // ChairSit

    // Fall on the ground
CMD:flip(playerid, params[])
{
		 LoopingAnim(playerid,"PED","KO_skid_front",4.1,0,1,1,1,0);
         return 1;
    }

    // Fall
CMD:backflip(playerid, params[])
{
		 LoopingAnim(playerid, "PED","FLOOR_hit_f", 4.0, 1, 0, 0, 0, 0);
         return 1;
    }

    // kiss
CMD:kiss(playerid, params[])
{
		 LoopingAnim(playerid, "KISSING", "Playa_Kiss_02", 3.0, 1, 1, 1, 1, 0);
         return 1;
    }

    // Injujred
CMD:injured(playerid, params[])
{
		 LoopingAnim(playerid, "SWEET", "Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0);
         return 1;
    }


    // Violence animations
CMD:push(playerid, params[])
{
		 OnePlayAnim(playerid,"GANGS","shake_cara",4.0,0,0,0,0,0);
         return 1;
    }

CMD:akick(playerid, params[])
{
		 OnePlayAnim(playerid,"POLICE","Door_Kick",4.0,0,0,0,0,0);
         return 1;
    }

CMD:lowbodypush(playerid, params[])
{
		 OnePlayAnim(playerid,"GANGS","shake_carSH",4.0,0,0,0,0,0);
         return 1;
    }

    // Spray
CMD:spray(playerid, params[])
{
		 OnePlayAnim(playerid,"SPRAYCAN","spraycan_full",4.0,0,0,0,0,0);
         return 1;
    }

    // Headbutt
CMD:headbutt(playerid, params[])
{
		 OnePlayAnim(playerid,"WAYFARER","WF_Fwd",4.0,0,0,0,0,0);
         return 1;
    }

    // Medic
CMD:medic(playerid, params[])
{
		 OnePlayAnim(playerid,"MEDIC","CPR",4.0,0,0,0,0,0);
         return 1;
    }

    // KO Face
CMD:koface(playerid, params[])
{
		 LoopingAnim(playerid,"PED","KO_shot_face",4.0,0,1,1,1,0);
         return 1;
    }

    // KO Stomach
CMD:kostomach(playerid, params[])
{
		 LoopingAnim(playerid,"PED","KO_shot_stom",4.0,0,1,1,1,0);
         return 1;
    }

    // Jump for your life!
CMD:lifejump(playerid, params[])
{
		 LoopingAnim(playerid,"PED","EV_dive",4.0,0,1,1,1,0);
         return 1;
    }

    // Exhausted
CMD:exhaust(playerid, params[])
{
		 LoopingAnim(playerid,"PED","IDLE_tired",3.0,1,0,0,0,0);
         return 1;
    }

    // Left big slap
CMD:leftslap(playerid, params[])
{
		 OnePlayAnim(playerid,"PED","BIKE_elbowL",4.0,0,0,0,0,0);
         return 1;
    }

    // Big fall
CMD:rollfall(playerid, params[])
{
		 LoopingAnim(playerid,"PED","BIKE_fallR",4.0,0,1,1,1,0);
         return 1;
    }

    // Locked
CMD:carlock(playerid, params[])
{
		 OnePlayAnim(playerid,"PED","CAR_doorlocked_LHS",4.0,0,0,0,0,0);
         return 1;
    }

    // carjack
CMD:rcarjack1(playerid, params[])
{
		 OnePlayAnim(playerid,"PED","CAR_pulloutL_LHS",4.0,0,0,0,0,0);
         return 1;
    }

    // carjack
CMD:lcarjack1(playerid, params[])
{
		 OnePlayAnim(playerid,"PED","CAR_pulloutL_RHS",4.0,0,0,0,0,0);
         return 1;
    }

    // carjack
CMD:rcarjack2(playerid, params[])
{
		 OnePlayAnim(playerid,"PED","CAR_pullout_LHS",4.0,0,0,0,0,0);
         return 1;
    }

    // carjack
CMD:lcarjack2(playerid, params[])
{
		 OnePlayAnim(playerid,"PED","CAR_pullout_RHS",4.0,0,0,0,0,0);
         return 1;
    }

    // Hood frisked
CMD:hoodfrisked(playerid, params[])
{
		 LoopingAnim(playerid,"POLICE","crm_drgbst_01",4.0,0,1,1,1,0);
         return 1;
    }

    // Lighting cigarette
CMD:lightcig(playerid, params[])
{
		 OnePlayAnim(playerid,"SMOKING","M_smk_in",3.0,0,0,0,0,0);
         return 1;
    }

    // Tap cigarette
CMD:tapcig(playerid, params[])
{
		 OnePlayAnim(playerid,"SMOKING","M_smk_tap",3.0,0,0,0,0,0);
         return 1;
    }

    // Bat stance
CMD:bat(playerid, params[])
{
		 LoopingAnim(playerid,"BASEBALL","Bat_IDLE",4.0,1,1,1,1,0);
         return 1;
    }

    // Boxing
CMD:box(playerid, params[])
{
		 LoopingAnim(playerid,"GYMNASIUM","GYMshadowbox",4.0,1,1,1,1,0);
         return 1;
    }

    // Lay 2
CMD:lay2(playerid, params[])
{
		 LoopingAnim(playerid,"SUNBATHE","Lay_Bac_in",3.0,0,1,1,1,0);
         return 1;
    }



CMD:chant(playerid, params[])
{
		 LoopingAnim(playerid,"RIOT","RIOT_CHANT",4.0,1,1,1,1,0);
         return 1;
    }



CMD:fucku(playerid, params[])
{
		 OnePlayAnim(playerid,"RIOT","RIOT_FUKU",2.0,0,0,0,0,0);
         return 1;
    }



CMD:shouting(playerid, params[])
{
		 LoopingAnim(playerid,"RIOT","RIOT_shout",4.0,1,0,0,0,0);
         return 1;
    }



CMD:cop(playerid, params[])
{
		 OnePlayAnim(playerid,"SWORD","sword_block",50.0,0,1,1,1,1);
         return 1;
    }



CMD:elbow(playerid, params[])
{
		 OnePlayAnim(playerid,"FIGHT_D","FightD_3",4.0,0,1,1,0,0);
         return 1;
    }



CMD:kneekick(playerid, params[])
{
		 OnePlayAnim(playerid,"FIGHT_D","FightD_2",4.0,0,1,1,0,0);
         return 1;
    }



CMD:fstance(playerid, params[])
{
		 LoopingAnim(playerid,"FIGHT_D","FightD_IDLE",4.0,1,1,1,1,0);
		 return 1;
}
//==============================================================================
CMD:engine(playerid, params[])
{
        new vehicleid = GetPlayerVehicleID(playerid);
        if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_RED, "You need to be in a vehicle to use this command");
        if(vehEngine[vehicleid] == 0)
        {
            vehEngine[vehicleid] = 2;
            SetTimerEx("StartEngine", 3000, 0, "i", playerid);
            SendClientMessage(playerid, COLOR_GREEN, "Vehicle engine starting");
        }
        else if(vehEngine[vehicleid] == 1)
        {
            vehEngine[vehicleid] = 0;
            TogglePlayerControllable(playerid, 0);
            SendClientMessage(playerid, COLOR_GOLD, "Vehicle engine stopped");
            SendClientMessage(playerid, COLOR_GOLD, "To re-start the vehicle's engine press \"Shift\" or type \"/engine\"");
        }
        return 1;
}

//======================================================[STOCKS]========================================================================
stock IsVehicleOccupied(vehicleid)
{
	for(new i=0;i<MAX_PLAYERS;i++)
	{
		if(IsPlayerInVehicle(i,vehicleid)) return 1;
	}
	return 0;
}
//=====================================================[SERVERSIDE CASH FUNCTIONS=============================================
stock GivePlayerCash(playerid, money)
{
	PlayerInfo[playerid][pCash] += money;
	ResetMoneyBar(playerid);//Resets the money in the original moneybar, Do not remove!
	UpdateMoneyBar(playerid,PlayerInfo[playerid][pCash]);//Sets the money in the moneybar to the serverside cash, Do not remove!
	return PlayerInfo[playerid][pCash];
}
stock SetPlayerCash(playerid, money)
{
	PlayerInfo[playerid][pCash] = money;
	ResetMoneyBar(playerid);//Resets the money in the original moneybar, Do not remove!
	UpdateMoneyBar(playerid,PlayerInfo[playerid][pCash]);//Sets the money in the moneybar to the serverside cash, Do not remove!
	return PlayerInfo[playerid][pCash];
}
stock ResetPlayerCash(playerid)
{
	PlayerInfo[playerid][pCash] = 0;
	ResetMoneyBar(playerid);//Resets the money in the original moneybar, Do not remove!
	UpdateMoneyBar(playerid,PlayerInfo[playerid][pCash]);//Sets the money in the moneybar to the serverside cash, Do not remove!
	return PlayerInfo[playerid][pCash];
}
stock GetPlayerCash(playerid)
{
	return PlayerInfo[playerid][pCash];
}
//===============================================================================================================================

stock sscanf(string[], format[], {Float,_}:...)
{
	#if defined isnull
		if (isnull(string))
	#else
		if (string[0] == 0 || (string[0] == 1 && string[1] == 0))
	#endif
		{
			return format[0];
		}
	#pragma tabsize 4
	new
		formatPos = 0,
		stringPos = 0,
		paramPos = 2,
		paramCount = numargs(),
		delim = ' ';
	while (string[stringPos] && string[stringPos] <= ' ')
	{
		stringPos++;
	}
	while (paramPos < paramCount && string[stringPos])
	{
		switch (format[formatPos++])
		{
			case '\0':
			{
				return 0;
			}
			case 'i', 'd':
			{
				new
					neg = 1,
					num = 0,
					ch = string[stringPos];
				if (ch == '-')
				{
					neg = -1;
					ch = string[++stringPos];
				}
				do
				{
					stringPos++;
					if ('0' <= ch <= '9')
					{
						num = (num * 10) + (ch - '0');
					}
					else
					{
						return -1;
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num * neg);
			}
			case 'h', 'x':
			{
				new
					num = 0,
					ch = string[stringPos];
				do
				{
					stringPos++;
					switch (ch)
					{
						case 'x', 'X':
						{
							num = 0;
							continue;
						}
						case '0' .. '9':
						{
							num = (num << 4) | (ch - '0');
						}
						case 'a' .. 'f':
						{
							num = (num << 4) | (ch - ('a' - 10));
						}
						case 'A' .. 'F':
						{
							num = (num << 4) | (ch - ('A' - 10));
						}
						default:
						{
							return -1;
						}
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num);
			}
			case 'c':
			{
				setarg(paramPos, 0, string[stringPos++]);
			}
			case 'f':
			{

				new changestr[16], changepos = 0, strpos = stringPos;
				while(changepos < 16 && string[strpos] && string[strpos] != delim)
				{
					changestr[changepos++] = string[strpos++];
    				}
				changestr[changepos] = '\0';
				setarg(paramPos,0,_:floatstr(changestr));
			}
			case 'p':
			{
				delim = format[formatPos++];
				continue;
			}
			case '\'':
			{
				new
					end = formatPos - 1,
					ch;
				while ((ch = format[++end]) && ch != '\'') {}
				if (!ch)
				{
					return -1;
				}
				format[end] = '\0';
				if ((ch = strfind(string, format[formatPos], false, stringPos)) == -1)
				{
					if (format[end + 1])
					{
						return -1;
					}
					return 0;
				}
				format[end] = '\'';
				stringPos = ch + (end - formatPos);
				formatPos = end + 1;
			}
			case 'u':
			{
				new
					end = stringPos - 1,
					id = 0,
					bool:num = true,
					ch;
				while ((ch = string[++end]) && ch != delim)
				{
					if (num)
					{
						if ('0' <= ch <= '9')
						{
							id = (id * 10) + (ch - '0');
						}
						else
						{
							num = false;
						}
					}
				}
				if (num && IsPlayerConnected(id))
				{
					setarg(paramPos, 0, id);
				}
				else
				{
					#if !defined foreach
						#define foreach(%1,%2) for (new %2 = 0; %2 < MAX_PLAYERS; %2++) if (IsPlayerConnected(%2))
						#define __SSCANF_FOREACH__
					#endif
					string[end] = '\0';
					num = false;
					new
						name[MAX_PLAYER_NAME];
					id = end - stringPos;
					foreach (Player, playerid)
					{
						GetPlayerName(playerid, name, sizeof (name));
						if (!strcmp(name, string[stringPos], true, id))
						{
							setarg(paramPos, 0, playerid);
							num = true;
							break;
						}
					}
					if (!num)
					{
						setarg(paramPos, 0, INVALID_PLAYER_ID);
					}
					string[end] = ch;
					#if defined __SSCANF_FOREACH__
						#undef foreach
						#undef __SSCANF_FOREACH__
					#endif
				}
				stringPos = end;
			}
			case 's', 'z':
			{
				new
					i = 0,
					ch;
				if (format[formatPos])
				{
					while ((ch = string[stringPos++]) && ch != delim)
					{
						setarg(paramPos, i++, ch);
					}
					if (!i)
					{
						return -1;
					}
				}
				else
				{
					while ((ch = string[stringPos++]))
					{
						setarg(paramPos, i++, ch);
					}
				}
				stringPos--;
				setarg(paramPos, i, '\0');
			}
			default:
			{
				continue;
			}
		}
		while (string[stringPos] && string[stringPos] != delim && string[stringPos] > ' ')
		{
			stringPos++;
		}
		while (string[stringPos] && (string[stringPos] == delim || string[stringPos] <= ' '))
		{
			stringPos++;
		}
		paramPos++;
	}
	do
	{
		if ((delim = format[formatPos++]) > ' ')
		{
			if (delim == '\'')
			{
				while ((delim = format[formatPos++]) && delim != '\'') {}
			}
			else if (delim != 'z')
			{
				return delim;
			}
		}
	}
	while (delim > ' ');
	return 0;
}

stock strvalEx( const string[] ) // fix for strval-bug with > 50 letters.
{
	// written by mabako in less than a minute :X
	if( strlen( string ) >= 50 ) return 0; // It will just return 0 if the string is too long
	return strval(string);
}
stock IsValidName(playerid)
{
    if (IsPlayerConnected(playerid))
    {
        new player[24];
        GetPlayerName(playerid,player,24);
        for(new n = 0; n < strlen(player); n++)
        {
            if (player[n] == '_' && player[n+1] >= 'A' && player[n+1] <= 'Z') return 1;
            if (player[n] == ']' || player[n] == '[') return 0;
        }
    }
    return 0;
}
//=============================DEALERSHIP=======================================
stock PlayerName(playerid)
{
	new pName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
	return pName;
}

stock IsPlayerSpawned(playerid)
{
	switch(GetPlayerState(playerid))
	{
		case 1,2,3: return 1;
	}
	return 0;
}

stock IsMeleeWeapon(weaponid)
{
	switch(weaponid)
	{
		case 2 .. 15, 41 .. 42: return 1;
	}
	return 0;
}

stock RemovePlayerWeapon(playerid, weaponid)
{
	new WeaponData[12][2];
	for(new i=1; i < sizeof(WeaponData); i++)
	{
		GetPlayerWeaponData(playerid, i, WeaponData[i][0], WeaponData[i][1]);
	}
	ResetPlayerWeapons(playerid);
	for(new i=1; i < sizeof(WeaponData); i++)
	{
		if(WeaponData[i][0] != weaponid)
		{
			GivePlayerWeapon(playerid, WeaponData[i][0], WeaponData[i][1]);
		}
	}
}

stock IsBicycle(vehicleid)
{
	switch(GetVehicleModel(vehicleid))
	{
		case 481,509,510: return 1;
	}
	return 0;
}

stock PlayerToPlayer(playerid, targetid, Float:dist)
{
	new Float:pos[3];
	GetPlayerPos(targetid, pos[0], pos[1], pos[2]);
	return IsPlayerInRangeOfPoint(playerid, dist, pos[0], pos[1], pos[2]);
}

stock PlayerToVehicle(playerid, vehicleid, Float:dist)
{
	new Float:pos[3];
	GetVehiclePos(vehicleid, pos[0], pos[1], pos[2]);
	return IsPlayerInRangeOfPoint(playerid, dist, pos[0], pos[1], pos[2]);
}

stock GetClosestVehicle(playerid)
{
	new Float:x, Float:y, Float:z;
	new Float:dist, Float:closedist=9999, closeveh;
	for(new i=1; i < MAX_VEHICLES; i++)
	{
		if(GetVehiclePos(i, x, y, z))
		{
			dist = GetPlayerDistanceFromPoint(playerid, x, y, z);
			if(dist < closedist)
			{
				closedist = dist;
				closeveh = i;
			}
		}
	}
	return closeveh;
}

stock ToggleEngine(vehicleid, toggle)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, toggle, lights, alarm, doors, bonnet, boot, objective);
}

stock ToggleAlarm(vehicleid, toggle)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, engine, lights, toggle, doors, bonnet, boot, objective);
}

stock IsNumeric(const string[])
{
	for(new i=0; string[i]; i++)
	{
		if(string[i] < '0' || string[i] > '9') return 0;
	}
	return 1;
}

stock GetVehicleModelIDFromName(const vname[])
{
	for(new i=0; i < sizeof(VehicleNames); i++)
	{
		if(strfind(VehicleNames[i], vname, true) != -1) return i + 400;
	}
	return -1;
}

stock GetPlayer2DZone(playerid)
{
	new zone[32] = "San Andreas";
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
 	for(new i = 0; i < sizeof(SanAndreasZones); i++)
	{
		if(x >= SanAndreasZones[i][Zone_Area][0] && x <= SanAndreasZones[i][Zone_Area][3]
		&& y >= SanAndreasZones[i][Zone_Area][1] && y <= SanAndreasZones[i][Zone_Area][4])
		{
			strcpy(zone, sizeof(zone), SanAndreasZones[i][Zone_Name]);
			return zone;
		}
	}
	return zone;
}
stock GetPlayer3DZone(playerid)
{
	new zone[32] = "San Andreas";
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
 	for(new i = 0; i < sizeof(SanAndreasZones); i++)
	{
		if(x >= SanAndreasZones[i][Zone_Area][0] && x <= SanAndreasZones[i][Zone_Area][3]
		&& y >= SanAndreasZones[i][Zone_Area][1] && y <= SanAndreasZones[i][Zone_Area][4]
		&& z >= SanAndreasZones[i][Zone_Area][2] && z <= SanAndreasZones[i][Zone_Area][5])
		{
			strcpy(zone, sizeof(zone), SanAndreasZones[i][Zone_Name]);
			return zone;
		}
	}
	return zone;
}

LoadVehicles()
{
	new File:handle, count;
	new Filename[64], line[256];
	for(new i=1; i < MAX_DVEHICLES; i++)
	{
		format(Filename, sizeof(Filename), VEHICLE_File_PATH "v%d.ini", i);
		if(!fexist(Filename)) continue;
		handle = fopen(Filename, io_read);
		while(fread(handle, line))
		{
			StripNL(line);
			if(!line[0]) continue;
			if(strcmp(line, "Created=", false, 8) == 0) VehicleCreated[i] = strval(line[8]);
			else if(strcmp(line, "Model=", false, 6) == 0) VehicleModel[i] = strval(line[6]);
			else if(strcmp(line, "Pos=", false, 4) == 0) sscanf(line[4], "p,ffff", VehiclePos[i][0], VehiclePos[i][1],
				VehiclePos[i][2], VehiclePos[i][3]);
			else if(strcmp(line, "Colors=", false, 7) == 0) sscanf(line[7], "p,dd", VehicleColor[i][0], VehicleColor[i][1]);
			else if(strcmp(line, "Interior=", false, 9) == 0) VehicleInterior[i] = strval(line[9]);
			else if(strcmp(line, "VirtualWorld=", false, 13) == 0) VehicleWorld[i] = strval(line[13]);
			else if(strcmp(line, "Owner=", false, 6) == 0) strcpy(VehicleOwner[i], sizeof(VehicleOwner[]), line[6]);
			else if(strcmp(line, "NumberPlate=", false, 12) == 0) strcpy(VehicleNumberPlate[i], sizeof(VehicleNumberPlate[]), line[12]);
			else if(strcmp(line, "Value=", false, 6) == 0) VehicleValue[i] = strval(line[6]);
			else if(strcmp(line, "Trunk1=", false, 7) == 0) sscanf(line[7], "p,dd", VehicleTrunk[i][0][0], VehicleTrunk[i][0][1]);
			else if(strcmp(line, "Trunk2=", false, 7) == 0) sscanf(line[7], "p,dd", VehicleTrunk[i][1][0], VehicleTrunk[i][1][1]);
			else if(strcmp(line, "Trunk3=", false, 7) == 0) sscanf(line[7], "p,dd", VehicleTrunk[i][2][0], VehicleTrunk[i][2][1]);
			else if(strcmp(line, "Trunk4=", false, 7) == 0) sscanf(line[7], "p,dd", VehicleTrunk[i][3][0], VehicleTrunk[i][3][1]);
			else if(strcmp(line, "Trunk5=", false, 7) == 0) sscanf(line[7], "p,dd", VehicleTrunk[i][4][0], VehicleTrunk[i][4][1]);
			else if(strcmp(line, "Mod0=", false, 5) == 0) VehicleMods[i][0] = strval(line[5]);
			else if(strcmp(line, "Mod1=", false, 5) == 0) VehicleMods[i][1] = strval(line[5]);
			else if(strcmp(line, "Mod2=", false, 5) == 0) VehicleMods[i][2] = strval(line[5]);
			else if(strcmp(line, "Mod3=", false, 5) == 0) VehicleMods[i][3] = strval(line[5]);
			else if(strcmp(line, "Mod4=", false, 5) == 0) VehicleMods[i][4] = strval(line[5]);
			else if(strcmp(line, "Mod5=", false, 5) == 0) VehicleMods[i][5] = strval(line[5]);
			else if(strcmp(line, "Mod6=", false, 5) == 0) VehicleMods[i][6] = strval(line[5]);
			else if(strcmp(line, "Mod7=", false, 5) == 0) VehicleMods[i][7] = strval(line[5]);
			else if(strcmp(line, "Mod8=", false, 5) == 0) VehicleMods[i][8] = strval(line[5]);
			else if(strcmp(line, "Mod9=", false, 5) == 0) VehicleMods[i][9] = strval(line[5]);
			else if(strcmp(line, "Mod10=", false, 6) == 0) VehicleMods[i][10] = strval(line[6]);
			else if(strcmp(line, "Mod11=", false, 6) == 0) VehicleMods[i][11] = strval(line[6]);
			else if(strcmp(line, "Mod12=", false, 6) == 0) VehicleMods[i][12] = strval(line[6]);
			else if(strcmp(line, "Mod13=", false, 6) == 0) VehicleMods[i][13] = strval(line[6]);
			else if(strcmp(line, "Paintjob=", false, 9) == 0) VehiclePaintjob[i] = strval(line[9]);
		}
		fclose(handle);
		if(VehicleCreated[i]) count++;
	}
	printf("------ Dealerships System Started------ ");
	printf("  Loaded %d vehicles", count);
}

SaveVehicle(vehicleid)
{
	new Filename[64], line[256];
	format(Filename, sizeof(Filename), VEHICLE_File_PATH "v%d.ini", vehicleid);
	new File:handle = fopen(Filename, io_write);
	format(line, sizeof(line), "Created=%d\r\n", VehicleCreated[vehicleid]); fwrite(handle, line);
	format(line, sizeof(line), "Model=%d\r\n", VehicleModel[vehicleid]); fwrite(handle, line);
	format(line, sizeof(line), "Pos=%.3f,%.3f,%.3f,%.3f\r\n", VehiclePos[vehicleid][0], VehiclePos[vehicleid][1],
		VehiclePos[vehicleid][2], VehiclePos[vehicleid][3]);
	fwrite(handle, line);
	format(line, sizeof(line), "Colors=%d,%d\r\n", VehicleColor[vehicleid][0], VehicleColor[vehicleid][1]); fwrite(handle, line);
	format(line, sizeof(line), "Interior=%d\r\n", VehicleInterior[vehicleid]); fwrite(handle, line);
	format(line, sizeof(line), "VirtualWorld=%d\r\n", VehicleWorld[vehicleid]); fwrite(handle, line);
	format(line, sizeof(line), "Owner=%s\r\n", VehicleOwner[vehicleid]); fwrite(handle, line);
	format(line, sizeof(line), "NumberPlate=%s\r\n", VehicleNumberPlate[vehicleid]); fwrite(handle, line);
	format(line, sizeof(line), "Value=%d\r\n", VehicleValue[vehicleid]); fwrite(handle, line);
	format(line, sizeof(line), "Trunk1=%d,%d\r\n", VehicleTrunk[vehicleid][0][0], VehicleTrunk[vehicleid][0][1]); fwrite(handle, line);
	format(line, sizeof(line), "Trunk2=%d,%d\r\n", VehicleTrunk[vehicleid][1][0], VehicleTrunk[vehicleid][1][1]); fwrite(handle, line);
	format(line, sizeof(line), "Trunk3=%d,%d\r\n", VehicleTrunk[vehicleid][2][0], VehicleTrunk[vehicleid][2][1]); fwrite(handle, line);
	format(line, sizeof(line), "Trunk4=%d,%d\r\n", VehicleTrunk[vehicleid][3][0], VehicleTrunk[vehicleid][3][1]); fwrite(handle, line);
	format(line, sizeof(line), "Trunk5=%d,%d\r\n", VehicleTrunk[vehicleid][4][0], VehicleTrunk[vehicleid][4][1]); fwrite(handle, line);
	format(line, sizeof(line), "Mod0=%d\r\n", VehicleMods[vehicleid][0]); fwrite(handle, line);
	format(line, sizeof(line), "Mod1=%d\r\n", VehicleMods[vehicleid][1]); fwrite(handle, line);
	format(line, sizeof(line), "Mod2=%d\r\n", VehicleMods[vehicleid][2]); fwrite(handle, line);
	format(line, sizeof(line), "Mod3=%d\r\n", VehicleMods[vehicleid][3]); fwrite(handle, line);
	format(line, sizeof(line), "Mod4=%d\r\n", VehicleMods[vehicleid][4]); fwrite(handle, line);
	format(line, sizeof(line), "Mod5=%d\r\n", VehicleMods[vehicleid][5]); fwrite(handle, line);
	format(line, sizeof(line), "Mod6=%d\r\n", VehicleMods[vehicleid][6]); fwrite(handle, line);
	format(line, sizeof(line), "Mod7=%d\r\n", VehicleMods[vehicleid][7]); fwrite(handle, line);
	format(line, sizeof(line), "Mod8=%d\r\n", VehicleMods[vehicleid][8]); fwrite(handle, line);
	format(line, sizeof(line), "Mod9=%d\r\n", VehicleMods[vehicleid][9]); fwrite(handle, line);
	format(line, sizeof(line), "Mod10=%d\r\n", VehicleMods[vehicleid][10]); fwrite(handle, line);
	format(line, sizeof(line), "Mod11=%d\r\n", VehicleMods[vehicleid][11]); fwrite(handle, line);
	format(line, sizeof(line), "Mod12=%d\r\n", VehicleMods[vehicleid][12]); fwrite(handle, line);
	format(line, sizeof(line), "Mod13=%d\r\n", VehicleMods[vehicleid][13]); fwrite(handle, line);
	format(line, sizeof(line), "Paintjob=%d\r\n", VehiclePaintjob[vehicleid]); fwrite(handle, line);
	fclose(handle);
}

UpdateVehicle(vehicleid, removeold)
{
	if(VehicleCreated[vehicleid])
	{
		if(removeold)
		{
			new Float:health;
			GetVehicleHealth(VehicleID[vehicleid], health);
			new engine, lights, alarm, doors, bonnet, boot, objective;
			GetVehicleParamsEx(VehicleID[vehicleid], engine, lights, alarm, doors, bonnet, boot, objective);
			//new panels, doorsd, lightsd, tires;
			//GetVehicleDamageStatus(VehicleID[vehicleid], panels, doorsd, lightsd, tires);
			DestroyVehicle(VehicleID[vehicleid]);
			VehicleID[vehicleid] = CreateVehicle(VehicleModel[vehicleid], VehiclePos[vehicleid][0], VehiclePos[vehicleid][1],
				VehiclePos[vehicleid][2], VehiclePos[vehicleid][3], VehicleColor[vehicleid][0], VehicleColor[vehicleid][1], 3600);
			SetVehicleHealth(VehicleID[vehicleid], health);
			SetVehicleParamsEx(VehicleID[vehicleid], engine, lights, alarm, doors, bonnet, boot, objective);
			//UpdateVehicleDamageStatus(VehicleID[vehicleid], panels, doorsd, lightsd, tires);
		}
		else
		{
			VehicleID[vehicleid] = CreateVehicle(VehicleModel[vehicleid], VehiclePos[vehicleid][0], VehiclePos[vehicleid][1],
				VehiclePos[vehicleid][2], VehiclePos[vehicleid][3], VehicleColor[vehicleid][0], VehicleColor[vehicleid][1], 3600);
		}
		LinkVehicleToInterior(VehicleID[vehicleid], VehicleInterior[vehicleid]);
		SetVehicleVirtualWorld(VehicleID[vehicleid], VehicleWorld[vehicleid]);
		SetVehicleNumberPlate(VehicleID[vehicleid], VehicleNumberPlate[vehicleid]);
		for(new i=0; i < sizeof(VehicleMods[]); i++)
		{
			AddVehicleComponent(VehicleID[vehicleid], VehicleMods[vehicleid][i]);
		}
		ChangeVehiclePaintjob(VehicleID[vehicleid], VehiclePaintjob[vehicleid]);
		UpdateVehicleLabel(vehicleid, removeold);
	}
}

UpdateVehicleLabel(vehicleid, removeold)
{
	if(VehicleCreated[vehicleid] == VEHICLE_DEALERSHIP)
	{
		if(removeold)
		{
			Delete3DTextLabel(VehicleLabel[vehicleid]);
		}
		new labeltext[128];
		format(labeltext, sizeof(labeltext), "%s\nID: %d\nDealership: %s\nPrice: $%d", VehicleNames[VehicleModel[vehicleid]-400],
			vehicleid, VehicleOwner[vehicleid], VehicleValue[vehicleid]);
		VehicleLabel[vehicleid] = Create3DTextLabel(labeltext, 0xBB7700DD, 0, 0, 0, 10.0, 0);
		Attach3DTextLabelToVehicle(VehicleLabel[vehicleid], VehicleID[vehicleid], 0, 0, 0);
	}
}

IsValidVehicle(vehicleid)
{
	if(vehicleid < 1 || vehicleid >= MAX_DVEHICLES) return 0;
	if(VehicleCreated[vehicleid]) return 1;
	return 0;
}

GetVehicleID(vehicleid)
{
	for(new i=1; i < MAX_DVEHICLES; i++)
	{
		if(VehicleCreated[i] && VehicleID[i] == vehicleid) return i;
	}
	return 0;
}

GetPlayerVehicles(playerid)
{
	new count;
	for(new i=1; i < MAX_DVEHICLES; i++)
	{
		if(VehicleCreated[i] == VEHICLE_PLAYER && strcmp(VehicleOwner[i], PlayerName(playerid)) == 0)
		{
			count++;
		}
	}
	return count;
}

GetPlayerVehicleAccess(playerid, vehicleid)
{
	if(IsValidVehicle(vehicleid))
	{
		if(VehicleCreated[vehicleid] == VEHICLE_DEALERSHIP)
		{
			if(PlayerInfo[playerid][pAdmin] < 1338)
			{
				return 3;
			}
		}
		else if(VehicleCreated[vehicleid] == VEHICLE_PLAYER)
		{
			if(strcmp(VehicleOwner[vehicleid], PlayerName(playerid)) == 0)
			{
				return 1;
			}
			else if(GetPVarInt(playerid, "CarKeys") == vehicleid)
			{
				return 2;
			}
		}
	}
	else
	{
		return 2;
	}
	return 0;
}

LoadDealerships()
{
	new File:handle, count;
	new Filename[64], line[256];
	for(new i=1; i < MAX_DEALERSHIPS; i++)
	{
		format(Filename, sizeof(Filename), DEALERSHIP_File_PATH "d%d.ini", i);
		if(!fexist(Filename)) continue;
		handle = fopen(Filename, io_read);
		while(fread(handle, line))
		{
			StripNL(line);
			if(!line[0]) continue;
			if(strcmp(line, "Created=", false, 8) == 0) DealershipCreated[i] = strval(line[8]);
			else if(strcmp(line, "Pos=", false, 4) == 0) sscanf(line[4], "p,fff", DealershipPos[i][0],
				DealershipPos[i][1], DealershipPos[i][2]);
		}
		fclose(handle);
		if(DealershipCreated[i]) count++;
	}
	printf("  Loaded %d dealerships", count);
}

SaveDealership(dealerid)
{
	new Filename[64], line[256];
	format(Filename, sizeof(Filename), DEALERSHIP_File_PATH "d%d.ini", dealerid);
	new File:handle = fopen(Filename, io_write);
	format(line, sizeof(line), "Created=%d\r\n", DealershipCreated[dealerid]); fwrite(handle, line);
	format(line, sizeof(line), "Pos=%.3f,%.3f,%.3f\r\n", DealershipPos[dealerid][0],
		DealershipPos[dealerid][1], DealershipPos[dealerid][2]);
	fwrite(handle, line);
	fclose(handle);
}

UpdateDealership(dealerid, removeold)
{
	if(DealershipCreated[dealerid])
	{
		if(removeold)
		{
			Delete3DTextLabel(DealershipLabel[dealerid]);
		}
		new labeltext[32];
		format(labeltext, sizeof(labeltext), "Vehicle Dealership\nID: %d", dealerid);
		DealershipLabel[dealerid] = Create3DTextLabel(labeltext, 0x00BB00DD, DealershipPos[dealerid][0],
			DealershipPos[dealerid][1], DealershipPos[dealerid][2]+0.5, 20.0, 0);
	}
}

IsValidDealership(dealerid)
{
	if(dealerid < 1 || dealerid >= MAX_DEALERSHIPS) return 0;
	if(DealershipCreated[dealerid]) return 1;
	return 0;
}

LoadFuelStations()
{
	new File:handle, count;
	new Filename[64], line[256];
	for(new i=1; i < MAX_FUEL_STATIONS; i++)
	{
		format(Filename, sizeof(Filename), FUEL_STATION_File_PATH "f%d.ini", i);
		if(!fexist(Filename)) continue;
		handle = fopen(Filename, io_read);
		while(fread(handle, line))
		{
			StripNL(line);
			if(!line[0]) continue;
			if(strcmp(line, "Created=", false, 8) == 0) FuelStationCreated[i] = strval(line[8]);
			else if(strcmp(line, "Pos=", false, 4) == 0) sscanf(line[4], "p,fff", FuelStationPos[i][0],
				FuelStationPos[i][1], FuelStationPos[i][2]);
		}
		fclose(handle);
		if(FuelStationCreated[i]) count++;
	}
	printf("  Loaded %d fuel stations", count);
}

SaveFuelStation(stationid)
{
	new Filename[64], line[256];
	format(Filename, sizeof(Filename), FUEL_STATION_File_PATH "f%d.ini", stationid);
	new File:handle = fopen(Filename, io_write);
	format(line, sizeof(line), "Created=%d\r\n", FuelStationCreated[stationid]); fwrite(handle, line);
	format(line, sizeof(line), "Pos=%.3f,%.3f,%.3f\r\n", FuelStationPos[stationid][0],
		FuelStationPos[stationid][1], FuelStationPos[stationid][2]);
	fwrite(handle, line);
	fclose(handle);
}

UpdateFuelStation(stationid, removeold)
{
	if(FuelStationCreated[stationid])
	{
		if(removeold)
		{
			Delete3DTextLabel(FuelStationLabel[stationid]);
		}
		new labeltext[32];
		format(labeltext, sizeof(labeltext), "Fuel Station\nID: %d\n/fuel", stationid);
		FuelStationLabel[stationid] = Create3DTextLabel(labeltext, 0x00BBFFDD, FuelStationPos[stationid][0],
			FuelStationPos[stationid][1], FuelStationPos[stationid][2]+0.5, 20.0, 0);
	}
}

IsValidFuelStation(stationid)
{
	if(stationid < 1 || stationid >= MAX_FUEL_STATIONS) return 0;
	if(FuelStationCreated[stationid]) return 1;
	return 0;
}
stock GetVehicleName(vehicleid, model[], len)
{
	new vid = GetVehicleModel(vehicleid);
	if(vid == 400) return format(model, len, "Landstalker", 0);
	else if(vid == 401) return format(model, len, "Bravura", 0);
	else if(vid == 402) return format(model, len, "Buffalo", 0);
	else if(vid == 403) return format(model, len, "Linerunner", 0);
	else if(vid == 404) return format(model, len, "Perenail", 0);
	else if(vid == 405) return format(model, len, "Sentinel", 0);
	else if(vid == 406) return format(model, len, "Dumper", 0);
	else if(vid == 407) return format(model, len, "Firetruck", 0);
	else if(vid == 408) return format(model, len, "Trashmaster", 0);
	else if(vid == 409) return format(model, len, "Stretch", 0);
	else if(vid == 410) return format(model, len, "Manana", 0);
	else if(vid == 411) return format(model, len, "Infernus", 0);
	else if(vid == 412) return format(model, len, "Vodooo", 0);
	else if(vid == 413) return format(model, len, "Pony", 0);
	else if(vid == 414) return format(model, len, "Mule", 0);
	else if(vid == 415) return format(model, len, "Cheetah", 0);
	else if(vid == 416) return format(model, len, "Ambulance", 0);
	else if(vid == 417) return format(model, len, "Leviathan", 0);
	else if(vid == 418) return format(model, len, "Moonbeam", 0);
	else if(vid == 419) return format(model, len, "Esperanto", 0);
	else if(vid == 420) return format(model, len, "Taxi", 0);
	else if(vid == 421) return format(model, len, "Washington", 0);
	else if(vid == 422) return format(model, len, "Bobcat", 0);
	else if(vid == 423) return format(model, len, "Mr Whoopee", 0);
	else if(vid == 424) return format(model, len, "BF Injection", 0);
	else if(vid == 425) return format(model, len, "Hunter", 0);
	else if(vid == 426) return format(model, len, "Premier", 0);
	else if(vid == 427) return format(model, len, "S.W.A.T Truck", 0);
	else if(vid == 428) return format(model, len, "Securicar", 0);
	else if(vid == 429) return format(model, len, "Banshee", 0);
	else if(vid == 430) return format(model, len, "Predator", 0);
	else if(vid == 431) return format(model, len, "Bus", 0);
	else if(vid == 432) return format(model, len, "Rhino", 0);
	else if(vid == 433) return format(model, len, "Barracks", 0);
	else if(vid == 434) return format(model, len, "Hotknife", 0);
	else if(vid == 435) return format(model, len, "Trailer", 0);
	else if(vid == 436) return format(model, len, "Previon", 0);
	else if(vid == 437) return format(model, len, "Coach", 0);
	else if(vid == 438) return format(model, len, "Cabbie", 0);
	else if(vid == 439) return format(model, len, "Stallion", 0);
	else if(vid == 440) return format(model, len, "Rumpo", 0);
	else if(vid == 441) return format(model, len, "RC Bandit", 0);
	else if(vid == 442) return format(model, len, "Romero", 0);
	else if(vid == 443) return format(model, len, "Packer", 0);
	else if(vid == 444) return format(model, len, "Monster", 0);
	else if(vid == 445) return format(model, len, "Admiral", 0);
	else if(vid == 446) return format(model, len, "Squalo", 0);
	else if(vid == 447) return format(model, len, "Seasparrow", 0);
	else if(vid == 448) return format(model, len, "Pizza Boy", 0);
	else if(vid == 449) return format(model, len, "Tram", 0);
	else if(vid == 450) return format(model, len, "Trailer 2", 0);
	else if(vid == 451) return format(model, len, "Turismo", 0);
	else if(vid == 452) return format(model, len, "Speeder", 0);
	else if(vid == 453) return format(model, len, "Refeer", 0);
	else if(vid == 454) return format(model, len, "Tropic", 0);
	else if(vid == 455) return format(model, len, "Flatbed", 0);
	else if(vid == 456) return format(model, len, "Yankee", 0);
	else if(vid == 457) return format(model, len, "Caddy", 0);
	else if(vid == 458) return format(model, len, "Solair", 0);
	else if(vid == 459) return format(model, len, "Top Fun", 0);
	else if(vid == 460) return format(model, len, "Skimmer", 0);
	else if(vid == 461) return format(model, len, "PCJ-600", 0);
	else if(vid == 462) return format(model, len, "Faggio", 0);
	else if(vid == 463) return format(model, len, "Freeway", 0);
	else if(vid == 464) return format(model, len, "RC Baron", 0);
	else if(vid == 465) return format(model, len, "RC Raider", 0);
	else if(vid == 466) return format(model, len, "Glendade", 0);
	else if(vid == 467) return format(model, len, "Oceanic", 0);
	else if(vid == 468) return format(model, len, "Sanchez", 0);
	else if(vid == 469) return format(model, len, "Sparrow", 0);
	else if(vid == 470) return format(model, len, "Patriot", 0);
	else if(vid == 471) return format(model, len, "Quad", 0);
	else if(vid == 472) return format(model, len, "Coastguard", 0);
	else if(vid == 473) return format(model, len, "Dinghy", 0);
	else if(vid == 474) return format(model, len, "Hermes", 0);
	else if(vid == 475) return format(model, len, "Sabre", 0);
	else if(vid == 476) return format(model, len, "Rustler", 0);
	else if(vid == 477) return format(model, len, "ZR-350", 0);
	else if(vid == 478) return format(model, len, "Walton", 0);
	else if(vid == 479) return format(model, len, "Regina", 0);
	else if(vid == 480) return format(model, len, "Comet", 0);
	else if(vid == 481) return format(model, len, "BMX", 0);
	else if(vid == 482) return format(model, len, "Burrito", 0);
	else if(vid == 483) return format(model, len, "Camper", 0);
	else if(vid == 484) return format(model, len, "Marquis", 0);
	else if(vid == 485) return format(model, len, "Baggage", 0);
	else if(vid == 486) return format(model, len, "Dozer", 0);
	else if(vid == 487) return format(model, len, "Maverick", 0);
	else if(vid == 488) return format(model, len, "News Maverick", 0);
	else if(vid == 489) return format(model, len, "Rancher", 0);
	else if(vid == 490) return format(model, len, "Federal Rancher", 0);
	else if(vid == 491) return format(model, len, "Virgo", 0);
	else if(vid == 492) return format(model, len, "Greenwood", 0);
	else if(vid == 493) return format(model, len, "Jetmax", 0);
	else if(vid == 494) return format(model, len, "Hotring", 0);
	else if(vid == 495) return format(model, len, "Sandking", 0);
	else if(vid == 496) return format(model, len, "Blista Compact", 0);
	else if(vid == 497) return format(model, len, "Police Maverick", 0);
	else if(vid == 498) return format(model, len, "Boxville", 0);
	else if(vid == 499) return format(model, len, "Benson", 0);
	else if(vid == 500) return format(model, len, "Mesa", 0);
	else if(vid == 501) return format(model, len, "RC Goblin", 0);
	else if(vid == 502) return format(model, len, "Hotring A", 0);
	else if(vid == 503) return format(model, len, "Hotring B", 0);
	else if(vid == 504) return format(model, len, "Blooding Banger", 0);
	else if(vid == 505) return format(model, len, "Rancher", 0);
	else if(vid == 506) return format(model, len, "Super GT", 0);
	else if(vid == 507) return format(model, len, "Elegant", 0);
	else if(vid == 508) return format(model, len, "Journey", 0);
	else if(vid == 509) return format(model, len, "Bike", 0);
	else if(vid == 510) return format(model, len, "Mountain Bike", 0);
	else if(vid == 511) return format(model, len, "Beagle", 0);
	else if(vid == 512) return format(model, len, "Cropduster", 0);
	else if(vid == 513) return format(model, len, "Stuntplane", 0);
	else if(vid == 514) return format(model, len, "Petrol", 0);
	else if(vid == 515) return format(model, len, "Roadtrain", 0);
	else if(vid == 516) return format(model, len, "Nebula", 0);
	else if(vid == 517) return format(model, len, "Majestic", 0);
	else if(vid == 518) return format(model, len, "Buccaneer", 0);
	else if(vid == 519) return format(model, len, "Shamal", 0);
	else if(vid == 520) return format(model, len, "Hydra", 0);
	else if(vid == 521) return format(model, len, "FCR-300", 0);
	else if(vid == 522) return format(model, len, "NRG-500", 0);
	else if(vid == 523) return format(model, len, "HPV-1000", 0);
	else if(vid == 524) return format(model, len, "Cement Truck", 0);
	else if(vid == 525) return format(model, len, "Towtruck", 0);
	else if(vid == 526) return format(model, len, "Fortune", 0);
	else if(vid == 527) return format(model, len, "Cadrona", 0);
	else if(vid == 528) return format(model, len, "Federal Truck", 0);
	else if(vid == 529) return format(model, len, "Williard", 0);
	else if(vid == 530) return format(model, len, "Fork Lift", 0);
	else if(vid == 531) return format(model, len, "Tractor", 0);
	else if(vid == 532) return format(model, len, "Combine", 0);
	else if(vid == 533) return format(model, len, "Feltzer", 0);
	else if(vid == 534) return format(model, len, "Remington", 0);
	else if(vid == 535) return format(model, len, "Slamvan", 0);
	else if(vid == 536) return format(model, len, "Blade", 0);
	else if(vid == 537) return format(model, len, "Freight", 0);
	else if(vid == 538) return format(model, len, "Streak", 0);
	else if(vid == 539) return format(model, len, "Vortex", 0);
	else if(vid == 540) return format(model, len, "Vincent", 0);
	else if(vid == 541) return format(model, len, "Bullet", 0);
	else if(vid == 542) return format(model, len, "Clover", 0);
	else if(vid == 543) return format(model, len, "Sadler", 0);
	else if(vid == 544) return format(model, len, "Stairs Firetruck", 0);
	else if(vid == 545) return format(model, len, "Hustler", 0);
	else if(vid == 546) return format(model, len, "Intruder", 0);
	else if(vid == 547) return format(model, len, "Primo", 0);
	else if(vid == 548) return format(model, len, "Cargobob", 0);
	else if(vid == 549) return format(model, len, "Tampa", 0);
	else if(vid == 550) return format(model, len, "Sunrise", 0);
	else if(vid == 551) return format(model, len, "Merit", 0);
	else if(vid == 552) return format(model, len, "Utility Van", 0);
	else if(vid == 553) return format(model, len, "Nevada", 0);
	else if(vid == 554) return format(model, len, "Yosemite", 0);
	else if(vid == 555) return format(model, len, "Windsor", 0);
	else if(vid == 556) return format(model, len, "Monster A", 0);
	else if(vid == 557) return format(model, len, "Monster B", 0);
	else if(vid == 558) return format(model, len, "Uranus", 0);
	else if(vid == 559) return format(model, len, "Jester", 0);
	else if(vid == 560) return format(model, len, "Sultan", 0);
	else if(vid == 561) return format(model, len, "Stratum", 0);
	else if(vid == 562) return format(model, len, "Elegy", 0);
	else if(vid == 563) return format(model, len, "Raindance", 0);
	else if(vid == 564) return format(model, len, "RC Tiger", 0);
	else if(vid == 565) return format(model, len, "Flash", 0);
	else if(vid == 566) return format(model, len, "Tahoma", 0);
	else if(vid == 567) return format(model, len, "Savanna", 0);
	else if(vid == 568) return format(model, len, "Bandito", 0);
	else if(vid == 569) return format(model, len, "Freight Flat", 0);
	else if(vid == 570) return format(model, len, "Streak", 0);
	else if(vid == 571) return format(model, len, "Kart", 0);
	else if(vid == 572) return format(model, len, "Mower", 0);
	else if(vid == 573) return format(model, len, "Duneride", 0);
	else if(vid == 574) return format(model, len, "Sweeper", 0);
	else if(vid == 575) return format(model, len, "Broadway", 0);
	else if(vid == 576) return format(model, len, "Tornado", 0);
	else if(vid == 577) return format(model, len, "AT-400", 0);
	else if(vid == 578) return format(model, len, "DFT-30", 0);
	else if(vid == 579) return format(model, len, "Huntley", 0);
	else if(vid == 580) return format(model, len, "Stafford", 0);
	else if(vid == 581) return format(model, len, "BF-400", 0);
	else if(vid == 582) return format(model, len, "Raindance", 0);
	else if(vid == 583) return format(model, len, "News Van", 0);
	else if(vid == 584) return format(model, len, "Tug", 0);
	else if(vid == 585) return format(model, len, "Petrol Tanker", 0);
	else if(vid == 586) return format(model, len, "Wayfarer", 0);
	else if(vid == 587) return format(model, len, "Euros", 0);
	else if(vid == 588) return format(model, len, "Hotdog", 0);
	else if(vid == 589) return format(model, len, "Club", 0);
	else if(vid == 590) return format(model, len, "Freight Box", 0);
	else if(vid == 591) return format(model, len, "Trailer 3", 0);
	else if(vid == 592) return format(model, len, "Andromada", 0);
	else if(vid == 593) return format(model, len, "Dodo", 0);
	else if(vid == 594) return format(model, len, "RC Cam", 0);
	else if(vid == 595) return format(model, len, "Launch", 0);
	else if(vid == 596) return format(model, len, "LSPD Patrol Car", 0);
	else if(vid == 597) return format(model, len, "FBI Patrol Car", 0);
	else if(vid == 598) return format(model, len, "NG Patrol Car", 0);
	else if(vid == 599) return format(model, len, "LSPD Patrol Ranger", 0);
	else if(vid == 600) return format(model, len, "Picador", 0);
	else if(vid == 601) return format(model, len, "S.W.A.T Tank", 0);
    else if(vid == 602) return format(model, len, "Alpha", 0);
	else if(vid == 603) return format(model, len, "Phoenix", 0);
	else if(vid == 609) return format(model, len, "Boxville", 0);
	return 0;
}
