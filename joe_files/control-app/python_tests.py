'''
    Demo script to test the range adaptation used in the PS3 control program.

    Joe.
'''

input_range_max = 32767;
input_range_min = -32767;
output_range_max = 100;
output_range_min = -100;


def convertData(inputData):

    # Offset number to positive
    converted = float(inputData) + float(-input_range_min)

    # Normalize to unity
    converted = converted / float(input_range_max - input_range_min)

    # Correct for gain of output scale
    converted = converted * float(output_range_max - output_range_min)

    # De-offset for output scale
    converted = converted + float(output_range_min)

    return converted


if __name__ == "__main__":

    input_data = 5000

    print ' >> Test: adapting the data range from the controller.'
    print 'Input data: ', input_data
    print 'Converted data: ', convertData(input_data)
