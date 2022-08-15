module combinejsonarrays;

import std.file : write, dirEntries, readText, SpanMode, exists;
import std.stdio : writeln;
import std.json : parseJSON, JSONValue, JSONType;
import std.algorithm.searching;
import std.getopt;
import std.array;
import std.datetime.systime;
import std.conv;
import std.path;

void main(string[] args)
{

    // Program name
    string prog_name = "Combine JSON arrays (of objects)";

    // String in files for the exclusion
    string[] exclude_string = ["output", "combined"];

    // Path of input file
    // Note immutable(char)[] is the same as string
    // See https://dlang.org/spec/arrays.html#strings
    string input_path = "";

    // Variable to store combined JSON array
    // Doc: https://dlang.org/phobos/std_json.html#.JSONValue.array
    JSONValue jsonResult;
    jsonResult.array = [];

    GetoptResult user_args = getopt(
        args,
        "input_path|i", "The input path containing JSON files (array of objects) to combine.", &input_path);

    if (input_path.empty)
    {
        writeln(prog_name ~ ": input path is missing.\n");
        defaultGetoptPrinter("Combine JSON (object) arrays.",
            user_args.options);
    }

    if (user_args.helpWanted)
    {
        defaultGetoptPrinter(prog_name ~ ".",
            user_args.options);
    }

    if (!input_path.exists)
    {
        writeln(prog_name ~ ": unable to find path specified.");
        return;
    }

    // The main loop iterates each *.json file in an input folder -------------
    foreach (string filename; dirEntries(buildPath(input_path), "*.json", SpanMode.shallow))
    {
        int skip = 0;

        foreach (string exclude; exclude_string)
        {
            // if filename contains a string in the exclude list
            // mark skip as 1
            if (canFind(filename, exclude))
            {
                skip = 1;
                break;
            }
        }

        if (skip == 1)
        {
            writeln(prog_name ~ ": ignoring " ~ filename);
            continue;

        }

        // Read JSON file as string
        string content = readText(filename);

        // Parse as JSON
        JSONValue j = parseJSON(content);

        // If JSONType is array, merge
        if (j.type == JSONType.array)
        {
            // show status to console
            writeln(prog_name ~
                    ": " ~ 
                     filename ~
                    ", length: " ~
                    to!string(j.array.length));

            jsonResult.array ~= j.array;
        }
        else
        {
            writeln(prog_name ~
                    ": ignoring " ~
                    filename ~
                    ", not a JSON array of Objects.");
        }
    }

    // Write result to an output file
    string now = Clock.currTime().toISOExtString();
    string output_filepath = buildPath(input_path, now.replace(":", "")[0 .. 15] ~ "-output-combined.json");
    write(output_filepath, jsonResult.toPrettyString);
}