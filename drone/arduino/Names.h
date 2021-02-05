#pragma once
#define BYTE_KEY		0x69 // key
#define MSG_BYTES		5 // size of incoming message in bytes
#define CMD_BYTES		4 // size of command in bytes	
//=============================SYSTEM COMMANDS=============================

#define CMD_SUCCESS						        0x01 // command executed successfully
#define INVALID_INPUT					        0x02 // drone got unindentified command value
#define INVALID_CMD						        0x03 // drone got unindentified command
#define THUMPER_CONNECTION_FAILURE				0x04 // mega couldn't connect to thumper's board

//=============================DRONE CONTROL COMMANDS=============================

// AUTOMOVE:

#define AUTOMOVE				0x41

// LIGHTS:

#define LIGHTS					0x42

// WHEELS:

#define WHEEL_R					0x10 // right row
#define WHEEL_L					0x11 // left row
#define RWHEEL_R				0x18 // right row reverse
#define RWHEEL_L				0x19 // left row reverse

// MANIPULATOR:

#define ARM_BASE_MOVE			0x47 // manipulator base movement
#define ARM_PIVOT_MOVE			0x48 // manipulator pivot movement
#define ARM_HAND_MOVE			0x49 // manipulator hand squeezing 
#define ARM_MANUAL				0x4A // manipulator manual control
#define ARM_MOVEBACK			0x4B // return manipulator to default position

// LASER:

#define LASER					0x4C

// ENGINE:

#define ENGINE_MANUAL			0x4D

// CENTER OF MASS AND CLEARANCE:

#define COM_AUTO			    0x4E // center of mass autocalibration
#define COM_MANUAL				0x4F // center of mass manual control
#define CLEARANCE_MANUAL		0x50 // clearance manual control

// TRANSMITTER POWER:

#define TRNSTR					0x31 // transmitter power

// CAM:

#define CAM_A					0x33 // camera channel selector A
#define CAM_B					0x34 // camera channel selecor B