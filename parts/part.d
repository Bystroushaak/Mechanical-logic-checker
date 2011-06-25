module parts.part;

import std.conv;

public enum Rotation {Right, Left, None, Any};

public struct PartContainer{
	Part part;
	Part from;
	Rotation rotation;
}

public abstract class Part{
	protected bool rotating = false;
	protected string name;
	protected Rotation r = Rotation.None;
	protected string type;

	protected Part[] neighbours;

	public string getName(){
		return this.name;
	}
	public void setName(string new_name){
		this.name = new_name;
	}

	public string getType(){
		return this.type;
	}

	public bool isRotating(){
		return this.rotating;
	}

	public Rotation getRotation(){
		return this.r;
	}

	public void cleanRotation(){
		this.rotating = false;
		this.r = Rotation.None;
	}

	public void addNeighbour(Part neighbour){
		this.neighbours ~= neighbour;
	}

	protected Rotation reaction(Rotation);
	
	public PartContainer[] react(PartContainer pc){
		PartContainer[] output;

		if (!this.rotating){
			this.r = this.reaction(pc.rotation);

			PartContainer p;
			foreach(n; this.neighbours){
				p.part = n;
				p.rotation = this.r;
				p.from = this;
				
				output ~= p;
			}

			this.rotating = (this.r != Rotation.None);
		}else{
			if (this.reaction(pc.rotation) != this.r && this.r != Rotation.Any)
				throw new RotationCollisionException(
					this.name ~ ":" ~ std.conv.to!(string)(this.r) ~ " with " ~
					pc.from.getName() ~ ":" ~
					std.conv.to!(string)(pc.from.getRotation())
				);
		}

		return output;
	}

	public string toString(){
		string rotation, neighbours;

		if (this.rotating)
			rotation = "Rotation: " ~ std.conv.to!(string)(this.r) ~ "\n";

		foreach(p; this.neighbours)
			neighbours ~= "Neighbour: " ~ p.getName() ~ "\n";
		
		return "Name:\t  " ~ this.type ~ ":" ~ this.name ~ "\n" ~
			   "Rotating: " ~ std.conv.to!(string)(this.rotating) ~ "\n" ~
			   rotation ~ neighbours;
	}
}

public class PartException : Exception{
	this(string msg){
		super(msg);
	}
}

public class PartDefinitionException : PartException{
	this(string msg){
		super(msg);
	}
}

public class RotationCollisionException : PartException{
	this(string msg){
		super(msg);
	}
}

public class UnknownPartParameterException : PartException{
	this(string msg){
		super(msg);
	}
}