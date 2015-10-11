/*
 *  [Lego - Project]
 *
 *  Logic layer to adapt the input data from the PS3 controller.
 *
 *  Joe.
 */

#include <stdio.h>

#ifndef __PS3_LOGIC_LAYER_H_
#define __PS3_LOGIC_LAYER_H_


// ---------------- CONSTANTS DEFINITIONS ----------------

// Controller buttons IDs
#define PS3_BUTTON_SELECT 0
#define PS3_BUTTON_START 3
#define PS3_BUTTON_CROSS 18
#define PS3_BUTTON_SQUARE 19
#define PS3_BUTTON_CIRCLE 17
#define PS3_BUTTON_TRIANGLE 16
#define PS3_BUTTON_L1 14
#define PS3_BUTTON_L2 12
#define PS3_BUTTON_R1 15
#define PS3_BUTTON_R2 13
#define PS3_BUTTON_LEFT 11
#define PS3_BUTTON_RIGHT 9
#define PS3_BUTTON_UP 8
#define PS3_BUTTON_DOWN 10

// Controller Axis IDs
#define PS3_AXIS_LEFT_HORIZONTAL 0
#define PS3_AXIS_LEFT_VERTICAL 1
#define PS3_AXIS_RIGHT_HORIZONTAL 2 // --------------- TODO: CHECK THIS ?? ---------------
#define PS3_AXIS_RIGHT_VERTICAL 3   // --------------- TODO: CHECK THIS ?? ---------------


// ---------------- DEFINED TYPES ----------------

typedef struct
{
    int keyID;
    float readValue;
}TPS3ReadAction;


// ---------------- EXPORTED FUNCTIONS PROTOTYPES ----------------

extern void testFunction(void);

/*
 * Tries to connect to the first PS3 controller available.
 *
 * Returns:
 *          1   Connected sucessfully.
 *          0   Error connecting.
 */
extern int openController(void);

/*
 * Tries to disconnect from the connected PS3 controller.
 *
 * Returns:
 *          1   Disconnected sucessfully.
 *          0   Error disconnecting.
 */
extern int closeController(void);

/* 
 * Blocking reading of controller until a new value of the given
 * key ID is received.
 *
 * Returned data:
 *          <TPS3ReadAction * > pointer to structure with read
 *                              analog value within configured range.
 */
extern void waitForKey(const int keyID, TPS3ReadAction * returnedData);

/*
 * Blocking reading of controller until a new value of any of the
 * given keys IDs are received.
 *
 * Returned data:
 *          <TPS3ReadAction * > pointer to structure with read
 *                              analog value within configured range.
 */
extern void waitForKeys(const int keyCount, int * keyIDs, TPS3ReadAction * returnedData);

/*
 * Blocking reading of the controller until a new value of the given
 * axis ID is received.
 *
 * Returned data:
 *          <TPS3ReadAction * > pointer to structure with read
 *                              analog value within configured range.
 */
extern void waitForSingleAxis(int axisIDs, TPS3ReadAction * returnedData);

/*
 * Blocking reading of the controller until a new value of any of the
 * given axis IDs is received.
 *
 * Returned data:
 *          <TPS3ReadAction * > pointer to structure with read
 *                              analog value within configured range.
 */
extern void waitForAxis(const int axisCount, int * axisIDs, TPS3ReadAction * returnedData);

/*
 * Sets the minimum and maximum values for the range of output data
 * used for the analog buttons.
 */
extern void setButtonsAnalogDataRange(float rangeMinValue, float rangeMaxValue);

/*
 * Sets the minimum and maximum values for the range of output data
 * used for the analog axis.
 */
extern void setAxisAnalogDataRange(float rangeMinValue, float rangeMaxValue);

/*
 * Gets the minimum and maximum values for the range of output data
 * used for the analog buttons.
 */
extern void getButtonsAnalogDataRange(float * rangeMinValue, float * rangeMaxValue);

/*
 * Gets the minimum and maximum values for the range of output data
 * used for the analog axis.
 */
extern void getAxisAnalogDataRange(float * rangeMinValue, float * rangeMaxValue);

#endif
