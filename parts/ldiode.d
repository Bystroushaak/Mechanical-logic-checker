module parts.ldiode;

import std.string;

import parts.part;
import parts.gear;
import parts.rdiode;

public class LDiode : Gear {
	private RDiode rdiode;

	this(string i){
		super(i, i.split(":")[0].strip());
	}

	public void setR(RDiode rdiode){
		this.rdiode = rdiode;
	}

	public override PartContainer[] react(PartContainer pc){
		PartContainer[] output = super.react(pc);

		if (this.r == Rotation.Left){
			this.rdiode.cleanRotation();

			PartContainer p;
			p.from = this;
		    p.rotation = Rotation.Right; // let rdiode rotate to left (by giving her right neighbour)

		    output ~= this.rdiode.react(p);
		}

		return output; 
	}
}