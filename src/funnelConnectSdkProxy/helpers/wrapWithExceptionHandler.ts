export const wrapWithExceptionHandler = (
  wrappedFunction: Function,
  ...args: any[]
) => {
  try {
    wrappedFunction(...args);
  } catch (error: any) {
    console.log(error);
    console.log(JSON.stringify(error));
    throw new Error(error.message);
  }
};
