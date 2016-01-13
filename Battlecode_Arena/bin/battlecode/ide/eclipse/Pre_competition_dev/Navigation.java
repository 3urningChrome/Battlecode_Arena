package Pre_competition_dev;

import battlecode.common.*;

public class Navigation extends AusefulClass{
	
	static NavType bugNav = NavType.ONEBUG;
    static Direction[] possible_retreat_directions = { Direction.NORTH, Direction.EAST, Direction.SOUTH, Direction.WEST, 
    		Direction.NORTH_EAST, Direction.SOUTH_EAST, Direction.SOUTH_WEST, Direction.NORTH_WEST };	
	
	public static boolean go_to_rally_point() throws GameActionException{
		MapLocation rally_point = Communications.get_rally_point();
		return go_to(rally_point);
	}
	
	public static boolean go_to(MapLocation destination) throws GameActionException{
		if(DistributedBfs.i_know_how_to_get_to(destination))
			if(move_towards(DistributedBfs.get_direction_to_move_to_path_to(destination)))
				return true;
			
		return move_towards(bugNav.get_direction_of_next_move_towards(destination));
	}
	
	public static boolean move_away_from(MapLocation location) throws GameActionException{
		Direction next_step = current_location.directionTo(location).opposite();
		if(NavigationBase.can_move(next_step)){
			rc.move(next_step);
			return true;
		}
		return false;
	}
	
	public static boolean move_towards(Direction next_step) throws GameActionException{
			if(NavigationBase.can_move(next_step)){
				rc.move(next_step);
				return true;
			}
			return false;
	}
	
	public static boolean retreat() throws GameActionException{
        for (Direction retreat_direction : possible_retreat_directions)
			if(NavigationBase.can_move(retreat_direction)){
				rc.move(retreat_direction);
				return true;
			}
        return false;
	}
	
	public static void set_life_insurance_policy(Safety new_policy){
		NavigationBase.life_insurance_policy = new_policy;
	}
}
