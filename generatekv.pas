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
	StrUtils,
	SysUtils,
	USupportLibrary;

	
var
	path: AnsiString;
	maxLines: integer;

	
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
		WriteLn(f, x);
	end;
	CloseFile(f);
end;


begin
	WriteLn('Running...');
	path := 'testkv.log';
	WriteToFile(path)
end. 

// EOS


