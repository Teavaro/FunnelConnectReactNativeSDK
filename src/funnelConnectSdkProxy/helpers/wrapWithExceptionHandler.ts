export const wrapWithExceptionHandler = (
  wrappedFunction: Function,
  ...args: any[]
) => {
  try {
    wrappedFunction(...args);
  } catch (error: any) {
    throw new Error(error.message);
  }
};
