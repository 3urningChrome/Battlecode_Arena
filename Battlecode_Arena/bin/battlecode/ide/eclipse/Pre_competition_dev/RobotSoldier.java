package Pre_competition_dev;

import battlecode.common.GameActionException;
import battlecode.common.RobotController;

public class RobotSoldier extends AusefulClass {
	public static void loop(RobotController robot_controller){
		AusefulClass.init(robot_controller);
		
		while(true){
			try{
				turn();
			} catch (Exception e){
				e.printStackTrace();
			}
			rc.yield();
		}
	}

	private static void turn() throws GameActionException {
		current_location = rc.getLocation();
		Supply.normalise_supply();
		
		//should we fire, if this stop us moving?
		FireControl.shoot_closest_enemy();
		
		if (Scanner.nearby_enemies.length > 0){
			
			//How to decide which one?
			//probably a job_role... enum?
			//like ducks harass. 
			//would allow easy swaps to weight of press/kite etc
			//in which case, the whole turn could be moved into it..
			//or maybe keep out non-move & shoot stuff.
			
			
			//press
			if(Navigation.go_to(Scanner.find_closest_enemy().location))
				return;
			
			//kite
			if(Navigation.move_away_from(Scanner.find_closest_enemy().location))
				return;
			
			//retreat
			if(Navigation.retreat())
				return;
			
		} else{
			Navigation.go_to_rally_point();
		}
	}
}

/**
update position
supply
shoot
Move {kite, press, stop, retreat}
processing
*/