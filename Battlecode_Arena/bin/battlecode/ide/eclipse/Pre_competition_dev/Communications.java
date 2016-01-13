package Pre_competition_dev;

import battlecode.common.*;

public class Communications extends AusefulClass{
	
	//Variables:
	public static int offset_x;
	public static int offset_y;
	public static final int MAX_BOARD_SIZE = GameConstants.MAP_MAX_WIDTH * GameConstants.MAP_MAX_HEIGHT;
	
	//channels:
	private static final int DESTINATION_FOR_CURRENT_BFS = 0;
	private static final int START_TIME_FOR_CURRENT_BFS = 1;
	private static final int HEAD_OF_BFS_QUEUE = 2;
	private static final int TAIL_OF_BFS_QUEUE = 3;
	private static final int RALLY_POINT = 4;
	private static final int START_RANGE_OF_BFS_QUEUE = 100;
	private static final int START_RANGE_OF_BFS_LOCATION_TIMESTAMPS     = (MAX_BOARD_SIZE) + START_RANGE_OF_BFS_QUEUE;
	private static final int START_RANGE_OF_BFS_PATHS                   = START_RANGE_OF_BFS_LOCATION_TIMESTAMPS + MAX_BOARD_SIZE;
	

	
	public static void initialise_comms(){
		//need an offset. to convert unique value back into a maplocation. 
		//can work out this better, coz we know enemy hq too. therefore centre.
		//however 2016 this might not be the case. should know 'HQ' point.
		offset_x = friendly_HQ.x - GameConstants.MAP_MAX_WIDTH;
		offset_y = friendly_HQ.y - GameConstants.MAP_MAX_HEIGHT;
	}
	
	private static MapLocation convert_message_into_MapLocation(int broadcast_message) {
        int x = offset_x + broadcast_message % GameConstants.MAP_MAX_WIDTH;
        int y = offset_y + broadcast_message / GameConstants.MAP_MAX_WIDTH;
        return new MapLocation(x, y);	
	}
	
	private static int convert_MapLocation_to_integer(MapLocation location){
		return GameConstants.MAP_MAX_WIDTH * (location.y - offset_y) + (location.x - offset_x);
	}
	
	public static MapLocation get_current_BFS_destination() throws GameActionException{
		return convert_message_into_MapLocation(rc.readBroadcast(DESTINATION_FOR_CURRENT_BFS));
	}
	
	public static void set_new_BFS_destination(MapLocation destination) throws GameActionException{
		rc.broadcast(START_TIME_FOR_CURRENT_BFS, Clock.getRoundNum()+1);
		rc.broadcast(DESTINATION_FOR_CURRENT_BFS, convert_MapLocation_to_integer(destination));
		rc.broadcast(HEAD_OF_BFS_QUEUE, START_RANGE_OF_BFS_QUEUE);
		rc.broadcast(TAIL_OF_BFS_QUEUE, START_RANGE_OF_BFS_QUEUE);
		set_BFS_route(destination, Direction.NONE);
		rc.broadcast(START_RANGE_OF_BFS_LOCATION_TIMESTAMPS + convert_MapLocation_to_integer(destination), Clock.getRoundNum()+1); //hack to allow this one to get set
	}
	
	public static boolean can_i_process_BFS() throws GameActionException{
		if(Clock.getRoundNum() < rc.readBroadcast(START_TIME_FOR_CURRENT_BFS))
			return false;
		
		if(rc.readBroadcast(HEAD_OF_BFS_QUEUE) >=  rc.readBroadcast(TAIL_OF_BFS_QUEUE))
			return false;	
		
		return true;
	}
	
	public static MapLocation pop_next_BFS() throws GameActionException{
		int head_position = rc.readBroadcast(HEAD_OF_BFS_QUEUE);
		rc.broadcast(HEAD_OF_BFS_QUEUE, head_position+1);
		int next_bfs_message = rc.readBroadcast(head_position);

		return convert_message_into_MapLocation(next_bfs_message);
	}
	
	public static boolean has_no_BFS_route(MapLocation check_location) throws GameActionException{
		int position_of_check_location = convert_MapLocation_to_integer(check_location);
		
		int location_time_stamp = rc.readBroadcast(START_RANGE_OF_BFS_LOCATION_TIMESTAMPS + position_of_check_location);
		
		return location_time_stamp < rc.readBroadcast(START_TIME_FOR_CURRENT_BFS);
	}
	
	public static void set_BFS_route(MapLocation from_location, Direction head_in_direction) throws GameActionException{
		int position_of_location = convert_MapLocation_to_integer(from_location);
		rc.broadcast(START_RANGE_OF_BFS_LOCATION_TIMESTAMPS + position_of_location, Clock.getRoundNum());
		rc.broadcast(START_RANGE_OF_BFS_PATHS + position_of_location, head_in_direction.ordinal());
	}
	
	public static void add_additional_BFS_route(MapLocation add_this_location_to_queue) throws GameActionException{
		int current_tail_position = rc.readBroadcast(TAIL_OF_BFS_QUEUE);
		rc.broadcast(current_tail_position,convert_MapLocation_to_integer(add_this_location_to_queue));
		rc.broadcast(TAIL_OF_BFS_QUEUE, current_tail_position+1);
	}
	
	public static Direction next_BFS_move_direction() throws GameActionException{
		int current_integer_position = convert_MapLocation_to_integer(current_location);
		int time_stamp = rc.readBroadcast(START_RANGE_OF_BFS_LOCATION_TIMESTAMPS + current_integer_position);
		
		if(time_stamp < rc.readBroadcast(START_TIME_FOR_CURRENT_BFS))
			return Direction.NONE;

		return Direction.values()[rc.readBroadcast(START_RANGE_OF_BFS_PATHS + current_integer_position)];
	}

	public static MapLocation get_rally_point() throws GameActionException {
		return convert_message_into_MapLocation(rc.readBroadcast(RALLY_POINT));
	}

	public static void set_rally_point(MapLocation rally_point) throws GameActionException {
		rc.broadcast(RALLY_POINT,convert_MapLocation_to_integer(rally_point));
	}
}
