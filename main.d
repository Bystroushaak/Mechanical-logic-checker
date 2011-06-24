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
	Part tmp;
	uint line_num;
	foreach(line; script){
		line = line.strip();
		line_num++;
		
		if (line == "")
			continue;

		try{
			if (line.indexOf(":") > 0){
				// Create parts
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
	string[] tmp_pars;
	foreach(line; script){
		line = line.strip();

		if (line == "")
			continue;

		if (line.indexOf('-') > 0){
			tmp_pars = line.split("-");
			tmp_pars[0] = tmp_pars[0].strip();
			tmp_pars[1] = tmp_pars[1].strip();

			if (tmp_pars[0] !in gamedesk){
				stderr.writeln("Error on line " ~ std.conv.to!(string)(line_num) ~ " '" ~ line ~ "'");
				stderr.writeln(">> '" ~ tmp_pars[0] ~ "' not defined!");
			}

			if (tmp_pars[1] !in gamedesk){
				stderr.writeln("Error on line " ~ std.conv.to!(string)(line_num) ~ " '" ~ line ~ "'");
				stderr.writeln(">> '" ~ tmp_pars[1] ~ "' not defined!");
			}

			gamedesk[tmp_pars[0]].addNeighbour(gamedesk[tmp_pars[1]]);
			gamedesk[tmp_pars[1]].addNeighbour(gamedesk[tmp_pars[0]]);
		}
	}

	return 0;
}
