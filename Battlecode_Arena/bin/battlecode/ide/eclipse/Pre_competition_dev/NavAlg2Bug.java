package Pre_competition_dev;

import battlecode.common.*;

public class NavAlg2Bug extends NavigationBase {
	static double distance_when_bugging_occured;

	public static MapLocation navigate_to_destination(MapLocation the_destination){
		if(current_location.equals(destination)) return current_location;
		
		collision_logged_this_turn = false;
		
		if(we_have_changed(the_destination)) {
			initialise_ready_for(the_destination);
			distance_when_bugging_occured = Double.POSITIVE_INFINITY;
		}

		if(current_navigation_state == NavBugState.DIRECT){
			if(i_can_move_directly_towards_destination())
				return location_to_move_to;

			current_navigation_state = NavBugState.CLOCKWISE;
			log_new_collision();
			log_closest_distance();
		}
		
		if(current_navigation_state == NavBugState.CLOCKWISE){
			if(we_have_been_here_already()){
				current_navigation_state = NavBugState.UNREACHABLE;
				return current_location;
			}
			
			if(i_can_move_directly_towards_destination() && i_am_closer_than_i_was_when_i_started_bugging()){
				current_navigation_state = NavBugState.DIRECT;
				log_new_leave_point();
				return location_to_move_to;
			} 
			
			if(we_have_been_here_as_part_of_a_past_collision()){
				current_navigation_state = NavBugState.ANTI_CLOCKWISE;
			}else{
				return follow_wall(RIGHT_HAND);
			}
		}
		
		if(current_navigation_state == NavBugState.ANTI_CLOCKWISE){
			if(we_have_been_here_already()){
				current_navigation_state = NavBugState.UNREACHABLE;
				return current_location;
			}	
			
			if (i_can_move_directly_towards_destination() && i_am_closer_than_i_was_when_i_started_bugging()){
				current_navigation_state = NavBugState.DIRECT;
				log_new_leave_point();
				return location_to_move_to;	
			}
			return follow_wall(LEFT_HAND);
		}
		return current_location; //if all else fails refuse to move
	}
	
	public static void log_closest_distance(){
		distance_when_bugging_occured = Math.min(distance_when_bugging_occured, the_distance_from(current_location,destination));
	}
	
	public static boolean i_am_closer_than_i_was_when_i_started_bugging(){
		return (the_distance_from(current_location,destination) < distance_when_bugging_occured);
	}
}

/**
NavAlg2Bug
1) Drive directly to the target until one of the following occurs:
a) Target is reached.  NavAlg2Bug stops.
b) An obstacle is encountered.  Go to step 2.
2) Perform clockwise circumnavigation until one of the following occurs:
a) Target is reached.  NavAlg2Bug stops.
b) The robot is able to drive towards the target, AND it is closer now than it was when it started bugging: Go to Step 1
c) A Previous H or L point is reached (Not H(i) though) Go to Step 3
d) Robot Reaches H(i): Destination is unreachable
3) Perform counter-clockwise circumnavigation until one of the following 
occurs:
a) Target is reached.  NavAlg2Bug stops.
b) The robot is able to drive towards the target, AND it is closer now than it was when it started bugging: Go to Step 1
d) Robot Reaches H(i): Destination is unreachable
*/