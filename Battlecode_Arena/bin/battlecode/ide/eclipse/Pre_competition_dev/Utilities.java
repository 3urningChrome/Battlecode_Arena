package Pre_competition_dev;

import battlecode.common.*;

public class Utilities extends AusefulClass{
	
	public static RobotInfo find_closest_RobotInfo(RobotInfo[] list_of_robot_infos){
		double range = Double.POSITIVE_INFINITY; 
		RobotInfo target = null;
		RobotInfo[] enemies_in_range = Scanner.enemies_in_range;
		
		for(RobotInfo current_enemy:enemies_in_range)
			if(current_location.distanceSquaredTo(current_enemy.location) < range){
				target = current_enemy;
				range = current_location.distanceSquaredTo(current_enemy.location);
			}
		return target;
	}
}