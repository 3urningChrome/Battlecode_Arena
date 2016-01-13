package Pre_competition_dev;

import battlecode.common.*;

//cheers Duck,I like this idea.
public enum Safety {
	NONE{

	},
	
	AVOID_ALL_ENEMY{
		public boolean says_this_move_will_shorten_your_life(MapLocation location){
			if(tower_can_fire_at(location)) 
				return true;
			
			if(HQ_can_fire_at(location)) 
				return true;			
			
			if(enemy_can_fire_at(location))
				return true;
			
			return false;
		}	
	},
	
	AVOID_TOWERS_AND_HQ{
		public boolean says_this_move_will_shorten_your_life(MapLocation location){
			if(tower_can_fire_at(location)) 
				return true;
			
			if(HQ_can_fire_at(location)) 
				return true;
			
			return false;
		}	
	},
	
	AVOID_HQ{
		public boolean says_this_move_will_shorten_your_life(MapLocation location){
			if(HQ_can_fire_at(location)) 
				return true;		
			
			return false;
		}			
	},
	ADRENALINE_JUNKIE{
		public boolean says_this_move_will_shorten_your_life(MapLocation location){
			if(HQ_can_fire_at(location)) 
				return true;	
			
			if(tower_can_fire_at(location))
				return true;

			if(enemy_can_fire_at(location))
				return false;			
			
			return true;
		}			
	};
	
	public boolean says_this_move_will_shorten_your_life(MapLocation location){
		return false;
	}	
	
	private static boolean tower_can_fire_at(MapLocation location){
		for(MapLocation tower:Scanner.scan_for_tower_locations())
			if(location.distanceSquaredTo(tower) <= RobotType.TOWER.attackRadiusSquared)
				return true;
		
		return false;
	}
	
	private static boolean HQ_can_fire_at(MapLocation location){
        if (location.distanceSquaredTo(Scanner.enemy_HQ) <= 52)
            switch (Scanner.scan_for_tower_locations().length) {
                case 6:
                case 5:
                    // enemy HQ has range of 35 and splash
                    if (location.add(location.directionTo(Scanner.enemy_HQ)).distanceSquaredTo(Scanner.enemy_HQ) <= 35) 
                    	return true;
                    break;

                case 4:
                case 3:
                case 2:
                    // enemy HQ has range of 35 and no splash
                    if (location.distanceSquaredTo(Scanner.enemy_HQ) <= 35) 
                    	return true;
                    break;

                case 1:
                case 0:
                default:
                    // enemyHQ has range of 24;
                    if (location.distanceSquaredTo(Scanner.enemy_HQ) <= 24) 
                    	return true;
                    break;
            }		
		return false;
	}
	
	private static boolean enemy_can_fire_at(MapLocation location) {
		for(RobotInfo enemy_robot:Scanner.scan_for_enemy()){
			if(enemy_robot.type == RobotType.HQ)
				continue;
			if(enemy_robot.type == RobotType.TOWER)
				continue;
			
//TODO special case Launcher
//TODO Special case MISSILE
			if(enemy_robot.location.distanceSquaredTo(location) <= enemy_robot.type.attackRadiusSquared)
				return true;
		}
		return false;
	}	
}
