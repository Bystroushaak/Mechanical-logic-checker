module parts.part;

import std.conv;

public enum Rotation {Right, Left, None, Any};

public struct PartContainer{
	Part part;
	Rotation rotation;
}

public abstract class Part{
	protected bool rotating = false;
	protected string name;
	protected uint gear_num;
	protected Rotation r = Rotation.None;
	protected string type;

	protected Part[] neighbours;

	public string getName(){
		return this.name;
	}
	public void setName(string new_name){
		this.name = new_name;
	}

	public bool isRotating(){
		return this.rotating;
	}

	public Rotation getRotation(){
		return this.r;
	}

	public void addNeighbour(Part neighbour){
		this.neighbours ~= neighbour;
	}

	protected Rotation reaction(Rotation);
	
	public PartContainer[] react(Rotation neigh_r){
		PartContainer[] output;

		if (!this.rotating){
			this.r = this.reaction(neigh_r);

			PartContainer p;
			foreach(n; this.neighbours){
				p.part = n;
				p.rotation = this.r;
				
				output ~= p;
			}

			this.rotating = true;
		}else{
			if (this.reaction(neigh_r) != this.r && this.r != Rotation.Any)
				throw new RotationCollisionException(this.name);
		}

		return output;
	}

	public string toString(){
		string rotation;

		if (this.rotating)
			rotation = "Rotation: " ~ std.conv.to!(string)(this.r) ~ "\n";
		
		return "Name:\t  " ~ this.type ~ ":" ~ this.name ~ "\n" ~
			   "Rotating: " ~ std.conv.to!(string)(this.rotating) ~ "\n" ~
			   rotation;
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