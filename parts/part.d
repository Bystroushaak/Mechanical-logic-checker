module parts.part;

public enum Rotation {Right, Left, None, Any};

public class Part{
	private bool checked = false;
	private string name;
	private uint gear_num;
	private Rotation r = Rotation.None;

	private Part[] neigbours;

	public string getName(){
		return this.name;
	}
	public void setName(string new_name){
		this.name = new_name;
	}

	public bool isChecked(){
		return this.checked;
	}
	public void setChecked(bool checked){
		this.checked = checked;
	}

	public void addNeighbour(Part neigbour){
		neigbours ~= neigbour;
	}

	public abstract Part[] react(Rotation new_r);
}
