#include "stdio.h"
#include "ps3_control_layer.h"

int main(void)
{
    TPS3ReadAction * returnedData;
    int setOfKeys1[4];
    setOfKeys1[0] = PS3_BUTTON_LEFT;
    setOfKeys1[1] = PS3_BUTTON_RIGHT;
    setOfKeys1[2] = PS3_BUTTON_UP;
    setOfKeys1[3] = PS3_BUTTON_DOWN;

    printf("\n>> PS3 Controller - Test program <<\n\n");

    // Open the joystick
    if (!openController())
    {
        printf("ERROR: Could not open the controller!\n");
        return -1;
    }
    printf("Controller ready.\n");

    // Waits for the Start button
    printf("\n >> Press <START> ...\n");
    waitForKey(PS3_BUTTON_START, returnedData);
    if (returnedData != NULL)
        printf("Read: %.1f\n", returnedData->readValue);
    else
        printf("Received NULL!\n");

    // Waits for the cross (X)
    printf("\n >> Press (X) ...\n");
    waitForKey(PS3_BUTTON_CROSS, returnedData);
    if (returnedData != NULL)
        printf("Read: %.1f\n", returnedData->readValue);
    else
        printf("Received NULL!\n");

    // Wait for several keys (a couple of times)
    printf("\n >> Press ANY arrow ...\n");
    waitForKeys(4, setOfKeys1, returnedData);
    if (returnedData != NULL)
        printf("Read: %.1f\n", returnedData->readValue);
    else
        printf("Received NULL!\n");
    
    // Wait for axis
    //
    // Test this part if the controller differs

	return 0;
}
