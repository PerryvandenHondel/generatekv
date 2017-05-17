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
	Dos,
	StrUtils,
	SysUtils,
	USupportLibrary;

	
var
	path: AnsiString;
	maxLines: integer;

	
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
	GetDate(Yr, Md, Dy, Dow);
	GetTime(Hr, Mn, Sc, S100);
	GetDateTime := NumberAlign(Yr, 4) + '-' + NumberAlign(Md, 2) + '-' + NumberAlign(Dy, 2) + ' ' + NumberAlign(Hr, 2) + ':' + NumberAlign(Mn, 2) + ':' + NumberAlign(Sc, 2) + '.' + NumberAlign(S100, 4);
end; // of function GetDateTime
	
	
procedure WriteToFile(path: AnsiString);
var	
	f: TextFile;
	x: integer;
begin
	AssignFile(f, path);
	{I+}
	// Open the file in write mode.
	ReWrite(f);
	for x := 1 to maxLines do
	begin
		WriteLn(f, GetDateTime(), ' ', x);
	end;
	CloseFile(f);
end;


begin
	maxLines := 100;
	WriteLn('Running...');
	path := 'testkv.log';
	
	
	WriteToFile(path)
end. 

// EOS


