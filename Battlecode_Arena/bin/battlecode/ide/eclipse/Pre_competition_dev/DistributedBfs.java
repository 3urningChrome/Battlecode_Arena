package Pre_competition_dev;

import battlecode.common.*;

public class DistributedBfs extends AusefulClass {
	
	static int turn_BFS_data_last_updated = 0;
	static MapLocation bfs_destination;
	static boolean i_can_process = false;
	static final Direction[] DIRECTIONS = {Direction.NORTH_EAST, Direction.SOUTH_EAST, Direction.SOUTH_WEST, Direction.NORTH_WEST,Direction.NORTH, Direction.EAST, Direction.SOUTH, Direction.WEST};
	static Direction route_direction = Direction.NONE;
	
	private static void update_local_variables() throws GameActionException{
		if(turn_BFS_data_last_updated < Clock.getRoundNum()){
			bfs_destination = Communications.get_current_BFS_destination();
			i_can_process = Communications.can_i_process_BFS();
			turn_BFS_data_last_updated = Clock.getRoundNum();
			route_direction = Direction.NONE;
		}
	}
			
	private static void mark_route(MapLocation from_location, Direction move_in_direction) throws GameActionException{		
		if(Communications.has_no_BFS_route(from_location)){
			if(it_is_navigatable(from_location)){
				Communications.set_BFS_route(from_location,move_in_direction);
				Communications.add_additional_BFS_route(from_location);
			}
		}
	}
	
	private static boolean it_is_navigatable(MapLocation is_this_location_navigatable){
		TerrainTile terrain = rc.senseTerrainTile(is_this_location_navigatable);
		
		if(terrain == TerrainTile.VOID || terrain == TerrainTile.OFF_MAP)
			return false;
		
		return true;
	}
		
	private static boolean i_have_a_route_to(MapLocation destination) throws GameActionException{
		update_local_variables();
		if (destination.equals(bfs_destination))
			return true;
		
		return false;
	}
	
	public static boolean i_know_how_to_get_to(MapLocation destination) throws GameActionException{
		if(i_have_a_route_to(destination)){
			route_direction = Communications.next_BFS_move_direction();
			if(route_direction == Direction.NONE || route_direction == Direction.OMNI)
				return false;
			return true;
		}	
		return false;
	}	
	
	public static Direction get_direction_to_move_to_path_to(MapLocation destination){
		//check i_know_how_to_get_to(destination) before calling this
		return route_direction;
	}
	
	public static void process_BFS() throws GameActionException{
		update_local_variables();
		
		if(i_can_process){
			MapLocation to_location = Communications.pop_next_BFS();
			
			for(Direction direction:DIRECTIONS){
				MapLocation from_location = to_location.add(direction);
				Direction head_in_direction = direction.opposite();
				mark_route(from_location,head_in_direction);
			}
		}
	}	
	
	public static void initiate_new_BFS(MapLocation destination) throws GameActionException{
		if (i_have_a_route_to(destination)){
			return;
		}
		Communications.set_new_BFS_destination(destination);
		i_can_process = false;
		return;
	}	
}

/**
BFS - How to?
1) Has Destination changed?
a) No? goto 2
b) reset Start_time
c) set destination to new destination
d) Quit - Work may have been done on old dest this turn. must wait until next.

2) pop next Location from Queue-Head
a) for each adjacent direction goto 3

3) adjacent Square:
a) if already calculated for this destination, then exit
b) if void or off_map then exit
c) update location's destination
d) add Location to tail of queue
*/