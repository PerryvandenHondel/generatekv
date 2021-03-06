//
// 	GenerateKV
//
//	Generate a log file with Key-Values for Splunk
//
//	Format: YYYY-MM-DD HH:MM:SS key=value key=value
//

program GenerateKV;


{$MODE OBJFPC}
{$I+}


uses
	Crt,
	Dos,
	StrUtils,
	SysUtils,
	USupportLibrary,
	UVersion;


const
	SPACE = #32;

	
var
	path: AnsiString;
	configMaxWait: integer;
	//maxLines: integer;

	
procedure WaitSomeMiliseconds();
var
	num: integer;
begin
	Randomize;
	num := Random(500) + 1;
	Sleep(num);
end;

	
	
function GetDateTime(): AnsiString;
//
//	Get the current date time in the format: YYYY-MM-DD HH:MM:SS
//
var
	Yr: Word;
	Md: Word;
	Dy: Word;
	Dow: Word;
	Hr: Word;
	Mn: Word; // Minutes, conflicts with
	Sc: Word;
	S100: Word;
begin
	Yr := 0; 
	Md := 0;
	Dy := 0;
	Dow := 0;
	Hr := 0;
	Mn := 0;
	Sc := 0;
	S100 := 0;
	GetDate(Yr, Md, Dy, Dow);
	GetTime(Hr, Mn, Sc, S100);
	//GetDateTime := NumberAlign(Yr, 4) + '-' + NumberAlign(Md, 2) + '-' + NumberAlign(Dy, 2) + ' ' + NumberAlign(Hr, 2) + ':' + NumberAlign(Mn, 2) + ':' + NumberAlign(Sc, 2) + '.' + NumberAlign(S100, 4);
	GetDateTime := NumberAlign(Yr, 4) + '-' + NumberAlign(Md, 2) + '-' + NumberAlign(Dy, 2) + ' ' + NumberAlign(Hr, 2) + ':' + NumberAlign(Mn, 2) + ':' + NumberAlign(Sc, 2);
end; // of function GetDateTime
	
	
function GetGeoCoordinates(path: AnsiString): AnsiString;
//
//	Read 2 geo coordinates from a file and return//
//		lat=cordinate1 lat=cordinate2
//
var
	f: TextFile;
	line: Ansistring;
	entries:integer;
	selected: integer;
	x: integer;
	r: AnsiString;
	lat: AnsiString;
	lon: AnsiString;
begin
	Randomize;
	Sleep(configMaxWait);
	
	r := '';
	
	entries := LineCount(path);
	selected := Random(entries) + 1;
	
	AssignFile(f, path);
	{I+}
	Reset(f);
	for x := 1 to selected do
	begin
		ReadLn(f, line);
		if x = selected then
			r := line;
	end;
	CloseFile(f);
	
	lat := LeftStr(r, Pos(';', r) - 1);
	lon := RightStr(r, Pos(';', r) - 2);
	
	GetGeoCoordinates := 'lat=' + lat + SPACE + 'lon=' + lon;
end; // of GetGeoCoordinates()	
	
	
	
	
function GetRandomItemFromFile(path: AnsiString; key: AnsiString): AnsiString;
//
//	Read a random item from the filename and return it as a key-value pair
//
var
	f: TextFile;
	line: AnsiString;
	entries: integer;
	selected: integer;
	x: integer;
	r: AnsiString;
begin
	Randomize;
	Sleep(configMaxWait);
	
	r := '';
	
	entries := LineCount(path);
	selected := Random(entries) + 1;
	
	AssignFile(f, path);
	{I+}
	Reset(f);
	for x := 1 to selected do
	begin
		ReadLn(f, line);
		if x = selected then
			r := line;
			
		//WriteLn(x, ': ', line);
	end;
	CloseFile(f);
	GetRandomItemFromFile := key + '=' + r;
end; // of GetRandomItemFromFile()
	


function GetRandomNumber(key: Ansistring; maxNumber: integer): AnsiString;
var
	r: integer;
begin
	Randomize;
	r := Random(maxNumber) + 1;
	GetRandomNumber := key + '=' + IntToStr(r);
end;


	
procedure WriteToFile(path: AnsiString);
var	
	f: TextFile;
	x: integer;
	z: integer;
	l: AnsiString;
	wl: AnsiString;
begin
	AssignFile(f, path);
	{I+}
	
	if FileExists(path) then
		Append(f) // Append to the existing file.
	else
		ReWrite(f);	// Open the file in write mode for writing to a new file
	
	//for x := 1 to maxLines do
	x := 0;
	repeat
		Sleep(configMaxWait);
		randomize;
		
		inc(x);
		
		z := random(7);
		case z of
			1: l := GetRandomItemFromFile('list-ip.txt', 'ip') + SPACE + GetRandomNumber('num', 1000);
			2: l := GetRandomItemFromFile('list-ip.txt', 'src_ip') + SPACE + GetRandomItemFromFile('list-ip.txt', 'dst_ip') + SPACE + GetRandomNumber('bytes_transferd', 20000);
			3: l := GetRandomItemFromFile('list-computer.txt','system') + SPACE + GetRandomItemFromFile('list-username.txt', 'username') + SPACE + 'action=logon';
			4: l := GetRandomItemFromFile('list-computer.txt','system') + SPACE + GetRandomItemFromFile('list-username.txt', 'username') + SPACE + 'action=logoff';
			5: l := 'action=reading' + SPACE + GetRandomItemFromFile('list-computer.txt','system') + SPACE + GetRandomItemFromFile('list-username.txt', 'username') + SPACE + GetRandomNumber('read', 1000);
			6: l := GetRandomNumber('bytes_transferd', 10000) + SPACE + GetGeoCoordinates('list-geo.txt');
		end; // case
		wl := GetDateTime() + SPACE + l;
		WriteLn(x, ' (', path, ') ', wl);
		WriteLn(f, wl);
	until keypressed;
	CloseFile(f);
end;



procedure ProgTitle();
begin
	WriteLn('GenerateKV - Version ', VERSION);
end; // of ProgTitle



begin
	ProgTitle();
	
	path := ReadSettingKey('generatekv.conf', 'Settings', 'output');
	WriteLn('Output to: ', path);
	
	configMaxWait := StrToInt(ReadSettingKey('generatekv.conf', 'Settings', 'maxWait'));
	WriteLn('Maximum wait between events: ', configMaxWait);
	
	//Writeln(GetGeoCoordinates('list-geo.txt'));
	
	//WaitSomeMiliseconds();
	WriteToFile(path)
	//WriteLn('Returned IP=', GetIp());
end. 

// EOS


