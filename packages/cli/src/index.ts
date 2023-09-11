#!/usr/bin/env node

import { DateTime } from "luxon";
import yargs from "yargs";
import { hideBin } from "yargs/helpers";
import { dependencies } from "@adzerk/zerkel-cli/package.json";
import zerkel from "@adzerk/zerkel";

import { Failure, Success } from "./types/result";

const version = dependencies["@adzerk/zerkel"];
const epilogue = () => `Copyright Kevel ${DateTime.now().year}`;

yargs(hideBin(process.argv))
  .usage("Usage: $0 <command> [options]")
  .command(
    "validate [expression]",
    "Validate zerkel expression.",
    (yargs) => yargs
      .positional("expression", {
        describe: "Expression to parse.",
        default: ""
      }),
    (argv) => {
      try {
        const code = zerkel.parse(argv.expression);
        const result: Success = {
          result: "success",
          body: {
            code,
            version
          }
        };
        process.stdout.write(JSON.stringify(result));
      }
      catch (error) {
        const code: string = (error as any).toString();
        const result: Failure = {
          result: "error",
          body: {
            code,
            version
          }
        };
        process.stdout.write(JSON.stringify(result));
      }
    }
  )
  .example("$0 parse x>1", "Parse the expression \"x>1\"")
  .epilogue(epilogue())
  .parse();
