import sys

INPUT_FILE = "test_cube.gcode"
EJECT_FILE = "auto_eject.gcode"
OUTPUT_FILE = "output.gcode"

def build_custom_print(main_gcode_path, template_path):
    output_path = "ready_to_print.gcode"
    
    # 1. Load the Ejection Template
    with open(template_path, 'r') as t:
        eject_sequence = t.readlines()

    # 2. Process the Main G-Code
    with open(main_gcode_path, 'r') as m:
        original_lines = m.readlines()

    final_gcode = []
    
    # Logic: Skip everything until the first real movement or layer
    # For Elegoo/Cura, ';LAYER:0' is a very safe starting point.
    capture_started = False
    
    for line in original_lines:
        if ";LAYER:0" in line:
            capture_started = True
        
        if capture_started:
            # We stop adding lines when the slicer starts its own "End G-code"
            # Most slicers use M140 S0 or M104 S0 to turn off heaters at the end.
            if "M140 S0" in line or "M104 S0" in line:
                break
            final_gcode.append(line)

    # 3. Combine: Cleaned Print + External Template
    # We add a small buffer and the template
    combined_output = final_gcode + ["\n; --- EXTERNAL EJECT SEQUENCE START ---\n"] + eject_sequence

    with open(output_path, 'w') as f:
        f.writelines(combined_output)
    
    print(f"File merged successfully! Output: {output_path}")

# Example usage: python app.py benchy.gcode my_eject_settings.gcode
if __name__ == "__main__":
    if len(sys.argv) == 3:
        build_custom_print(sys.argv[1], sys.argv[2])
    else:
        print("Usage: python app.py <main_file> <template_file>")
