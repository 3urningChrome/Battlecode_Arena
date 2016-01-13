package Pre_competition_dev;

import battlecode.common.RobotController;

public class RobotPlayer {
	public static void run(RobotController rc){
		switch (rc.getType()){
		case HQ:
			//RobotHQ.loop(rc);
		default:
			System.out.println("Unknown robot spawned");
			break;
		}
	}
}
