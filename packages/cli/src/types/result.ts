interface IResult {
  /**
   * Status of parsing.
   */
  result: "success" | "error";
};

interface IBody {
  /**
   * Parsing body.
   */
  body: {
    /**
     * Result information.
     */
    code: string;
    /**
     * Parser version.
     */
    version: string;
  };
};

/**
 * Successful validation.
 */
interface Success extends IResult, IBody {
  result: "success";
}

/**
 * Failed validation.
 */
interface Failure extends IResult, IBody {
  result: "error";
}

/**
 * General validation object.
 */
type Result = Success | Failure;

export { Result, Success, Failure };
