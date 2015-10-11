#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// TODO: check wether this is needed in Debian or not (I think it is)
#include <unistd.h>

#include "joystick.h"
#include "ps3_logic_layer.h"

// ---------------- PRIVATE VARIABLES ----------------

// Received input range from controller
float inputButtonDataRange_max = +32767;
float inputButtonDataRange_min = 0;
float inputAxisDataRange_max = +32767;
float inputAxisDataRange_min = -32767;

// Desired output range
float desiredButtonDataRange_max = 100.0;
float desiredButtonDataRange_min = 0.0;
float desiredAxisDataRange_max = 100.0;
float desiredAxisDataRange_min = -100.0;

// Joystick related variables
int js_fileDescriptor, js_readEvent;
struct js_event js_eventStruct;


// ---------------- INTERNAL FUNCTIONS ----------------

void readNewData(TPS3ReadAction * readData)
{
    // If the joystick is not ready, return NULL;
    if (js_fileDescriptor < 0)
    {
        readData = NULL;
        return;
    }

    // Read new event
    js_readEvent = read_joystick_event(&js_eventStruct);

    // Allocate memory for the output data if necessary
    if (readData == NULL)
        readData = (TPS3ReadAction *)malloc(sizeof(TPS3ReadAction));

    // Assign data to be returned
    readData->keyID = js_eventStruct.number;
    readData->readValue = (float)js_eventStruct.value;
}

/*
 * Converts the read analog data from a button to the usable range
 * that is configured.
 */
float convertButtonDataToUsedRange(int readButtonData)
{
    float _convertedInputData, _outputData;

    // Casts input data to propper format
    _convertedInputData = (float)readButtonData;

    // Adapts the input data to the output range

    // 1 - Offset number to positive from the input scale
    _outputData = (float)_convertedInputData -inputButtonDataRange_min;
    // 2 - Normalize to unity
    _outputData = _outputData / (inputButtonDataRange_max - inputButtonDataRange_min);
    // 3 - Correct for gain of output scale
    _outputData = _outputData * (desiredButtonDataRange_max - desiredButtonDataRange_min);
    // 4 - De-offset for output scale
    _outputData = _outputData + desiredButtonDataRange_min;

    return _outputData;
}

/*
 * Converts the read analog data from an axis to the usable range
 * that is configured.
 */
float convertAxisDataToUsedRange(int readAxisData)
{
    float _convertedInputData, _outputData;

    // Casts input data to propper format
    _convertedInputData = (float)readAxisData;

    // Adapts the input data to the output range

    // 1 - Offset number to positive from the input scale
    _outputData = (float)_convertedInputData -inputAxisDataRange_min;
    // 2 - Normalize to unity
    _outputData = _outputData / (inputAxisDataRange_max - inputAxisDataRange_min);
    // 3 - Correct for gain of output scale
    _outputData = _outputData * (desiredAxisDataRange_max - desiredAxisDataRange_min);
    // 4 - De-offset for output scale
    _outputData = _outputData + desiredAxisDataRange_min;

    return _outputData;
}

/*
 * Checks wether a given ID matches any of the IDs on a list.
 *
 * Returns:
 *          1   ID was found in list.
 *          0   ID was NOT found in list.
 */
int checkIDisInList(int receivedID, int * listOfIDs, int keyCount)
{
    int _returnedValue = 0;

    // Checks all IDs in the list
    for (int i = 0; i < keyCount; i++)
        if (receivedID == listOfIDs[i])
            _returnedValue = 1;

    return _returnedValue;
}


// ---------------- EXTERNAL FUNCTIONS ----------------

/*
 * Tries to connect to the first PS3 controller available.
 *
 * Returns:
 *          1   Connected sucessfully.
 *          0   Error connecting.
 */
extern int openController(void)
{
    // Tries to open the joystick descriptor
    if ((js_fileDescriptor = open_joystick(NULL)) < 0)
    {
        return 0;
    }
    else
    {
        return 1;
    }
}

/*
 * Tries to disconnect from the connected PS3 controller.
 *
 * Returns:
 *          1   Disconnected sucessfully.
 *          0   Error disconnecting.
 */
extern int closeController(void)
{
    return close(js_fileDescriptor);
}

/*
 * Blocking reading of controller until a new value of the given
 * key ID is received.
 *
 * Returned data:
 *          <TPS3ReadAction * > pointer to structure with read
 *                              analog value within configured range.
 */
extern void waitForKey(const int keyID, TPS3ReadAction * returnedData)
{
    // Allocates memory for the returned data if needed
    if (returnedData == NULL)
        returnedData = (TPS3ReadAction *)malloc(sizeof(TPS3ReadAction));

    // Receive new data
    readNewData(returnedData);

    // If it's not the expected type repeat
    while (returnedData != NULL && returnedData->keyID != keyID)
        readNewData(returnedData);

    // Could not retrieve data from the controller
    if (returnedData == NULL)
        return;

    // Convert data range
    returnedData->readValue = convertButtonDataToUsedRange(returnedData->readValue);
}

/*
 * Blocking reading of controller until a new value of any of the
 * given keys IDs are received.
 *
 * Returned data:
 *          <TPS3ReadAction * > pointer to structure with read
 *                              analog value within configured range.
 */
extern void waitForKeys(const int keyCount, int * keyIDs, TPS3ReadAction * returnedData)
{
    // Allocates memory for the returned data if needed
    if (returnedData == NULL)
        returnedData = (TPS3ReadAction *)malloc(sizeof(TPS3ReadAction));
    
    // Receive new data
    readNewData(returnedData);
    
    // If it's not the expected type repeat
    while (returnedData != NULL && !checkIDisInList(returnedData->keyID, keyIDs, keyCount))
        readNewData(returnedData);
    
    // Could not retrieve data from the controller
    if (returnedData == NULL)
        return;
    
    // Convert data range
    returnedData->readValue = convertButtonDataToUsedRange(returnedData->readValue);

}

/*
 * Blocking reading of the controller until a new value of the given
 * axis ID is received.
 *
 * Returned data:
 *          <TPS3ReadAction * > pointer to structure with read
 *                              analog value within configured range.
 */
extern void waitForSingleAxis(int axisIDs, TPS3ReadAction * returnedData)
{
    // TODO: complete

    // TODO: Check if the axis is actually considered as a button, then this two
    //       functions are not necessary
}

/*
 * Blocking reading of the controller until a new value of any of the
 * given axis IDs is received.
 *
 * Returned data:
 *          <TPS3ReadAction * > pointer to structure with read
 *                              analog value within configured range.
 */
extern void waitForAxis(const int axisCount, int * axisIDs, TPS3ReadAction * returnedData)
{
    // TODO: complete

    // TODO: Check if the axis is actually considered as a button, then this two
    //       functions are not necessary
}

/*
 * Sets the minimum and maximum values for the range of output data
 * used for the analog buttons.
 */
extern void setButtonsAnalogDataRange(float rangeMinValue, float rangeMaxValue)
{
    desiredButtonDataRange_max = rangeMaxValue;
    desiredButtonDataRange_min = rangeMinValue;
}

/*
 * Sets the minimum and maximum values for the range of output data
 * used for the analog axis.
 */
extern void setAxisAnalogDataRange(float rangeMinValue, float rangeMaxValue)
{
    desiredAxisDataRange_max = rangeMaxValue;
    desiredAxisDataRange_min = rangeMinValue;
}

/*
 * Gets the minimum and maximum values for the range of output data
 * used for the analog buttons.
 */
extern void getButtonsAnalogDataRange(float * rangeMinValue, float * rangeMaxValue)
{
    // Allocates memory if necessary
    if (rangeMinValue == NULL)
        rangeMinValue = (float *)malloc(sizeof(float));
    if (rangeMaxValue == NULL)
        rangeMaxValue = (float *)malloc(sizeof(float));

    (* rangeMaxValue) = desiredButtonDataRange_max;
    (* rangeMinValue) = desiredButtonDataRange_min;
}

/*
 * Gets the minimum and maximum values for the range of output data
 * used for the analog axis.
 */
extern void getAxisAnalogDataRange(float * rangeMinValue, float * rangeMaxValue)
{
    // Allocates memory if necessary
    if (rangeMinValue == NULL)
        rangeMinValue = (float *)malloc(sizeof(float));
    if (rangeMaxValue == NULL)
        rangeMaxValue = (float *)malloc(sizeof(float));

    (* rangeMaxValue) = desiredAxisDataRange_max;
    (* rangeMinValue) = desiredAxisDataRange_min;
}






























void testFunction(void)
{
    printf("Everything's hunky dory.\n");
    
    printf("Converted: %.2f\n",
           convertButtonDataToUsedRange(5000));
    
}

/*
 *
 * OLD CODE
 */
 
void testFunction2(void)
{
    int x_pos = 0, y_pos = 0;
    
    printf(" <[ CAR REMOTE CONTROL PROGRAM ]>\n\n");
    printf(" > Initializing.\n");
    
    printf(" > Accessing joystick.\n");
    if ((js_fileDescriptor = open_joystick(NULL)) < 0)
    {
        printf("ERROR: Could not access the joystick! Terminating.\n");
        return;
    }
    
    printf(" > Ready, receiving orders ... ");
    
    while (1)
    {
        js_readEvent = read_joystick_event(&js_eventStruct);
        
        usleep(5000);
        if (js_readEvent == 1 && (js_eventStruct.number == 0 || js_eventStruct.number == 1))
        {
            switch (js_eventStruct.number)
            {
                case 0:
                    x_pos = js_eventStruct.value;
                    break;
                case 1:
                    y_pos = js_eventStruct.value;
                    break;
                    
            }
            //			printf("Event: time %8u, value %8hd, type: %3u, axis/button: %u\n",
            //				js_event.time, js_event.value, js_event.type, js_event.number);
            printf("[%d - %d]\n", x_pos, y_pos);
        }
    }
}
