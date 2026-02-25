import subprocess
import sys
import os
import xml.sax
import textwrap

# --- Configuration ---
CONFIG = {
    "indent_char": " ",       # Use " " for spaces, "\t" for tabs
    "indent_size": 4,         # How many spaces per level?
    "max_line_length": 120,   # Maximum characters per line
    "extensions": ('.xml', '.xsd', '.wsdl'),
    # Map of { Bad_Byte : Replacement_Bytes }
    "replacements": {
        b'\x85': b'...',      # Horizontal ellipsis
        b'\x91': b"'",        # Left single quote
        b'\x92': b"'",        # Right single quote
        b'\x93': b'"',        # Left double quote
        b'\x94': b'"',        # Right double quote
        b'\x95': b'*',        # Bullet
        b'\x96': b'-',        # En dash
        b'\x97': b'-',        # Em dash
        b'\x84': b'"',        # Low double quote
        b'\x99': b'\xe2\x84\xa2' # Trademark (TM)
    }
}

class DepthMapHandler(xml.sax.ContentHandler):
    def __init__(self):
        self.line_depths = {}
        self.protected_lines = set()
        self.current_depth = 0
        self.locator = None
        self.in_programlisting = False
        self.programlisting_start = -1

    def setDocumentLocator(self, locator):
        self.locator = locator

    def startElement(self, name, attrs):
        line_num = self.locator.getLineNumber()
        if line_num not in self.line_depths:
            self.line_depths[line_num] = self.current_depth
        self.current_depth += 1
        
        if name == 'programlisting':
            self.in_programlisting = True
            self.programlisting_start = line_num

    def endElement(self, name):
        self.current_depth -= 1
        line_num = self.locator.getLineNumber()
        if line_num not in self.line_depths:
            self.line_depths[line_num] = self.current_depth

        if name == 'programlisting' and self.in_programlisting:
            self.in_programlisting = False
            self.protected_lines.update(range(self.programlisting_start, line_num + 1))

    def characters(self, content):
        if content.strip():
            line_num = self.locator.getLineNumber()
            if line_num not in self.line_depths:
                self.line_depths[line_num] = self.current_depth

def get_changed_lines(file_path, base_ref):
    """
    Returns a set of 1-based line numbers changed in the file.
    Uses errors='replace' to avoid crashing on the very bad bytes we aim to fix.
    """
    cmd = ["git", "diff", "-U0", base_ref, "--", file_path]
    try:
        # Crucial: errors='replace' prevents crash when diffing files with bad encoding
        output = subprocess.check_output(cmd).decode("utf-8", errors="replace")
    except subprocess.CalledProcessError:
        return set()

    changed_lines = set()
    for line in output.splitlines():
        if line.startswith("@@"):
            try:
                plus_part = line.split("+")[1].split()[0]
                if "," in plus_part:
                    start, count = map(int, plus_part.split(","))
                else:
                    start, count = int(plus_part), 1
                
                if count > 0:
                    changed_lines.update(range(start, start + count))
            except (IndexError, ValueError):
                continue
    return changed_lines

def smart_wrap(content, indent_str, max_len):
    """
    Wraps text content (string) to fill the line up to max_len.
    """
    clean_content = ' '.join(content.split())
    
    full_line = indent_str + clean_content
    if len(full_line) <= max_len:
        return full_line + "\n"

    wrapped_lines = textwrap.wrap(
        clean_content,
        width=max_len,
        initial_indent=indent_str,
        subsequent_indent=indent_str,
        break_long_words=False,
        break_on_hyphens=False
    )
    return "\n".join(wrapped_lines) + "\n"

def process_file(file_path, base_ref):
    # 1. Get changed lines (from the dirty file on disk)
    changed_lines = get_changed_lines(file_path, base_ref)
    if not changed_lines:
        return

    # 2. Read file as BINARY
    # We must operate in binary to handle the specific byte replacements safely.
    with open(file_path, "rb") as f:
        original_lines_bytes = f.readlines()

    # 3. Create a 'Clean-in-Memory' version
    # We apply the byte replacements ONLY to the changed lines.
    # This buffer will be used for parsing (to avoid crashes) and formatting.
    cleaned_lines_bytes = list(original_lines_bytes) # Make a copy
    
    for i in range(len(cleaned_lines_bytes)):
        line_num = i + 1
        if line_num in changed_lines:
            current_line = cleaned_lines_bytes[i]
            for bad_byte, replacement in CONFIG["replacements"].items():
                current_line = current_line.replace(bad_byte, replacement)
            cleaned_lines_bytes[i] = current_line

    # 4. Parse the Cleaned Content for Depth
    # We join the cleaned lines into a single byte stream for the parser.
    # This prevents the parser from crashing on the user's bad bytes.
    full_clean_content = b"".join(cleaned_lines_bytes)
    
    handler = DepthMapHandler()
    parser = xml.sax.make_parser()
    parser.setContentHandler(handler)
    try:
        # xml.sax can parse bytes directly!
        xml.sax.parseString(full_clean_content, handler)
    except xml.sax.SAXException:
        print(f"Skipping {file_path}: Malformed XML.")
        return

    # 5. Format and Reconstruct
    final_output_lines = []

    for i, line_bytes in enumerate(cleaned_lines_bytes):
        line_num = i + 1
        
        # IF Protected (programlisting): Keep the bytes exactly as they are
        if line_num in handler.protected_lines:
            final_output_lines.append(line_bytes)
            continue
        
        # IF Changed: Decode -> Format -> Encode
        if line_num in changed_lines and line_num in handler.line_depths:
            try:
                # Decode to string for text wrapping (should be safe now after cleaning)
                line_text = line_bytes.decode('utf-8')
            except UnicodeDecodeError:
                # Fallback: If it still fails, keep original bytes
                final_output_lines.append(line_bytes)
                continue

            depth = handler.line_depths[line_num]
            correct_indent = CONFIG["indent_char"] * (CONFIG["indent_size"] * depth)
            
            # Smart wrap returns a string, we must encode back to bytes
            formatted_text = smart_wrap(line_text, correct_indent, CONFIG["max_line_length"])
            final_output_lines.append(formatted_text.encode('utf-8'))
            
        else:
            # IF Unchanged: Use the ORIGINAL bytes from disk (Step 2)
            # This ensures we don't accidentally touch bytes in the rest of the file.
            final_output_lines.append(original_lines_bytes[i])

    # 6. Write back as BINARY
    with open(file_path, "wb") as f:
        f.writelines(final_output_lines)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python progressive_lint.py <base_ref>")
        sys.exit(1)

    base_ref = sys.argv[1]
    
    try:
        diff_cmd = ["git", "diff", "--name-only", base_ref]
        files = subprocess.check_output(diff_cmd).decode("utf-8").splitlines()
        
        target_files = [
            f for f in files 
            if f.lower().endswith(CONFIG["extensions"]) and os.path.exists(f)
        ]
        
        for file_path in target_files:
            process_file(file_path, base_ref)
            
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)
