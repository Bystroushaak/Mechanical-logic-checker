module parts.rdiode;

import std.string;

import parts.part;
import parts.gear;
import parts.ldiode;

public class RDiode : Gear {
	private LDiode ldiode;
	
	this(string i){
		super(i, i.split(":")[0].strip());
	}

	public void setL(LDiode ldiode){
		this.ldiode = ldiode;
	}

	public override PartContainer[] react(PartContainer pc){
		PartContainer[] output = super.react(pc);

		if (this.r == Rotation.Right){
			this.ldiode.cleanRotation();

			PartContainer p;
			p.from = this;
			p.rotation = Rotation.Left; // let ldiode rotate to right (by giving her left neighbour)

			output ~= this.ldiode.react(p);
		}
		
		return output;
	}
}