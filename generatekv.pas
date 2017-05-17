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
	USupportLibrary;

	
var
	path: AnsiString;
	maxLines: integer;

	
procedure WaitSomeMiliseconds();
var
	num: integer;
begin
	Randomize;
	num := Random(2000) + 1;
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
	
	
function GetListIp(key: AnsiString): AnsiString;
var
	path: AnsiString;
	f: TextFile;
	line: AnsiString;
	entries: integer;
	selected: integer;
	x: integer;
	r: AnsiString;
begin
	Randomize;
	r := '';
	path := 'list-ip.txt';
	
	entries := LineCount(path);
	selected := Random(entries) + 1;
	
	//WriteLn(entries);
	//WriteLn(selected);
	
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
	GetListIp := key + '=' + r;
end;	
	
	
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
		inc(x);
		WaitSomeMiliseconds();
		WriteLn(x, ' [ESC] = break');
		randomize;
		
		z := random(5);
		case z of
			1: WriteLn(f, GetDateTime(), ' ', GetListIp('ip'), ' ', GetRandomNumber('num', 1000));
			2: WriteLn(f, GetDateTime(), ' ', GetListIp('src_ip'), ' ', GetListIp('dst_ip'), ' ', GetRandomNumber('bytes_transferd', 20000));
			3: WriteLn('3');
			4: WriteLn('4');
		end; // case
	until keypressed;
	CloseFile(f);
end;


begin
	WriteLn('Running...');
	path := 'd:\opt\splunk\sandbox\testkv.log';
	
	//WaitSomeMiliseconds();
	WriteToFile(path)
	//WriteLn('Returned IP=', GetIp());
end. 

// EOS


