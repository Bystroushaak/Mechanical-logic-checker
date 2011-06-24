module parts.igear;

import std.string;
import parts.part;
import parts.gear;

public class IGear : Gear{
	private Rotation states[];
	private uint actual_state;

	this(string line){
		if (line.indexOf(':') <= 0)
			throw new PartDefinitionException("No definition!");
		
		string[] tmp = line.split(":");

		if (tmp[0].strip().tolower() != "igear")
			throw new PartDefinitionException("Unknown part '" ~ tmp[0].strip() ~ "'");

		//this.name = tmp[1].strip().tolower();
	}

	public void nextState(){
		 
	}
}