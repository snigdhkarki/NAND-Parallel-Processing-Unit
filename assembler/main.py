import sys

def assemble(input_file, output_file=None):
    opcode_map = {
        'NANDMEM':  0b000,
        'NANDCORE': 0b001,
        'STOREMID': 0b010,
        'STOREOUT': 0b011,
        'LOADMEM':  0b100,
        'LOADCORE': 0b101
    }
    
    hex_output = []
    
    try:
        with open(input_file, 'r') as f:
            for line_num, line in enumerate(f, 1):
                parts = line.strip().split()
                if not parts:
                    continue # Skip empty lines
                
                opcode = parts[0].upper()
                
                if opcode == 'HALT':
                    hex_output.append("FF")
                    continue
                
                if opcode not in opcode_map:
                    print(f"Error: Unknown opcode '{opcode}' on line {line_num}")
                    continue
                
                opcode_val = opcode_map[opcode]
                
                operand_val = 0
                if len(parts) > 1:
                    try:
                        operand_val = int(parts[1])
                    except ValueError:
                        print(f"Error: Invalid operand '{parts[1]}' on line {line_num}")
                        continue
                else:
                    print(f"Warning: Missing operand for '{opcode}' on line {line_num}. Defaulting to 0.")
                
                machine_code = (opcode_val << 5) | (operand_val & 0x1F)
                
                hex_output.append(f"{machine_code:02X}")
                
    except FileNotFoundError:
        print(f"Error: Could not find '{input_file}'")
        return

    result = " ".join(hex_output)
    
    if output_file:
        with open(output_file, 'w') as f:
            f.write(result)
        print(f"Successfully wrote to {output_file}")
    
    return result

if __name__ == "__main__":
    output = assemble("code.txt", "output.txt")
    print("Output:", output)