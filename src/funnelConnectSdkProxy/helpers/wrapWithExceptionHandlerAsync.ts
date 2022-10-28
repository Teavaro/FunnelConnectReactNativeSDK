export const wrapWithExceptionHandlerAsync = async (
  wrappedFunction: Function,
  ...args: any[]
) => {
  try {
    console.log(
      `Arguments provided to the ${wrappedFunction.name} function:`,
      ...args
    );
    return await wrappedFunction(...args);
  } catch (error: any) {
    console.log('Async operation error handler');
    console.log('Error object:', error);
    console.log('Stringified error:', JSON.stringify(error));
    console.log('Error message:', error.message);
    throw new Error(error.message);
  }
};
