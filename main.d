import std.stdio;
import std.file;
import std.conv;
import std.string;

import parts.part;
import parts.gear;
import parts.igear;

/* TODO
	 * pridelat moznost komentaru
*/


void printStackTraceHeader(ref File o, Part[string] gamedesk){
	foreach(key, val; gamedesk)
		o.write(key ~ ", ");
	
	o.writeln();
}

void printStackTrace(ref File o, Part[string] gamedesk){
	foreach(key, val; gamedesk)
		o.write(std.conv.to!(string)(val.getRotation()) ~ ", ");

	o.writeln();
}

int main(string[] args){
	// sem dodelat nejake smysluplne parsovani argumentu & nacteni souboru
	string[] script = readText("script.chk").splitlines();

	Part[] inputs;
	Part[string] gamedesk;
	PartContainer[] stack;

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
					inputs ~= tmp;
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

	// Main algorithm - emulate signal propagation
	foreach(input; inputs){
		stack ~= (cast(IGear) input).begin();
	}
	
	for (uint act = 0; act + 1 < stack.length; act++){
		try{
			stack ~= stack[act].part.react(stack[act]);
		}catch(RotationCollisionException e){
			stderr.writeln("# Error! " ~ e.msg ~ " in collision!");
			writeln();
			printStackTraceHeader(stderr, gamedesk);
			printStackTrace(stderr, gamedesk);
			return 3;
		}
	}

	return 0;
}
