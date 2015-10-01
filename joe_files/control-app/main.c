#include "stdio.h"
#include "joystick.h"

#define BUTTON_SELECT 0
#define BUTTON_START 3
#define BUTTON_CROSS 18
#define BUTTON_SQUARE 19
#define BUTTON_CIRCLE 17
#define BUTTON_TRIANGLE 16
#define BUTTON_L1 14
#define BUTTON_L2 12
#define BUTTON_R1 15
#define BUTTON_R2 13
#define BUTTON_LEFT 11
#define BUTTON_RIGHT 9
#define BUTTON_UP 8
#define BUTTON_DOWN 10


void waitForKey(struct js_event eventStruct, int keyNumber)
{

}



int main(int argc, char *argv[])
{
	int js_fileDescriptor, js_readEvent;
	struct js_event js_eventStruct;

	int x_pos = 0, y_pos = 0;

	printf(" <[ CAR REMOTE CONTROL PROGRAM ]>\n\n");
	printf(" > Initializing.\n");

	printf(" > Accessing joystick.\n");
	if ((js_fileDescriptor = open_joystick(NULL)) < 0)
	{
		printf("ERROR: Could not access the joystick! Terminating.\n");
		return 1;
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

	return 0;
}
