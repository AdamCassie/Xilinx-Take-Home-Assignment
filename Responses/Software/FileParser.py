import json                         # Library to parse JSON into Python dict or list
import matplotlib.pyplot as plt     # Graphing and data visualization library (used for Graphical Summary)
from string import ascii_uppercase  # To iterate through capital letters in parsing each file

# Assume file_path is string containing the path to the Tests/ directory
def file_parser(file_path):

    # Loop over all json input files (ie. assume we only have files A to Z)
    for letter in ascii_uppercase:
        input_file = file_path + "test" + letter + ".json"  # Get file path
        with open(input_file) as f:                         # Open the json file
            data = json.load(f)                             # Load a dictionary with the file data
        
        #Plot Errors vs Frequency for each test file
        plt.plot(data["freq"], data["errors"], label = ("Test " + letter))

    # Add labels to plot                         
    plt.xlabel('Frequency')
    plt.ylabel('Errors')
    plt.title('Graphical Summary of Test Suite')
    plt.legend()
    plt.show()
