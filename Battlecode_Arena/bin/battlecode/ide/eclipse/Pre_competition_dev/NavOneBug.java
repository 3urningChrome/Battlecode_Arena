package Pre_competition_dev;

import battlecode.common.*;

public class NavOneBug extends NavigationBase {
	static double closest_distance;
	
	public static MapLocation navigate_to_destination(MapLocation the_destination){
		if(current_location.equals(destination)) return current_location;
		
		collision_logged_this_turn = false;
		
		if(we_have_changed(the_destination)) {
			initialise_ready_for(the_destination);
			closest_distance = Double.POSITIVE_INFINITY;
		}

		if(current_navigation_state == NavBugState.DIRECT){
			if(i_can_move_directly_towards_destination())
				return location_to_move_to;

			current_navigation_state = NavBugState.CLOCKWISE;
			log_new_collision();
		}
		
		if(current_navigation_state == NavBugState.CLOCKWISE){
			if(we_have_been_here_already()){
				current_navigation_state = NavBugState.UNREACHABLE;
				return current_location;
			}
			
			if(i_can_move_directly_towards_destination()){
				current_navigation_state = NavBugState.ANTI_CLOCKWISE;
				log_new_collision();
			} else{
				log_closest_distance();
				return follow_wall(RIGHT_HAND);
			}
		}
		
		if(current_navigation_state == NavBugState.ANTI_CLOCKWISE){
			if(we_have_been_here_already()){
				current_navigation_state = NavBugState.UNREACHABLE;
				return current_location;
			}	
			
			if (i_am_closer_than_i_have_ever_been() && i_can_move_directly_towards_destination()){
				current_navigation_state = NavBugState.DIRECT;
				return location_to_move_to;	
			}
			
			log_closest_distance();
			return follow_wall(LEFT_HAND);
		}
		return current_location; //if all else fails refuse to move
	}
	
	public static void log_closest_distance(){
		closest_distance = Math.min(closest_distance, the_distance_from(current_location,destination));
	}
	
	
	public static boolean i_am_closer_than_i_have_ever_been(){
		return (the_distance_from(current_location,destination) < closest_distance);
	}
}

/**
One Bug
1) Drive directly to the target until one of the following occurs:
a) Target is reached.  OneBug stops.
b) An obstacle is encountered.  Go to step 2.
2) Perform clockwise circumnavigation until one of the following occurs:
a) Target is reached.  OneBug stops.
b) The robot is able to drive towards the target.  Go to step 3.
c) The robot completes circumnavigation around the blocking  
obstacle.  The target is unreachable and OneBug stops.
3) Perform counter-clockwise circumnavigation until one of the following 
occurs:
a) Target is reached.  OneBug stops.
b) The robot is at a point which is closer to the target than any  
previously visited and it is able to drive towards the target.  Go to 
step 1.
c) The robot completes circumnavigation around the blocking  
obstacle.  The target is unreachable and OneBug stops.
*/