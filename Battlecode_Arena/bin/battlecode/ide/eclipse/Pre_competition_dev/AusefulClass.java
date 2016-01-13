package Pre_competition_dev;

import battlecode.common.*;

public class AusefulClass {
	
	static RobotController rc;
	
	static Team friendly;
	static Team enemy;
	
	static MapLocation friendly_HQ;
	static MapLocation enemy_HQ;
	
	static MapLocation current_location;
	
	static RobotType my_type;
	static int byte_code_limiter;
		
	public static void init(RobotController the_rc) {
		rc = the_rc;
		
		friendly = rc.getTeam();
		enemy = friendly.opponent();
		
		friendly_HQ = rc.senseHQLocation();
		enemy_HQ = rc.senseEnemyHQLocation();
		
		current_location = rc.getLocation();
		
		my_type = rc.getType();
		byte_code_limiter = my_type.bytecodeLimit;
	}
}
