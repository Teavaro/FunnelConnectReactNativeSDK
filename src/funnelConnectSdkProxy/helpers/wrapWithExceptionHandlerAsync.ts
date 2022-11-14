export const wrapWithExceptionHandlerAsync = async (
  wrappedFunction: Function,
  ...args: any[]
) => {
  try {
    return await wrappedFunction(...args);
  } catch (error: any) {
    throw new Error(error.message);
  }
};
