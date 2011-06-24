module parts.part;

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

	public void addNeighbour(Part neighbour){
		this.neighbours ~= neighbour;
	}

	protected abstract Rotation reaction(Rotation);
	
	public PartContainer[] react(Rotation neigh_r){
		PartContainer[] output;

		if (!this.rotating){
			this.r = this.reaction(neigh_r);

			PartContainer p;
			foreach(n; this.neighbours){
				p.part = n;
				p.rotation = this.r;
			}
		}else{
			if (this.reaction(neigh_r) != this.r && this.r != Rotation.Any)
				throw new RotationCollisionException(this.name);
		}

		return output;
	}
}

public class PartDefinitionException : Exception{
	this(string msg){
		super(msg);
	}
}

public class RotationCollisionException : Exception{
	this(string msg){
		super(msg);
	}
}