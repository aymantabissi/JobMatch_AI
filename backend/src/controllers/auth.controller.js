const User = require('../models/User');
const generateToken = require('../utils/generateToken');

const formatUser = (user) => ({
  id: user._id,
  fullName: user.fullName,
  email: user.email,
  role: user.role,
  companyName: user.companyName,
});

// POST /api/auth/register
exports.register = async (req, res) => {
  try {
    const { fullName, email, password, role, companyName } = req.body;

    const exists = await User.findOne({ email });
    if (exists) {
      return res.status(400).json({ message: 'Cet email est déjà utilisé' });
    }

    // Sécurité: ma-khellich l-user ykhtar "admin" mn register
    const safeRole = role === 'recruiter' ? 'recruiter' : 'candidate';

    if (safeRole === 'recruiter' && !companyName) {
      return res
        .status(400)
        .json({ message: "Le nom de l'entreprise est obligatoire pour un recruteur" });
    }

    const user = await User.create({
      fullName,
      email,
      password,
      role: safeRole,
      companyName: safeRole === 'recruiter' ? companyName : undefined,
    });

    res.status(201).json({
      message: 'Compte créé avec succès',
      token: generateToken(user),
      user: formatUser(user),
    });
  } catch (error) {
    console.error('Register error:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
};

// POST /api/auth/login
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    // password fih select:false, khassna nzidouh b +password
    const user = await User.findOne({ email }).select('+password');
    if (!user || !(await user.matchPassword(password))) {
      return res.status(401).json({ message: 'Email ou mot de passe incorrect' });
    }

    res.json({
      message: 'Connexion réussie',
      token: generateToken(user),
      user: formatUser(user),
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
};

// GET /api/auth/me
exports.getMe = async (req, res) => {
  res.json({ user: formatUser(req.user) });
};