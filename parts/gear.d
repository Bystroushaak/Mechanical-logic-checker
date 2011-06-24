module parts.gear;

import std.string;

import parts.part;

public class Gear : Part{
	this(){} // kinky :S
	
	// Parse records defined as "Type : name"
	this(string line){
		this.type = "gear";
		
		if (line.indexOf(':') <= 0)
			throw new PartDefinitionException("No definition!");
		
		string[] tmp = line.split(":");

		if (tmp[0].strip().tolower() != this.type)
			throw new PartDefinitionException("Unknown part '" ~ tmp[0].strip() ~ "'");

		this.name = tmp[1].strip().tolower();
	}

	protected Rotation reaction(Rotation nr){
		Rotation[Rotation] table;

		table[Rotation.Left]  = Rotation.Right;
		table[Rotation.Right] = Rotation.Left;
		table[Rotation.None]  = Rotation.None;
		table[Rotation.Any]   = Rotation.Any;

		return table[nr];
	}
}