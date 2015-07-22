import std.stdio;
import std.container.array;
import std.random;

import Dgame.Window;
import Dgame.Graphic;
import Dgame.Graphic.Color;
import Dgame.System.Keyboard;
import Dgame.Math;
import Dgame.Graphic.Text;
import Dgame.System.Font;

import gamestate;
import player;
import raindrop;
import direction;
import inputhandler;

class Game {
	private static const int MAX_RAINDROPS = 25;
	
	private static int windowHeight;
	private static int windowWidth;
	
	private static Window *window;		
	private GameState *gameState;
	
	private static Player player;
	private static RainDrop[MAX_RAINDROPS] rainDrops;
	
	private Event event;
	private Direction playerDirection; 	
	
	private static Font arial;
	private static Text scoreText;
	private static Text livesText;
	
	private int score;
	
	this(ref Window window) {
		this.window = &window;
		this.gameState = gameState;
		
		Size windowSize = this.window.getSize();
		windowWidth = windowSize.width;
		windowHeight = windowSize.height;
		
		player = Player();
		player.create(windowWidth, windowHeight);
		
		playerDirection = Direction.STOP;
		
		for(int i = 0; i < MAX_RAINDROPS; i++) {
			rainDrops[i] = RainDrop();
			rainDrops[i].create(windowWidth, windowHeight);
		}
		
		score = 0;
		
		arial = Font("arial.ttf", 22);
		scoreText = new Text(arial);
		livesText = new Text(arial);
	}
	
	public void run(ref GameState gameState) {
		this.gameState = &gameState;
		while(*this.gameState == GameState.PLAYING) {
			this.loop();
		}
	}	
	
	private void loop() {
		window.clear();
		
		InputHandler.handleGameInput(event, *gameState, *window, player, playerDirection);
		
		moveRainDrops();
		
		checkCollisions();
		
		draw();
		
		window.display();
	}
	
	private void moveRainDrops() {
		for(int i = 0; i < MAX_RAINDROPS; i++) {
			rainDrops[i].fall(score);
		}
		
		auto randonRainDrop = uniform(0, MAX_RAINDROPS);
		if (rainDrops[randonRainDrop].visible == false) {
			// 70% chance of being visible
			auto visibleChance = dice(30, 70);
			if (visibleChance == 1) {
				rainDrops[randonRainDrop].reset();
			}
		}
	}
	
	private void checkCollisions() {
		for(int i = 0; i < MAX_RAINDROPS; i++) {
			if (rainDrops[i].visible) {
				if (rainDrops[i].collideWith(player.sprite)) {
					rainDrops[i].visible = false;
					player.lives--;
					
					if (player.lives == 0) {
						*gameState = GameState.LOST;
					}
				}
			}
		}
	}
	
	private void draw() {
		player.draw(*window);
		
		for(int i = 0; i < MAX_RAINDROPS; i++) {
			rainDrops[i].draw(*window);
		}
				
		scoreText.format("Score: %s", score);
		scoreText.setPosition(10, 10);
		window.draw(scoreText);
		
		livesText.format("Lives: %s", player.lives);
		livesText.setPosition(10, windowHeight - 30);
		window.draw(livesText);
	}
}