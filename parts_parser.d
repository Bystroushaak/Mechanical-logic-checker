import std.string;

import std.file;
import std.stdio;

private const char COMMENT = '#';

private string[] removeCrap(string[] list){
	string[] output;
	
	foreach(string line; list){
		if (!line.startsWith(COMMENT) && line.strip() != "")
			if (line.indexOf(COMMENT) > 0)
				output ~= line[0 .. line.indexOf(COMMENT)].strip();
			else
				output ~= line;
	} 
	
	return output;
}

void main(){
	string[] result = std.file.readText("parts/ldiode").splitlines();
	result = removeCrap(result);
	
	foreach(line; result)
		writeln(line);
	
}