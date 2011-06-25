import std.stdio;
import std.file;
import std.conv;
import std.string;

import parts.part;
import parts.gear;
import parts.igear;
import parts.rdiode;
import parts.ldiode;


void printStackTraceHeader(Part[string] gamedesk, ref File o = stdout){
	foreach(key, val; gamedesk)
		o.write(key ~ ", ");
	
	o.writeln();
}

void printStackTrace(Part[string] gamedesk, ref File o = stdout){
	foreach(key, val; gamedesk)
		o.write(std.conv.to!(string)(val.getRotation()) ~ ", ");

	o.writeln();
}

bool hasNext(IGear[] inputs){
	bool has_next = false;
	
	foreach(i; inputs)
		has_next |= i.hasNext();

	return has_next;
}

void printHelp(){
	writeln(import("README"));
}


int main(string[] args){
	string[] script;

	// Parse args and read input - there is lot of space for improvement
	if (args.length > 1){
		if (args[1] == "--help" || args[1] == "-h")
			printHelp();
		else{
			try{
				script = readText(args[1]).splitlines();
			}catch(Exception){
				stderr.writeln("Can't open '" ~ args[1] ~ "'!");
				return -1;
			}
		}
	}else{
		foreach(int i, string line; lines(stdin)){
			script ~= line;
		}
	}

	IGear[] inputs;
	Part[string] gamedesk;
	PartContainer[] stack;

	// Create objects
	Part tmp, tmp2;
	uint line_num;
	foreach(line; script){
		line = line.strip();
		line_num++;
		
		if (line == "" || line.strip().startsWith("#"))
			continue;

		try{
			if (line.indexOf(":") > 0){
				// Create parts
				if (line.startsWith("gear")){
					tmp = new Gear(line);
				}else if (line.startsWith("igear")){
					tmp = new IGear(line);
					inputs ~= cast(IGear) tmp;
				}else if (line.startsWith("rdiode")){
					tmp = new RDiode(line.strip() ~ ".in");
					tmp2 = new LDiode(line.strip() ~ ".out");
					(cast(RDiode) tmp).setL(cast(LDiode) tmp2);
					(cast(LDiode) tmp2).setR(cast(RDiode) tmp);
					
					if (tmp2.getName() !in gamedesk)
						gamedesk[tmp2.getName()] = tmp2;
				}else if (line.startsWith("ldiode")){
					tmp = new LDiode(line.strip() ~ ".in");
					tmp2 = new RDiode(line.strip() ~ ".out");
					(cast(LDiode) tmp).setR(cast(RDiode) tmp2);
					(cast(RDiode) tmp2).setL(cast(LDiode) tmp);

					if (tmp2.getName() !in gamedesk)
						gamedesk[tmp2.getName()] = tmp2;
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

		if (line == "" || line.strip().startsWith("#"))
			continue;

		if (line.indexOf('-') > 0){
			tmp_pars = line.split("-");
			tmp_pars[0] = tmp_pars[0].strip();
			tmp_pars[1] = tmp_pars[1].strip();

			if (tmp_pars[0] !in gamedesk){
				stderr.writeln("Error on line " ~ std.conv.to!(string)(line_num) ~ " '" ~ line ~ "'");
				stderr.writeln(">> '" ~ tmp_pars[0] ~ "' not defined!");
				return 4;
			}

			if (tmp_pars[1] !in gamedesk){
				stderr.writeln("Error on line " ~ std.conv.to!(string)(line_num) ~ " '" ~ line ~ "'");
				stderr.writeln(">> '" ~ tmp_pars[1] ~ "' not defined!");
				return 4;
			}

			gamedesk[tmp_pars[0]].addNeighbour(gamedesk[tmp_pars[1]]);
			gamedesk[tmp_pars[1]].addNeighbour(gamedesk[tmp_pars[0]]);
		}
	}

	// Main algorithm - emulate signal propagation
	printStackTraceHeader(gamedesk);
	bool first_itteration = true;
	do {
		if (!first_itteration){
			foreach(p; gamedesk)
				p.cleanRotation();
			foreach(i; inputs)
				i.nextState();
		}

		// Signal starts flowing from inputs
		stack = null;
		foreach(input; inputs){
			stack ~= input.begin();
		}

		for (uint act = 0; act < stack.length; act++){
			try{
				stack ~= stack[act].part.react(stack[act]);
			}catch(RotationCollisionException e){
				stderr.writeln("# Error! " ~ e.msg ~ " in collision!");
				writeln();
				printStackTraceHeader(gamedesk, stderr);
				printStackTrace(gamedesk, stderr);
				return 3;
			}
		}

		first_itteration = false;
		printStackTrace(gamedesk);
	} while (hasNext(inputs));

	return 0;
}
