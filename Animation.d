module Animation;
private import Sofu.Sofu;

private import ImageResource;
private import Vector;

class Animation {
	this(Sofu.Map.Map data) {
	    _time=0;
	    _counter=0;
	    _length=0;
	    foreach(SofuObject object; data.list("Sequence")) {
	        Value value = object.asValue();
	       _anim ~= loadImage(value.toUTF8());
	    }
		try {
		    _length=data.value("Framelength").toDouble();
		}
		catch (AttributeDoesNotExistException x) {
			_length=data.value("Frametime").toDouble();	
		}
	}
	
	double length() {
		return _length*_anim[].length;
	}
		
	void next(double frametime) {
		if (_anim.length==1) {
			return;
		}
		_time+=frametime;
		if (_time>=_length) {
			_time-=_length;
			if (++_counter>=_anim.length) {
				_counter=0;
			}
		}
	}
	void reset() {
		_counter=0;
		_time=0;
	}
	Image get() {
		return _anim[_counter];
	}
        Image getMirrored() {
            return _anim[_counter].mirrored();
        }
	
	private:
	Image[] _anim;
	double _length;
	int _counter;
	double _time;
	

}
