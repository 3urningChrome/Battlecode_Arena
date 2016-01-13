package Pre_competition_dev;

import battlecode.common.*;

public enum NavType {
	ONEBUG{
		public Direction get_direction_of_next_move_towards(MapLocation destination){
			return NavOneBug.get_direction_of_next_move_towards(destination);
		}
	},
	
	ALG2{
		public Direction get_direction_of_next_move_towards(MapLocation destination){
			return NavAlg2Bug.get_direction_of_next_move_towards(destination);
		}		
	};
	
	public Direction get_direction_of_next_move_towards(MapLocation destination){
		//must override this.
		return Direction.NONE;
	}	
}
