package Pre_competition_dev;

import battlecode.common.*;

public class Scanner extends AusefulClass{
	
	static MapLocation[] enemy_tower_locations;
	static int turn_tower_locations_last_updated =0;
	
	static RobotInfo[] nearby_enemies;
	static int turn_nearby_enemy_last_updated =0;
	
	static RobotInfo[] enemies_in_range;
	static int turn_enemies_in_range_last_updated =0;
	
	static final int MAX_FIREING_RANGE = 52;
		
	public static MapLocation[] scan_for_tower_locations(){
		if(turn_tower_locations_last_updated < Clock.getRoundNum()){
			enemy_tower_locations = rc.senseEnemyTowerLocations();
			turn_tower_locations_last_updated = Clock.getRoundNum();
		}
		return enemy_tower_locations;
	}
	
	public static RobotInfo[] scan_for_enemy(){
		if(turn_nearby_enemy_last_updated < Clock.getRoundNum()){
			nearby_enemies = rc.senseNearbyRobots(MAX_FIREING_RANGE, enemy);
			turn_nearby_enemy_last_updated = Clock.getRoundNum();
		}
		return nearby_enemies;
	}
	
	public static RobotInfo[] scan_for_enemies_in_range(){
		if(turn_enemies_in_range_last_updated < Clock.getRoundNum()){
			enemies_in_range = rc.senseNearbyRobots(my_type.attackRadiusSquared, enemy);
			turn_enemies_in_range_last_updated = Clock.getRoundNum();
		}
		return enemies_in_range;
	}

	public static RobotInfo find_closest_enemy() {
		return Utilities.find_closest_RobotInfo(scan_for_enemy());
	}
}