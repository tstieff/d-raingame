import std.stdio;
import std.random;

import Dgame.Graphic;

struct RainDrop {
	private static const float FALL_VELOCITY_INC = 0.025;
	private static const float MAX_VELOCITY = 8.0;
	private static const int SCORE_INC = 2;
	
	private static int windowWidth;
	private static int windowHeight;
	
	private static Texture texture;
	private Sprite sprite;
	
	public bool visible;
	private int spriteY;	
	private float currentVelocity = 0;
	
	public void create(int windowWidth, int windowHeight) {
		this.windowWidth = windowWidth;
		this.windowHeight = windowHeight;
		
		Surface surface = Surface("res/sprite/raindrop.png");
		texture = Texture(surface);
		sprite = new Sprite(texture);
		
		spriteY = uniform(20, 220);		
		auto randomX = uniform(0, windowWidth);
		
		sprite.setPosition(randomX, spriteY);
		visible = false;
	}
	
	public void fall(ref int score) {
		if (visible) {
			currentVelocity += FALL_VELOCITY_INC;
			
			if (currentVelocity > MAX_VELOCITY) {
				currentVelocity = MAX_VELOCITY;
			}
			
			sprite.move(0, currentVelocity);
			
			if (sprite.y() > windowHeight) {
				visible = false;
				currentVelocity = 0;
				
				score += SCORE_INC;
			}
		}
	}
	
	public void reset() {
		auto randomX = uniform(0, windowWidth);
		spriteY = uniform(20, 220);
		
		currentVelocity = 0;
		sprite.setPosition(randomX, spriteY);
		visible = true;
	}
	
	public bool collideWith(ref Sprite sprite) {
		bool colliding = false;
		
		if (this.sprite.getClipRect().intersects(sprite.getClipRect())) {
			colliding = true;
		}
		
		return colliding;
	}
	
	public void draw(ref Window window) {
		if (visible) {
			window.draw(sprite);
		}
	}
}