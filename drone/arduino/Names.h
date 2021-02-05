#pragma once
#define BYTE_KEY		0x69 // key
#define MSG_BYTES		5 // size of incoming message in bytes
#define CMD_BYTES		4 // size of command in bytes	
//=============================SYSTEM COMMANDS=============================

#define CMD_SUCCESS						        0x01 // command executed successfully
#define INVALID_INPUT					        0x02 // drone got unindentified command value
#define INVALID_CMD						        0x03 // drone got unindentified command
#define THUMPER_CONNECTION_FAILURE		0x04 // mega couldn't connect to thumper's board

//=============================DRONE CONTROL COMMANDS=============================

// AUTOMOVE:

#define AUTOMOVE			0x41

// LIGHTS:

#define LIGHTS				0x42

// WHEELS:

#define FWHEEL_R			0x43 // front right
#define FWHEEL_L			0x44 // front left
#define RWHEEL_R			0x45 // rear right
#define RWHEEL_L			0x46 // rear left

// MANIPULATOR:

#define ARM_BASE_MOVE		  0x47 // manipulator base movement
#define ARM_PIVOT_MOVE		0x48 // manipulator pivot movement
#define ARM_HAND_MOVE		  0x49 // manipulator hand squeezing 
#define ARM_MANUAL			  0x4A // manipulator manual control
#define ARM_MOVEBACK		  0x4B // return manipulator to default position

// LASER:

#define LASER				      0x4C

// ENGINE:

#define ENGINE_MANUAL		  0x4D

// CENTER OF MASS AND CLEARANCE:

#define COM_AUTO			    0x4E // center of mass autocalibration
#define COM_MANUAL			  0x4F // center of mass manual control
#define CLEARANCE_MANUAL	0x50 // clearance manual control
