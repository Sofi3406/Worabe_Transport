
function errorHandler(err, req, res, next) {
  console.error(err);

  if (err.name === "ValidationError") {
    return res.status(400).json({
      message: "Validation error.",
      details: Object.values(err.errors).map((e) => e.message),
    });
  }

  if (err.code === 11000) {
    return res.status(409).json({
      message: "A record with this value already exists.",
    });
  }

  if (err.name === "CastError") {
    return res.status(400).json({
      message: "Invalid ID format.",
    });
  }

  return res.status(500).json({
    message: "An unexpected server error occurred.",
  });
}

module.exports = errorHandler;
