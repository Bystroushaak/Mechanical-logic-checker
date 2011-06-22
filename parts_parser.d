import std.string;
import std.ctype;

import std.file;
import std.stdio;

private const char COMMENT = '#';

class PartException:Exception{
	this(string msg){
		super(msg);
	}
}

class PartNameNotFound:PartException{
	this(string msg){
		super(msg);
	}
}

class SyntaxErrorException:PartException{
	this(string msg){
		super(msg);
	}
}

enum State{LEFT, RIGHT, NONE, ANY};

class Part{
	private string name;
	private bool container = false;
	Part[] subparts;
	
	this(string input){
		this(input.tolower().splitlines());
	}
	
	this(string[] input){
		this.checkDefinition(input);
		
		string[] cleaned = this.removeCrap(input);
		
		// Parse name
		if (cleaned[0].indexOf(';') >= 0 || cleaned[0].indexOf(',') >= 0)
			throw new PartNameNotFound("Can't find part name!");
		else{
			this.name = cleaned[0];
			cleaned = cleaned[1 .. $];
		}
		
		// Parse
		if (cleaned[0].indexOf(':') < 0 && cleaned[0].indexOf(';') < 0){ // subparts
			this.container = true;
			
			string[] subparts_names = cleaned[0].split(",");
			
			cleaned = cleaned[1 .. $];
			foreach (part_name; subparts_names){
				part_name = part_name.strip();	// clean names
				
				this.subparts ~= new Part(part_name ~ this.filterSubparts(part_name, cleaned));
			}
		}else{
			writeln(cleaned);
		}
	}
	
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
	
	private void checkDefinition(ref string[] list){
		int line_num = 0;
		
		foreach(string line; list){
			line_num++;
			
			if (line.startsWith(COMMENT))
				continue;
					
			if (line.indexOf(COMMENT) > 0)
				line = line[0 .. line.indexOf(COMMENT)];
			
			foreach(dchar c; line){
				if (! (isalnum(c) || c == ';' || c == ',' || c == '\t' || c == ' ' || c == ':' || c == '.' || c == '-'))
					throw new SyntaxErrorException("Bad syntax on line " ~ std.conv.to!(string)(line_num) ~ ":\n>> " ~ line);
			}
		}
	}
	
	private string[] filterSubparts(string name, string[] input){
		string[] output;
		
		foreach(line; input){
			if (line.startsWith(name))
				output ~= line;
		}
		
		return output;
	}
}



void main(){
	Part ldiode = new Part(std.file.readText("parts/ldiode"));
	
	//~ foreach(line; result)
		//~ writeln(line);
	
}