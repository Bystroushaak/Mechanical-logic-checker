module parts.gear;

import std.string;
import parts.part;

public class Gear : Part{
	this(){} // kinky :S
	
	// Parse records defined as "Type : name"
	this(string line){
		if (line.indexOf(':') <= 0)
			throw new PartDefinitionException("No definition!");
		
		string[] tmp = line.split(":");

		if (tmp[0].strip().tolower() != "gear")
			throw new PartDefinitionException("Unknown part '" ~ tmp[0].strip() ~ "'");

		this.name = tmp[1].strip().tolower();
	}

	private Rotation reaction(Rotation nr){
		Rotation[Rotation] table;

		table[Rotation.Left]  = Rotation.Right;
		table[Rotation.Right] = Rotation.Left;
		table[Rotation.None]  = Rotation.None;
		table[Rotation.Any]   = Rotation.Any;

		return table[nr];
	}
}