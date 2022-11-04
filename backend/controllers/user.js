const user = require("../models/users");
const bcrypt = require("bcryptjs");

exports.adduser = async (req, res) => {
  try {
    const email = req.body.email;
    const result = await user.findOne({ email: email }).select("email").lean();
    if (result) {
      return res.status(404).json({
        message: "user already exist",
      });
    } else {
      const registerUser = new user({
        email: req.body.email,
        coins: 100,
        password: req.body.password,
      });
      await registerUser.save();
      return res.status(201).json({
        message: "user created",
      });
    }
  } catch (err) {
    return res.status(404).json({
      message: err.message,
    });
  }
};

exports.loginuser = async (req, res) => {
  try {
    const email = req.body.email;
    const password = req.body.password;
    const useremail = await user.findOne({ email: email });
    const ismatch = await bcrypt.compare(password, useremail.password);
    if (ismatch) {
      res.status(202).json({
        message: "success",
      });
    } else {
      res.status(400).json({
        message: "invalid password",
      });
    }
  } catch (err) {
    res.status(400).json({
      message: err.message,
    });
  }
};
