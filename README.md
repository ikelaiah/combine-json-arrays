# Combine JSON Arrays (of Objects)

Combine JSON Arrays is a D program for combining multiple JSON array files (containing Objects) into a single output file.

## Installation

You need to have a [D Language compiler](https://dlang.org/download.html) installed in your system.

## Usage

Compile using a D lang compiler and run it using `-i <input folder>`. The input folder should contains JSON file. 

An example to compile using the `dmd` compiler and run it.

```bash
$ dmd combine-json-arrays.d
$ ./combine-json-arrays.exe -i <input-folder>
```

Alternatively, if you have the dmd compiler installed, you can run this like a script using [`rdmd`](https://dlang.org/rdmd.html) tool.

```bash
$ rdmd combine-json-arrays.d -i <input-folder>
```

**Note**

 - Input files that are not JSON arrays will be skipped.
 - Input files containing any of the following strings will be excluded:
   - `output`, 
   - `combined`
 - Output files will be timestamped.

## Output

An output file will be generated in the input folder with a timestamp.

## Example

```bash
$ rdmd combine-json-arrays.d -i input/
Combine JSON arrays (of objects): ignoring input/2022-08-15T1131-output-combined.json
Combine JSON arrays (of objects): input/sample-data-1.json, length: 58
Combine JSON arrays (of objects): input/sample-data-2.json, length: 16
Combine JSON arrays (of objects): ignoring input/sample-data-3.json, not a JSON array of Objects.
```

## License
[MIT](https://choosealicense.com/licenses/mit/)