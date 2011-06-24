import std.stdio;
import std.file;
import std.conv;
import std.string;

import parts.part;
import parts.gear;
import parts.igear;

/* TODO
 * Pridelat check duplicitnich nazvu
*/

int main(string[] args){
	// sem dodelat nejake smysluplne parsovani argumentu & nacteni souboru
	string[] script = readText("script.chk").splitlines();

	Part[string] gamedesk;
	Part[] stack;

	// Create objects
	uint line_num;
	foreach(line; script){
		line = line.strip();
		line_num++;
		
		if (line == "")
			continue;

		try{
			Part tmp;
			if (line.indexOf(":") > 0){
				if (line.startsWith("gear")){
					tmp = new Gear(line);
				}else if (line.startsWith("igear")){
					tmp = new IGear(line);
					stack ~= tmp;
				}else{
					stderr.writeln("Error on line " ~ std.conv.to!(string)(line_num) ~ " '" ~ line ~ "'");
					stderr.writeln(">> Unknown part");
					return 1;
				}

				// Test duplicite name
				if (tmp.getName() !in gamedesk)
					gamedesk[tmp.getName()] = tmp;
				else{
					stderr.writeln("Error on line " ~ std.conv.to!(string)(line_num) ~ " '" ~ line ~ "'");
					stderr.writeln(">> Duplicite name definition!");
					return 2;
				}
			}
		}catch(PartDefinitionException e){
			stderr.writeln("Error on line " ~ std.conv.to!(string)(line_num) ~ " '" ~ line ~ "'");
			stderr.writeln(">> " ~ e.msg);
			return 1;
		}
	}

	// Join objects
	foreach(line; script){
		
	}

	return 0;
}
