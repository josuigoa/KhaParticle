package systems.particle.modifiers;

import kha.math.Vector3;
import kha.scene.Spline;
import systems.particle.IParticleModifier;
import systems.particle.Particle;

enum ScaleType {
	SCALE_UP;
	SCALE_DOWN;
	SCALE_UP_DOWN;
	SCALE_DOWN_UP;
	CURVE;
}

/**
 * ...
 * @author Sidar Talei
 */
class ScaleModifier implements IParticleModifier
{

	public var type:ScaleType;
	public var scalar:Float;
	public var curve:Spline;
	
	public var min:Float = 0;
	public var max:Float = 0;
	
	private var value:Vector3;
	
	public function new(st:ScaleType, scalar:Float = 1, ?curve:Spline, minValue:Float=0,maxValue:Float=0) 
	{
		this.curve = curve;
		type = st;
		this.scalar = scalar;
		min = minValue;
		max = maxValue;
	}
	
	/* INTERFACE systems.particle.IParticleModifier */
	
	public function processParticle(p:Particle):Void 
	{
		
		
		var ratio:Float = p.lifeTime / p.life;
		switch(type)
		{
			case ScaleType.SCALE_UP:
				p.scale = ratio * scalar;
			case ScaleType.SCALE_DOWN:
				p.scale = (1 - ratio) * scalar;
			case ScaleType.SCALE_UP_DOWN:
				if (ratio <= .5)
				p.scale = ratio * scalar;
				else
				p.scale = (1 - ratio) * scalar;
			case ScaleType.SCALE_DOWN_UP:
				if (ratio >= .5)
				p.scale = ratio * scalar;
				else
				p.scale = (1 - ratio) * scalar;
			case ScaleType.CURVE:
				value = curve.constantSpeedSpline(ratio);
				value.y =  value.y > 1 ? 1:value.y;
				value.y =  value.y < 0 ? 0:value.y;
				p.scale = (value.y * (max - min)) + min ;
			 
		}
	}
	
}