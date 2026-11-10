
const jwt = require('jsonwebtoken');
const User = require('../models/User');

// Protect routes using JWT
exports.protect = async (req, res, next) => {
  try {
    const header = req.headers.authorization;

    if (!header || !header.startsWith('Bearer ')) {
      return res.status(401).json({
        message: 'Non autorisé, token manquant',
      });
    }

    const token = header.split(' ')[1];

    const decoded = jwt.verify(
      token,
      process.env.JWT_SECRET
    );

    const user = await User.findById(decoded.id);

    if (!user) {
      return res.status(401).json({
        message: 'Utilisateur introuvable',
      });
    }

    req.user = user;

    next();

  } catch (error) {
    return res.status(401).json({
      message: 'Token invalide ou expiré',
    });
  }
};

// Authorize user according to role
exports.authorize = (...roles) => {
  return (req, res, next) => {

    if (!req.user || !roles.includes(req.user.role)) {
      return res.status(403).json({
        message: 'Accès refusé',
      });
    }

    next();
  };
};
