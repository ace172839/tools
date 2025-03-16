import os
import pandas
import pathlib
import lxml

def xml_to_excel_pandas(xml_file, csv_file):
    try:
        parsed_file = pandas.read_xml(xml_file)
        parsed_file.to_csv(csv_file, index=False)
    except lxml.etree.XMLSyntaxError as e:
        print(f"Error parsing XML file '{xml_file}': {e}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")


if __name__ == "__main__":
    current_dir = pathlib.Path(__file__).parent.resolve()
    input_path = os.path.join(current_dir.parent, "test_data", "xml_to_csv.xml")
    output_path = os.path.join(current_dir.parent, "test_data", "xml_to_csv.csv")

    if not os.path.isfile(input_path):
        print(f"Error: XML file not found at '{input_path}'")
        exit()

    xml_to_excel_pandas(input_path, output_path)
